import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/localized_map.dart';

void main() {
  group('LocalizedMap.resolve', () {
    test('returns the value for the requested language code', () {
      final map = {'pt': 'Olá', 'en': 'Hello'};

      expect(map.resolve('en'), 'Hello');
      expect(map.resolve('pt'), 'Olá');
    });

    test('falls back to Portuguese when the language code is missing', () {
      final map = {'pt': 'Olá', 'en': 'Hello'};

      expect(map.resolve('fr'), 'Olá');
    });

    test('falls back to any value when Portuguese is also missing', () {
      final map = {'en': 'Hello', 'es': 'Hola'};

      expect(map.resolve('fr'), anyOf('Hello', 'Hola'));
    });
  });
}
