import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/widgets/locale_button_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('offers English and switches to it when locale is Portuguese',
      (tester) async {
    Locale? changedTo;
    await pumpAppChild(
      tester,
      LocaleButtonWidget(changeLocale: (locale) => changedTo = locale),
      locale: const Locale('pt', 'BR'),
    );

    expect(find.text('EN'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    expect(changedTo, const Locale('en', 'US'));
  });

  testWidgets('offers Portuguese and switches to it when locale is English',
      (tester) async {
    Locale? changedTo;
    await pumpAppChild(
      tester,
      LocaleButtonWidget(changeLocale: (locale) => changedTo = locale),
      locale: const Locale('en', 'US'),
    );

    expect(find.text('PT'), findsOneWidget);

    await tester.tap(find.byType(TextButton));
    expect(changedTo, const Locale('pt', 'BR'));
  });
}
