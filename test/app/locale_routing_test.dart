import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/app/locale_paths.dart';
import 'package:ronip/app/routes.dart';
import 'package:ronip/app/routes_helper.dart';

import '../../tool/seo_content.dart' show seoPages, origin;

void main() {
  group('RpLocalePaths', () {
    test('reads the language from the path', () {
      expect(RpLocalePaths.languageOf('/'), 'pt');
      expect(RpLocalePaths.languageOf('/cv'), 'pt');
      expect(RpLocalePaths.languageOf('/en'), 'en');
      expect(RpLocalePaths.languageOf('/en/cv'), 'en');
      // Only a whole `en` segment counts.
      expect(RpLocalePaths.languageOf('/energy'), 'pt');
    });

    test('switches a page between languages', () {
      expect(RpLocalePaths.switchLanguage('/', 'en'), '/en');
      expect(RpLocalePaths.switchLanguage('/cv', 'en'), '/en/cv');
      expect(RpLocalePaths.switchLanguage('/en', 'pt'), '/');
      expect(RpLocalePaths.switchLanguage('/en/cv', 'pt'), '/cv');
      expect(RpLocalePaths.switchLanguage('/en/cv', 'en'), '/en/cv');
    });

    test('RpRoutes maps each path to its locale', () {
      expect(RpRoutes.localeFor('/en/cv'), const Locale('en', 'US'));
      expect(RpRoutes.localeFor('/cv'), const Locale('pt', 'BR'));
    });
  });

  test('sitemap.xml lists every page with its hreflang alternates', () {
    final sitemap = File('web/sitemap.xml').readAsStringSync();
    final locs = RegExp('<loc>([^<]*)</loc>')
        .allMatches(sitemap)
        .map((m) => m[1])
        .toSet();
    expect(locs, {for (final page in seoPages) page.url});
    for (final page in seoPages) {
      for (final MapEntry(key: hreflang, value: url)
          in page.alternates.entries) {
        expect(
          sitemap,
          contains('hreflang="$hreflang" href="$url"/>'),
          reason: '${page.url} alternate $hreflang',
        );
      }
    }
    expect(origin, 'https://ronipaschoal.com.br');
  });

  testWidgets(
      'switching language updates the page in place, keeping its state and '
      'an open dialog', (tester) async {
    GoRoute route(String path) => GoRoute(
          path: path,
          pageBuilder: (_, __) => RoutesHelper.transitionPage(
            key: const ValueKey('/'),
            _Counter(path: path),
          ),
        );
    final router = GoRouter(routes: [route('/'), route('/en')]);
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.tap(find.text('/ 0'));
    await tester.pump();
    final context = tester.element(find.text('/ 1'));
    showDialog<void>(
      context: context,
      builder: (_) => const Text('dialog'),
    );
    await tester.pumpAndSettle();

    RpRoutes.switchLanguage(context, const Locale('en', 'US'));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, '/en');
    // Same State (count kept), new path, and the dialog is still open.
    expect(find.text('/en 1'), findsOneWidget);
    expect(find.text('dialog'), findsOneWidget);
  });
}

class _Counter extends StatefulWidget {
  const _Counter({required this.path});

  final String path;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var _count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: TextButton(
          onPressed: () => setState(() => _count++),
          child: Text('${widget.path} $_count'),
        ),
      );
}
