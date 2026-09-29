import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/cv_item_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';

CvExperienceItem job(String company, String period) => CvExperienceItem(
      company: company,
      period: period,
      role: const {'pt': 'Dev'},
      description: const {'pt': 'Fez algo.'},
    );

void main() {
  group('groupByCompany', () {
    test('merges consecutive roles at a company, spanning all of them', () {
      final groups = CvCompanyGroup.groupByCompany([
        job('A', 'Jul/2025 - Jun/2026'),
        job('B', 'Mar/2022 - Abr/2025'),
        job('B', 'Dez/2021 - Mar/2022'),
        job('C', 'Jun/2014 - Jul/2016'),
      ]);

      expect(groups.map((g) => g.company), ['A', 'B', 'C']);
      expect(groups[1].roles, hasLength(2));
      expect(groups[1].period, 'Dez/2021 - Abr/2025');
      expect(groups[0].period, 'Jul/2025 - Jun/2026');
    });

    test('keeps non-consecutive entries at the same company apart', () {
      final groups = CvCompanyGroup.groupByCompany([
        job('A', 'Jan/2024 - Dez/2024'),
        job('B', 'Jan/2023 - Dez/2023'),
        job('A', 'Jan/2022 - Dez/2022'),
      ]);
      expect(groups.map((g) => g.company), ['A', 'B', 'A']);
    });

    test('groups the real résumé by employer', () {
      final companies = CvCompanyGroup.groupByCompany(cvExperienceList)
          .map((g) => g.company)
          .toList();
      expect(companies.toSet(), hasLength(companies.length));
    });
  });

  test('sentencesOf splits a description into bullet sentences', () {
    expect(
      CvExperienceItem.sentencesOf(
        'Definição da arquitetura. Criação de biblioteca via Dio. ',
      ),
      ['Definição da arquitetura.', 'Criação de biblioteca via Dio.'],
    );
  });

  for (final languageCode in ['pt', 'en']) {
    test('builds a PDF in $languageCode', () async {
      final bytes = await CvPdfBuilder.build(
        languageCode,
        layout: CvPdfLayout.classic,
      );
      expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
    });
  }
}
