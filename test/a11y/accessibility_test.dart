import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/widgets/decode_text_widget.dart';

import '../helpers/pump_app.dart';

void main() {
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

  testWidgets('decode text skips to the final title once reduce motion is on',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    Widget title({required bool reduceMotion}) => MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Directionality(
            textDirection: TextDirection.ltr,
            // Far below the viewport, so it would never reveal on its own.
            child: Transform.translate(
              offset: const Offset(0, 5000),
              child: RpDecodeTextWidget(
                text: 'Contact',
                scrollController: controller,
              ),
            ),
          ),
        );

    await tester.pumpWidget(title(reduceMotion: false));
    double opacity() => tester.widget<Opacity>(find.byType(Opacity)).opacity;
    expect(opacity(), 0.0);

    // Switched on mid-visit: picked up without a remount.
    await tester.pumpWidget(title(reduceMotion: true));
    expect(opacity(), 1.0);
    expect(find.text('Contact'), findsOneWidget);
  });
}
