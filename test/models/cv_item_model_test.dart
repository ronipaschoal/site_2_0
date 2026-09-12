import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/cv_item_model.dart';

void main() {
  group('CvExperienceItem', () {
    const item = CvExperienceItem(
      company: 'Acme',
      period: '2020 - 2021',
      role: {'pt': 'Engenheiro', 'en': 'Engineer'},
      description: {'pt': 'Descrição', 'en': 'Description'},
    );

    test('roleFor and descriptionFor resolve the requested language', () {
      expect(item.roleFor('en'), 'Engineer');
      expect(item.descriptionFor('en'), 'Description');
      expect(item.roleFor('pt'), 'Engenheiro');
    });

    test('roleFor falls back to Portuguese for an unknown language', () {
      expect(item.roleFor('fr'), 'Engenheiro');
    });
  });

  group('CvProjectItem', () {
    const item = CvProjectItem(
      title: 'Project',
      tech: ['Flutter', 'Dart'],
      description: {'pt': 'Descrição do projeto'},
      url: 'https://example.com',
    );

    test('descriptionFor falls back when the language is missing', () {
      expect(item.descriptionFor('en'), 'Descrição do projeto');
    });
  });

  group('CvLanguageItem', () {
    const item = CvLanguageItem(
      language: {'pt': 'Inglês', 'en': 'English'},
      level: {'pt': 'Fluente', 'en': 'Fluent'},
    );

    test('languageFor and levelFor resolve the requested language', () {
      expect(item.languageFor('en'), 'English');
      expect(item.levelFor('en'), 'Fluent');
    });
  });
}
