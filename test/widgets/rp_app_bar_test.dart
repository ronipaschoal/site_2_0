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
}
