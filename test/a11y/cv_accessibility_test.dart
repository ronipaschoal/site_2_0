import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('résumé exposes an h1, named links and no unlabelled text',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 4000);
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

    // Every text field node (SelectableText) must carry a name — unnamed ones
    // are announced as blank "edit text" boxes on web.
    final unnamed = tester.semantics
        .simulatedAccessibilityTraversal()
        .map((node) => node.getSemanticsData())
        .where((d) => d.flagsCollection.isTextField && d.label.isEmpty)
        .toList();
    expect(unnamed, isEmpty);

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });
}
