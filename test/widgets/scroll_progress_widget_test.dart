import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/widgets/scroll_progress_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('fills in step with the scroll position', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      SizedBox(
        height: 600,
        child: Column(
          children: [
            RpScrollProgressWidget(scrollController: controller),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: const SizedBox(height: 2000),
              ),
            ),
          ],
        ),
      ),
    );

    double widthFactor() => tester
        .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
        .widthFactor!;

    expect(widthFactor(), 0.0);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    expect(widthFactor(), 1.0);
  });
}
