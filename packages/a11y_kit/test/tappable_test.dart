import 'dart:ui' show SemanticsHitTestBehavior;

import 'package:a11y_kit/a11y_kit.dart';
import 'package:a11y_kit/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pump(WidgetTester tester, Widget child, {ThemeData? theme}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: child)),
      ),
    );

void main() {
  Widget link({
    required VoidCallback onTap,
    Duration? debounce,
    Size? minSize,
  }) => A11yTappable(
    url: 'https://example.com',
    semanticsLabel: 'LinkedIn',
    onTap: onTap,
    activationDebounce: debounce,
    minTapTargetSize: minSize,
    builder: (_, __) =>
        const Padding(padding: EdgeInsets.all(16.0), child: Text('LINKEDIN ↗')),
  );

  testWidgets('is announced as a named link with its URL', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, link(onTap: () {}));

    final data = tester
        .getSemantics(find.byType(A11yTappable))
        .getSemanticsData();
    expect(data.label, 'LinkedIn');
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.linkUrl, Uri.parse('https://example.com'));
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    handle.dispose();
  });

  testWidgets('is a button when there is no url', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      A11yTappable(onTap: () {}, builder: (_, __) => const Text('Open résumé')),
    );

    final data = tester
        .getSemantics(find.byType(A11yTappable))
        .getSemanticsData();
    expect(data.label, 'Open résumé');
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isLink, isFalse);
    handle.dispose();
  });

  testWidgets('is reachable with Tab and activated with Enter and Space', (
    tester,
  ) async {
    var taps = 0;
    await pump(tester, link(onTap: () => taps++));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    // Off the web there's no duplicate activation to collapse.
    expect(taps, 2);
  });

  testWidgets('collapses repeats within activationDebounce', (tester) async {
    var taps = 0;
    await pump(
      tester,
      link(onTap: () => taps++, debounce: const Duration(seconds: 1)),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('draws the focus ring in the A11yTheme color', (tester) async {
    const ring = Color(0xFFB8290C);
    await pump(
      tester,
      link(onTap: () {}),
      theme: ThemeData(extensions: const [A11yTheme(focusColor: ring)]),
    );
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    final box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(A11yTappable),
        matching: find.byType(DecoratedBox),
      ),
    );
    final border = (box.decoration as BoxDecoration).border! as Border;
    expect(border.top.color, ring);
  });

  testWidgets('minTapTargetSize grows a small icon to a compliant target', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var taps = 0;
    // A button, not a link: the tap target guidelines skip links.
    Widget icon({Size? minSize}) => A11yTappable(
      semanticsLabel: 'Copy',
      onTap: () => taps++,
      minTapTargetSize: minSize,
      builder: (_, __) => const Icon(Icons.copy, size: 16.0),
    );

    await pump(tester, icon());
    final undersized = await a11yAndroidTapTargetGuideline.evaluate(tester);
    expect(undersized.passed, isFalse);

    await pump(tester, icon(minSize: const Size.square(48.0)));
    expect(tester.getSize(find.byType(A11yTappable)), const Size(48.0, 48.0));
    // The added padding is tappable too.
    await tester.tapAt(
      tester.getTopLeft(find.byType(A11yTappable)) + const Offset(2.0, 2.0),
    );
    expect(taps, 1);
    await expectMeetsA11yGuidelines(tester, textContrast: false);
    handle.dispose();
  });

  testWidgets('tap target checks ignore selectable text', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const A11ySelectableText('A short line'));
    await expectLater(tester, meetsGuideline(a11yAndroidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(a11yIOSTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('passThroughPointer makes the node transparent to clicks', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      A11yTappable(
        semanticsLabel: 'Proxy',
        onTap: () {},
        passThroughPointer: true,
        builder: (_, __) => const SizedBox.square(dimension: 48.0),
      ),
    );

    final data = tester
        .getSemantics(find.byType(A11yTappable))
        .getSemanticsData();
    expect(data.hitTestBehavior, SemanticsHitTestBehavior.transparent);
    handle.dispose();
  });
}
