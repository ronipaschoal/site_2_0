import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ronip/config/routes.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          // Forces the whole page tree (including go_router's persisted
          // Navigator pages) to remount on a theme toggle. Widgets read
          // RpTheme's color getters as plain static values at build time,
          // not through an InheritedWidget, so an ancestor rebuild alone
          // wouldn't reach pages the Navigator keeps mounted (their own
          // State.build never reruns just because MaterialApp got a new
          // ThemeData) — a changed key forces a real rebuild instead of an
          // update, so every one of those reads picks up the new palette.
          key: ValueKey(state.brightness),
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
          theme: RpTheme.theme,
        );
      },
    );
  }
}
