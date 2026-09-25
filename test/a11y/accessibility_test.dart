import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/widgets/tappable_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  group('RpTappableWidget', () {
    Widget link({required VoidCallback onTap}) => RpTappableWidget(
          url: 'https://example.com',
          semanticsLabel: 'LinkedIn',
          onTap: onTap,
          builder: (_, __) => const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('LINKEDIN ↗'),
          ),
        );

    testWidgets('is announced as a named link with its URL', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpAppChild(tester, link(onTap: () {}));

      final node = tester.getSemantics(find.byType(RpTappableWidget));
      expect(node.label, 'LinkedIn');
      expect(node.flagsCollection.isLink, isTrue);
      expect(node.getSemanticsData().linkUrl, Uri.parse('https://example.com'));
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('is reachable with Tab and activated with the keyboard',
        (tester) async {
      var taps = 0;
      await pumpAppChild(tester, link(onTap: () => taps++));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);

      // A second activation right away (e.g. the same Enter also reaching a
      // semantic <a> as a click, on web) is collapsed into the first.
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 1);
    });
  });

  testWidgets('home section titles are h2 headings named after the title',
      (tester) async {
    final handle = tester.ensureSemantics();
    await pumpAppChild(
      tester,
      HomeSectionTitleWidget(
        index: 1,
        title: 'About Me',
        scrollController: ScrollController(),
      ),
    );

    final heading = find.bySemanticsLabel('About Me');
    expect(heading, findsOneWidget);
    expect(tester.getSemantics(heading).getSemanticsData().headingLevel, 2);
    // The decorative "[01]" marker stays out of the reading order.
    expect(find.bySemanticsLabel(RegExp(r'\[01\]')), findsNothing);

    // Let the decode/reveal animation finish so contrast is measured on
    // the final, fully opaque title.
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
