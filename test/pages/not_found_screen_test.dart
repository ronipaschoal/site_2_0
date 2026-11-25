import 'package:a11y_kit/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/app/routes.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/not_found/not_found_route.dart';
import 'package:ronip/pages/not_found/not_found_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  /// A router with the app's 404 error page at
  /// [location], in the locale that path is served in.
  Future<GoRouter> pumpRouter(WidgetTester tester, String location) async {
    final router = GoRouter(
      initialLocation: location,
      routes: [GoRoute(path: '/', builder: (_, __) => const Text('home'))],
      errorPageBuilder: (_, state) => NotFoundRoute.page(state),
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        theme: RpTheme.themeFor(Brightness.dark),
        locale: RpRoutes.localeFor(location),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      ),
    );
    await tester.pump();
    return router;
  }

  testWidgets('an unknown path shows the 404 screen, not an exception',
      (tester) async {
    final router = await pumpRouter(tester, '/nao-existe');

    expect(find.byType(NotFoundScreen), findsOneWidget);
    expect(find.text('Os gatos dormiram em cima desta página'), findsOneWidget);
    expect(find.text('GET /nao-existe → 404'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.text('VOLTAR PARA O INÍCIO'));
    await tester.pump();
    await tester.tap(find.text('VOLTAR PARA O INÍCIO'));
    await tester.pump(const Duration(seconds: 1));
    expect(router.routerDelegate.currentConfiguration.uri.path, '/');
  });

  testWidgets('an unknown /en path shows it in English, linking to /en',
      (tester) async {
    await pumpRouter(tester, '/en/nope');

    expect(find.text('The cats fell asleep on this page'), findsOneWidget);
    final screen = tester.widget<NotFoundScreen>(find.byType(NotFoundScreen));
    expect(screen.homePath, '/en');
  });

  testWidgets('404 screen: one h1, labelled photo, accessible link',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(
      tester,
      const NotFoundScreen(path: '/x', homePath: '/'),
      locale: const Locale('en', 'US'),
    );
    await tester.pump();

    final heading = find.bySemanticsLabel('The cats fell asleep on this page');
    expect(tester.getSemantics(heading).getSemanticsData().headingLevel, 1);
    expect(find.bySemanticsLabel(RegExp('^Two cats curled up')), findsOne);
    expect(find.bySemanticsLabel('Back to home'), findsOneWidget);
    // Decorative bits stay out of the reading order.
    expect(find.bySemanticsLabel(RegExp(r'\[404\]|GET /x')), findsNothing);

    await expectMeetsA11yGuidelines(tester);
    handle.dispose();
  });

  testWidgets('the z z z stays still with reduce motion on', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: RpTheme.themeFor(Brightness.dark),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const NotFoundScreen(path: '/x', homePath: '/'),
          ),
        ),
      ),
    );
    await tester.pump();
    // No ticker left running: nothing to settle.
    expect(tester.hasRunningAnimations, isFalse);
  });
}
