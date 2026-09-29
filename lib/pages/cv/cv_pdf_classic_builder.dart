import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ronip/models/cv_item_model.dart';
import 'package:ronip/models/localized_map.dart';
import 'package:ronip/pages/cv/cv_data.dart';

/// The classic, single-column résumé: the conventional Brazilian layout
/// recruiters and ATS parsers expect — header with personal details and
/// links, then Objective, Professional Summary, Education, Experience
/// (grouped by company, one bullet per achievement), Courses and
/// Additional Information, all in plain black type.
///
/// Built from the same `cv_data.dart` content as the on-screen résumé and
/// the two-column PDF (`CvPdfBuilder`), so all three stay in sync. Like
/// that one, it uses the PDF standard Helvetica faces, which the `pdf`
/// package only maps for Latin-1: separators are plain hyphens (no en
/// dash) and bullets are drawn as dots rather than typed as `•`.
sealed class CvPdfClassicBuilder {
  static const _ink = PdfColor.fromInt(0xFF1A1A1A);
  static const _muted = PdfColor.fromInt(0xFF555555);
  static const _rule = PdfColor.fromInt(0xFF999999);

  /// Links print in the conventional blue, underlined, so they read as
  /// clickable on screen and still stand out on paper.
  static const _link = pw.TextStyle(
    color: PdfColor.fromInt(0xFF1A4DB3),
    decoration: pw.TextDecoration.underline,
  );

  static const _labels = {
    'pt': {
      'objective': 'Objetivo',
      'summary': 'Resumo Profissional',
      'education': 'Formação Acadêmica',
      'experience': 'Experiência Profissional',
      'courses': 'Cursos e Qualificações',
      'additional': 'Informações Adicionais',
      'skills': 'Competências técnicas',
      'projects': 'Projetos pessoais',
      'age': 'anos',
      'travel': 'Disponibilidade para viagens.',
    },
    'en': {
      'objective': 'Objective',
      'summary': 'Professional Summary',
      'education': 'Education',
      'experience': 'Professional Experience',
      'courses': 'Courses and Qualifications',
      'additional': 'Additional Information',
      'skills': 'Technical skills',
      'projects': 'Personal projects',
      'age': 'years old',
      'travel': 'Available to travel.',
    },
  };

  static Future<Uint8List> build(String languageCode, PdfPageFormat format) {
    final l = _labels[languageCode] ?? _labels['pt']!;

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: format,
          margin: const pw.EdgeInsets.symmetric(horizontal: 42, vertical: 36),
        ),
        build: (context) => [
          _header(l),
          _section(l['objective']!),
          _paragraph(cvObjective[languageCode] ?? cvObjective['pt']!),
          _section(l['summary']!),
          _paragraph(cvSummary[languageCode] ?? cvSummary['pt']!),
          _section(l['education']!),
          for (final item in cvEducationList) _education(item),
          _section(l['experience']!),
          for (final (i, group)
              in CvCompanyGroup.groupByCompany(cvExperienceList).indexed)
            ..._company(group, languageCode, isFirst: i == 0),
          _section(l['courses']!),
          for (final item in cvCertificationList)
            // Year only ('Abr/2026' -> '2026'), as in the Education section.
            _bullet(
              ' - ${item.issuer} - ${item.date.split('/').last}',
              boldLead: item.title,
            ),
          _section(l['additional']!),
          ..._additional(l, languageCode),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _header(Map<String, String> l) {
    final age = DateTime.now().year - cvBirthYear;
    const detail = pw.TextStyle(fontSize: 10, color: _ink);

    pw.Widget link(String text, String url) => pw.RichText(
          text: pw.TextSpan(
            text: text,
            style: detail.merge(_link),
            annotation: pw.AnnotationUrl(url),
          ),
        );

    final email = cvContactList.firstWhere(
      (c) => c.type == CvContactType.email,
    );
    final others = cvContactList.where((c) => c.type != CvContactType.email);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Roni Paschoal',
          style:
              const pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        // Only the birth year is tracked, so the age stands alone.
        pw.Text('$age ${l['age']}', style: detail),
        pw.Text('Santo André - SP', style: detail),
        link(cvPhone.text, cvPhone.url),
        link(email.text, email.url),
        for (final contact in others) link(contact.text, contact.url),
      ],
    );
  }

  static pw.Widget _section(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
      child: pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.only(bottom: 2),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.6)),
        ),
        child: pw.Text(
          title.toUpperCase(),
          style: const pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  static pw.Widget _paragraph(String text) => pw.Text(
        text,
        textAlign: pw.TextAlign.justify,
        style: const pw.TextStyle(fontSize: 10, color: _ink, lineSpacing: 2),
      );

  /// Only the field of study in bold ("MBA em **Engenharia de
  /// Software**"), then institution and period in regular weight. The
  /// degree is whatever precedes the first " em "; a course without one is
  /// bolded whole.
  static pw.Widget _education(CvEducationItem item) {
    final split = item.course.indexOf(' em ');
    final degree = split < 0 ? '' : item.course.substring(0, split + 4);
    final field = item.course.substring(degree.length);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 10, color: _ink),
          children: [
            pw.TextSpan(text: degree),
            pw.TextSpan(
              text: field,
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: ' - ${item.institution} - ${item.period}'),
          ],
        ),
      ),
    );
  }

  /// A bullet line; [boldLead], when given, is printed in bold right
  /// before [text] — as a link to [boldLeadUrl] when that is given too.
  static pw.Widget _bullet(
    String text, {
    String? boldLead,
    String? boldLeadUrl,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 6, bottom: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 3,
              height: 3,
              margin: const pw.EdgeInsets.only(top: 4.5, right: 7),
              decoration: const pw.BoxDecoration(
                color: _ink,
                shape: pw.BoxShape.circle,
              ),
            ),
            pw.Expanded(
              child: pw.RichText(
                text: pw.TextSpan(
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: _ink,
                    lineSpacing: 1.5,
                  ),
                  children: [
                    if (boldLead != null && boldLeadUrl != null)
                      pw.TextSpan(
                        text: boldLead,
                        style: _link.copyWith(fontWeight: pw.FontWeight.bold),
                        annotation: pw.AnnotationUrl(boldLeadUrl),
                      )
                    else if (boldLead != null)
                      pw.TextSpan(
                        text: boldLead,
                        style: const pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    pw.TextSpan(text: text),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  /// "Company - start - end", then each role: with its own period when the
  /// company had more than one, and its description as bullets.
  static List<pw.Widget> _company(
    CvCompanyGroup group,
    String languageCode, {
    required bool isFirst,
  }) {
    final companyDescription =
        cvCompanyDescriptions[group.company]?.resolve(languageCode);
    final contractor =
        cvCompanyContractors[group.company]?.resolve(languageCode);

    return [
      pw.Padding(
        // The first company sits right under the section heading.
        padding: pw.EdgeInsets.only(top: isFirst ? 6 : 16, bottom: 2),
        child: pw.Text(
          '${group.company} - ${group.period}',
          style: const pw.TextStyle(
            fontSize: 10.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      for (final note in [companyDescription, contractor].nonNulls)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Text(
            note,
            style: const pw.TextStyle(
              fontSize: 10,
              color: _muted,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ),
      for (final (i, role) in group.roles.indexed) ...[
        pw.Padding(
          // Bottom leaves one blank 10pt line before the bullets; a later
          // role at the same company gets extra room above it.
          padding: pw.EdgeInsets.only(top: i == 0 ? 2 : 10, bottom: 14),
          child: pw.Text(
            group.hasMultipleRoles
                ? '${role.roleFor(languageCode)} - '
                    '${role.period}'
                : role.roleFor(languageCode),
            style: const pw.TextStyle(fontSize: 10, color: _ink),
          ),
        ),
        for (final highlight in role.highlightsFor(languageCode))
          _bullet(highlight),
      ],
    ];
  }

  /// Technical skills and personal projects, each under its own bold
  /// heading, then languages and travel availability — relevant for a
  /// developer but with no dedicated section in this layout.
  static List<pw.Widget> _additional(
    Map<String, String> l,
    String languageCode,
  ) {
    return [
      _subheading(l['skills']!),
      for (final group in cvClassicSkillGroups)
        _bullet(
          group.items.resolve(languageCode),
          boldLead: '${group.label.resolve(languageCode)}: ',
        ),
      _subheading(l['projects']!),
      for (final project in cvProjectList)
        _bullet(
          ': ${project.descriptionFor(languageCode)}',
          boldLead: project.title,
          boldLeadUrl: project.url,
        ),
      pw.SizedBox(height: 8),
      for (final item in cvLanguageList)
        _bullet(
          '${[
            item.levelFor(languageCode),
            if (item.usageFor(languageCode) case final usage?)
              usage.replaceRange(0, 1, usage[0].toLowerCase()),
          ].join(' - ')}.',
          boldLead: '${item.languageFor(languageCode)}: ',
        ),
      _bullet(l['travel']!),
    ];
  }

  /// A bold heading inside a section, e.g. "Competências técnicas".
  static pw.Widget _subheading(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 6, bottom: 3),
        child: pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 10,
            color: _ink,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
}
