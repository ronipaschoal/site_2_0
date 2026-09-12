import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/locale_model.dart';

void main() {
  group('LocaleEnum', () {
    test('pt maps to the pt_BR locale', () {
      expect(LocaleEnum.pt.locale.languageCode, 'pt');
      expect(LocaleEnum.pt.locale.countryCode, 'BR');
      expect(LocaleEnum.pt.text, 'PT');
    });

    test('en maps to the en_US locale', () {
      expect(LocaleEnum.en.locale.languageCode, 'en');
      expect(LocaleEnum.en.locale.countryCode, 'US');
      expect(LocaleEnum.en.text, 'EN');
    });
  });
}
