import 'package:a11y_kit/a11y_kit.dart';
import 'package:a11y_kit/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('A11yHeading exposes its level and label', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const A11yHeading(level: 2, label: 'About me', child: Text('4BØUT M3')),
    );

    final data = tester
        .getSemantics(find.byType(A11yHeading))
        .getSemanticsData();
    expect(data.headingLevel, 2);
    expect(data.label, 'About me');
    expect(find.bySemanticsLabel('4BØUT M3'), findsNothing);
    handle.dispose();
  });

  testWidgets('A11yCapsText shows uppercase, reads natural case', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const A11yCapsText('Open to work'));

    expect(find.text('OPEN TO WORK'), findsOneWidget);
    expect(find.bySemanticsLabel('Open to work'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('A11ySelectableText is named and can be a heading', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const Column(
        children: [
          A11ySelectableText('Roni Paschoal', headingLevel: 1),
          A11ySelectableText('Summary text'),
        ],
      ),
    );

    final name = find.bySemanticsLabel('Roni Paschoal');
    expect(tester.getSemantics(name).getSemanticsData().headingLevel, 1);
    expect(unnamedTextFields(tester), isEmpty);
    handle.dispose();
  });

  testWidgets('unnamedTextFields catches an unlabelled field', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const TextField());
    expect(unnamedTextFields(tester), hasLength(1));
    handle.dispose();
  });

  testWidgets('A11yLocale tags the subtree with the language code only', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const A11yLocale(locale: Locale('pt', 'BR'), child: Text('Olá')),
    );

    final data = tester.getSemantics(find.text('Olá')).getSemanticsData();
    expect(data.locale, const Locale('pt'));
    handle.dispose();
  });

  testWidgets('A11yReadingGroup keeps a column together', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(
      tester,
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          A11yReadingGroup(child: Column(children: [Text('A1'), Text('A2')])),
          A11yReadingGroup(child: Column(children: [Text('B1'), Text('B2')])),
        ],
      ),
    );

    final order = tester.semantics
        .simulatedAccessibilityTraversal()
        .map((n) => n.label)
        .where((l) => l.isNotEmpty)
        .toList();
    expect(order, ['A1', 'A2', 'B1', 'B2']);
    handle.dispose();
  });

  testWidgets('A11yPointerPassThrough lets taps reach what is underneath', (
    tester,
  ) async {
    var under = 0;
    await pump(
      tester,
      SizedBox.square(
        key: const Key('area'),
        dimension: 100.0,
        child: Stack(
          children: [
            Positioned.fill(child: GestureDetector(onTap: () => under++)),
            Positioned.fill(
              child: A11yPointerPassThrough(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('area')), warnIfMissed: false);
    expect(under, 1);
  });
}
