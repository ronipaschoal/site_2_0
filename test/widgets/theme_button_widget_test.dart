import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/widgets/theme_button_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows the light-mode icon in dark theme and toggles on tap',
      (tester) async {
    var toggled = false;
    await pumpAppChild(
      tester,
      ThemeButtonWidget(toggleTheme: () => toggled = true),
      brightness: Brightness.dark,
    );

    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);

    await tester.tap(find.byType(IconButton));
    expect(toggled, isTrue);
  });

  testWidgets('shows the dark-mode icon in light theme', (tester) async {
    await pumpAppChild(
      tester,
      ThemeButtonWidget(toggleTheme: () {}),
      brightness: Brightness.light,
    );

    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    expect(find.byIcon(Icons.light_mode_outlined), findsNothing);
  });
}
