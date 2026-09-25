import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/widgets/command_palette_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  group('RpCommand.matches', () {
    final command = RpCommand(
      label: 'Toggle light/dark theme',
      icon: Icons.contrast,
      keywords: 'tema escuro',
      run: () {},
    );

    test('matches every term against label and keywords, ignoring case', () {
      expect(command.matches(''), isTrue);
      expect(command.matches('THEME'), isTrue);
      expect(command.matches('dark tema'), isTrue);
      expect(command.matches('resume'), isFalse);
    });
  });

  testWidgets('filters, moves the selection and runs the chosen command',
      (tester) async {
    final ran = <String>[];
    RpCommand command(String label) =>
        RpCommand(label: label, icon: Icons.circle, run: () => ran.add(label));

    await pumpAppChild(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => RpCommandPaletteWidget.show(context, [
            command('Go to About'),
            command('Go to Contact'),
            command('Open résumé'),
          ]),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Open résumé'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'go to');
    await tester.pump();
    expect(find.text('Open résumé'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(ran, ['Go to Contact']);
    expect(find.byType(RpCommandPaletteWidget), findsNothing);
  });
}
