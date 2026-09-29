import 'package:a11y_kit/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('résumé exposes an h1, named links and no unlabelled text',
      (tester) async {
    // Tall enough that every section title has scrolled past its reveal
    // point, so contrast is measured on the final text.
    tester.view.physicalSize = const Size(1400, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final handle = tester.ensureSemantics();
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: CvContentWidget(scrollController: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final name = find.bySemanticsLabel('Roni Paschoal');
    expect(tester.getSemantics(name).getSemanticsData().headingLevel, 1);

    final linkedIn = find.bySemanticsLabel('linkedin.com/in/roni-paschoal');
    final data = tester.getSemantics(linkedIn).getSemanticsData();
    expect(data.flagsCollection.isLink, isTrue);
    expect(data.linkUrl.toString(), contains('linkedin.com'));

    // Labels, contrast, 48/44px tap targets (the contact icons are 16px
    // drawn), and no unnamed SelectableText — read as a blank "edit text" box
    // on web.
    await expectMeetsA11yGuidelines(tester);
    handle.dispose();
  });
}
