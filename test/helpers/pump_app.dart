import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';

/// Pumps [home] inside the app's usual `MaterialApp` scaffolding — theme
/// (via [RpTheme.themeFor]) and localizations — so widgets that read
/// `context.rpColors` or `AppLocalizations.of(context)` behave the same way
/// they do in the running app.
Future<void> pumpApp(
  WidgetTester tester,
  Widget home, {
  Brightness brightness = Brightness.dark,
  Locale locale = const Locale('en', 'US'),
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: RpTheme.themeFor(brightness),
      locale: locale,
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
      home: home,
    ),
  );
}

/// Like [pumpApp], but wraps [child] in a [Scaffold] — most interactive
/// widgets (buttons, `IconButton`) need a `Material` ancestor to render.
Future<void> pumpAppChild(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.dark,
  Locale locale = const Locale('en', 'US'),
}) {
  return pumpApp(
    tester,
    Scaffold(body: Center(child: child)),
    brightness: brightness,
    locale: locale,
  );
}
