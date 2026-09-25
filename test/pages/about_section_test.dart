import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/home/sections/about_section.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('bento tiles in the same row share the same height',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 5000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: AboutSection(scrollController: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Size tileOf(String value) => tester.getSize(
          find
              .ancestor(
                of: find.text(value),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );

    // 3-column row: "Core stack", "Platforms shipped", "Secondary stacks".
    final secondary = tileOf('TypeScript · Angular · React · Go');
    expect(
      tileOf('Flutter · Dart · BLoC · Dio · get_it').height,
      secondary.height,
    );
    expect(tileOf('Android · iOS · Smart POS').height, secondary.height);

    // First row: the experience figures, whose captions differ in length
    // ("years in hybrid mobile development" is the longest).
    final hybrid = tileOf('5+');
    expect(tileOf('8+').height, hybrid.height);
    expect(tileOf('3+').height, hybrid.height);
  });
}
