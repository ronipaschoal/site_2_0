import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ronip/app/routes.dart';
import 'package:ronip/core/semantic_links/semantic_links.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter Web renders to a canvas and, by default, only builds its
  // accessibility DOM after the visitor finds and presses a hidden
  // "Enable accessibility" button — so screen readers would otherwise see
  // an empty page. Keeping semantics always on trades a little per-frame
  // work for a site that's readable from the first load.
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  guardSemanticLinks();

  // A previous visit's explicit choice wins; otherwise fall back to the
  // system/browser's current preference for this first render.
  final initialBrightness = await AppCubit.loadSavedBrightness() ??
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  runApp(
    BlocProvider(
      create: (context) => AppCubit(initialBrightness: initialBrightness),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.locale != current.locale ||
          previous.brightness != current.brightness,
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Roni Paschoal - Engenheiro de Software Flutter',
          locale: state.locale,
          debugShowCheckedModeBanner: false,
          routerConfig: RpRoutes.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          theme: RpTheme.themeFor(state.brightness),
          // The app-level locale isn't propagated to the semantics tree, so
          // without this screen readers pick their voice from the browser
          // language (e.g. reading the Portuguese copy with an English
          // voice). On web this becomes a `lang` attribute on the root node;
          // language-only, since the engine writes `Locale.toString()`
          // ("pt_BR"), which isn't a valid BCP 47 tag, while "pt" is.
          builder: (context, child) => Semantics(
            localeForSubtree:
                Locale(Localizations.localeOf(context).languageCode),
            child: child!,
          ),
        );
      },
    );
  }
}
