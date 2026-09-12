import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('reveals its child only once scrolled near the viewport',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = ScrollController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            const SizedBox(height: 1000),
            RpRevealOnScrollWidget(
              scrollController: controller,
              duration: const Duration(milliseconds: 200),
              child: const Text('Revealed'),
            ),
            const SizedBox(height: 400),
          ],
        ),
      ),
    );

    double opacity() => tester.widget<Opacity>(find.byType(Opacity)).opacity;

    // Starts out of view, so it hasn't revealed yet.
    expect(opacity(), 0.0);

    // A real scroll gesture, rather than jumpTo, so layout catches up with
    // the new position the same way it does for an actual user scrolling.
    await tester.fling(
      find.byType(SingleChildScrollView),
      const Offset(0, -900),
      4000,
    );
    await tester.pumpAndSettle();

    expect(opacity(), 1.0);
    expect(find.text('Revealed'), findsOneWidget);
  });
}
