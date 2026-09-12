import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/work_item_model.dart';

void main() {
  const item = WorkItem(
    tag: 'Web · Flutter',
    image: 'assets/images/photos/example.png',
    url: 'https://example.com',
    title: {'pt': 'Título', 'en': 'Title'},
    description: {'pt': 'Descrição', 'en': 'Description'},
  );

  group('WorkItem', () {
    test('titleFor and descriptionFor resolve by locale language code', () {
      expect(item.titleFor(const Locale('en', 'US')), 'Title');
      expect(item.descriptionFor(const Locale('en', 'US')), 'Description');
      expect(item.titleFor(const Locale('pt', 'BR')), 'Título');
    });

    test('falls back to Portuguese for an unmapped locale', () {
      expect(item.titleFor(const Locale('es', 'ES')), 'Título');
    });

    test('urlApple defaults to null when not provided', () {
      expect(item.urlApple, isNull);
    });
  });
}
