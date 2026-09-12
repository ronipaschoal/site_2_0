import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/home/widgets/home_contact_item_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('renders its text/icon and calls onPressed when tapped',
      (tester) async {
    var pressed = false;
    await pumpAppChild(
      tester,
      HomeContactItemWidget(
        text: 'GitHub',
        icon: const Icon(Icons.link),
        onPressed: () => pressed = true,
      ),
    );

    expect(find.text('GitHub'), findsOneWidget);
    expect(find.byIcon(Icons.link), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    expect(pressed, isTrue);
  });
}
