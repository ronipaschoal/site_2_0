import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';
import 'package:ronip/pages/cv/cv_data.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('cvFocusFrom', () {
    test('falls back to Flutter when missing or blank', () {
      expect(cvFocusFrom(null), cvDefaultFocus);
      expect(cvFocusFrom('  '), cvDefaultFocus);
    });

    test('trims the parameter but keeps its casing', () {
      expect(cvFocusFrom(' híbrido '), 'híbrido');
      expect(cvFocusFrom('React Native'), 'React Native');
    });
  });

  test('the default focus keeps the Flutter copy', () {
    expect(cvRoleFor('pt'), 'Desenvolvedor de Software Mobile Flutter');
    expect(cvObjectiveFor('en'), 'To work as a Flutter Mobile Developer.');
    expect(cvStackLineFor(), 'Flutter · Dart · Android · iOS');
  });

  testWidgets('another focus replaces Flutter in the header and objective',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await pumpAppChild(
      tester,
      SingleChildScrollView(
        controller: controller,
        child: CvContentWidget(scrollController: controller, focus: 'híbrido'),
      ),
      locale: const Locale('pt'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('DESENVOLVEDOR DE SOFTWARE MOBILE HÍBRIDO'),
      findsOneWidget,
    );
    expect(find.text('Híbrido · Android · iOS'), findsOneWidget);
    expect(
      find.text('Atuar como Desenvolvedor Mobile Híbrido.'),
      findsOneWidget,
    );
  });
}
