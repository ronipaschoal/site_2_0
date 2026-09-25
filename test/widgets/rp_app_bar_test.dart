import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/rp_app_bar.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('renders leading, title and actions with the menu color',
      (tester) async {
    await pumpApp(
      tester,
      const Scaffold(
        appBar: RpAppBar(
          leading: Icon(Icons.menu),
          title: Text('Roni Paschoal'),
          actions: [Icon(Icons.settings)],
        ),
        body: SizedBox(),
      ),
      brightness: Brightness.dark,
    );

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('Roni Paschoal'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, RpColors.dark.menuColor);
    expect(appBar.surfaceTintColor, RpColors.dark.menuColor);
  });

  testWidgets(
      'with maxContentWidth, spans the window but aligns its content to '
      'the centered column', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpApp(
      tester,
      const Scaffold(
        appBar: RpAppBar(
          maxContentWidth: 1200.0,
          title: Text('Roni Paschoal'),
          actions: [Icon(Icons.settings)],
        ),
        body: SizedBox(),
      ),
    );

    expect(tester.getSize(find.byType(AppBar)).width, 1600.0);
    // (1600 - 1200) / 2 = 200px column margin, + 16px title spacing.
    expect(tester.getTopLeft(find.text('Roni Paschoal')).dx, 216.0);
    expect(tester.getTopRight(find.byIcon(Icons.settings)).dx, 1400.0);
  });
}
