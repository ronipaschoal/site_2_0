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

    CvExperienceItem withPeriod(String period) => CvExperienceItem(
          company: 'Acme',
          period: period,
          role: const {'pt': 'Engenheiro'},
          description: const {'pt': 'Descrição'},
        );

    test('durationInMonths counts both start and end months', () {
      expect(withPeriod('Jul/2025 - Jun/2026').durationInMonths, 12);
      expect(withPeriod('Mar/2022 - Abr/2025').durationInMonths, 38);
      expect(withPeriod('Jan/2020 - Jan/2020').durationInMonths, 1);
    });

    test('durationInMonths is null for unparseable periods', () {
      expect(item.durationInMonths, isNull);
      expect(withPeriod('Jun/2026 - Jan/2020').durationInMonths, isNull);
    });

    test('durationFor formats years and months per language', () {
      final multi = withPeriod('Mar/2022 - Abr/2025');
      expect(multi.durationFor('pt'), '3 anos e 2 meses');
      expect(multi.durationFor('en'), '3 yrs 2 mos');

      final single = withPeriod('Dez/2020 - Dez/2021');
      expect(single.durationFor('pt'), '1 ano e 1 mês');
      expect(single.durationFor('en'), '1 yr 1 mo');

      expect(withPeriod('Dez/2021 - Abr/2022').durationFor('pt'), '5 meses');
      expect(withPeriod('Jul/2025 - Jun/2026').durationFor('pt'), '1 ano');
    });

    test('periodWithDurationFor appends the duration when available', () {
      expect(
        withPeriod('Jul/2025 - Jun/2026').periodWithDurationFor('pt'),
        'Jul/2025 - Jun/2026 · 1 ano',
      );
      expect(item.periodWithDurationFor('pt'), '2020 - 2021');
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
