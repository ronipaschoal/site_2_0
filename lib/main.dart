import 'package:a11y_kit/a11y_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ronip/app/routes.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web only: semantics always on (no hidden "Enable accessibility"
  // button between screen readers and the page) and semantic links that
  // don't also navigate the tab away. A no-op on Android and iOS.
  A11y.ensureInitialized();

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
          title: 'Roni Paschoal - Desenvolvedor de Software Mobile Flutter',
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
          // Screen readers pick their voice from the app's locale rather
          // than the device/browser language.
          builder: A11yLocale.appBuilder,
        );
      },
    );
  }
}
