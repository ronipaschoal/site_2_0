import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ronip/models/cv_item_model.dart';
import 'package:ronip/models/localized_map.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/cv/cv_pdf_classic_builder.dart';
import 'package:ronip/pages/cv/cv_pdf_layout.dart';

export 'package:ronip/pages/cv/cv_pdf_layout.dart';

/// Builds the résumé as a paginated PDF — from the same content as
/// `CvContentWidget` in `cv_data.dart` — and hands it to the platform's
/// share/save sheet (a direct file download on web, native share sheet
/// elsewhere) as a ready file, rather than opening a print dialog.
///
/// A print dialog's own "save as PDF" step re-renders the document through
/// the browser/OS printing pipeline, which — for a paginated PDF shown via
/// an embedded viewer — commonly rasterizes pages past the first and drops
/// their link annotations (e.g. the Personal Projects links, which land on
/// page 2 once the résumé grows past one page). Sharing the already-built
/// bytes directly sidesteps that pipeline entirely, so every link stays
/// clickable regardless of which page it ends up on.
///
/// This generates an actual document rather than asking the browser to
/// print the page directly, because Flutter web only paints the portion of
/// a scrollable view that's currently visible on screen — a plain
/// `window.print()` would cut off everything scrolled out of view. A
/// [pw.MultiPage] paginates properly regardless of content length.
///
/// Mirrors the on-screen two-column shape: a sidebar with contact info and
/// skills, painted full-height via [pw.PageTheme.buildBackground] on every
/// generated page, with the flowing main column
/// (objective/summary/experience/certifications/education) padded clear of it. Both
/// columns stay white — print-friendly, no ink-heavy fills — separated by
/// a thin rule instead of a color block. The sidebar's own content is only
/// drawn on page 1 — it's short enough to always fit there — later pages
/// just carry the rule.
///
/// Uses the PDF standard Helvetica faces (built into every PDF reader, via
/// WinAnsiEncoding — full coverage for Portuguese diacritics) rather than a
/// downloaded or bundled TrueType font, so the export never depends on a
/// network fetch and opens instantly.
sealed class CvPdfBuilder {
  static const _sidebarWidth = 130.0;
  static const _gutter = 16.0;
  static const _pageMargin = 18.0;

  static const _brand = PdfColor.fromInt(0xFFC92F10);
  static const _muted = PdfColor.fromInt(0xFF6B6B6B);
  static const _ink = PdfColor.fromInt(0xFF1A1A1A);
  static const _hairline = PdfColor.fromInt(0xFFDDDDDD);

  // Section labels only — kept here (not in ARB) because this builder has
  // no BuildContext to read AppLocalizations from.
  static const _labels = {
    'pt': {
      'role': 'Desenvolvedor de Software Mobile Flutter',
      'contact': 'Contato',
      'skills': 'Competências',
      'objective': 'Objetivo',
      'summary': 'Resumo',
      'experience': 'Experiência Profissional',
      'projects': 'Projetos Pessoais',
      'certifications': 'Certificações',
      'education': 'Formação Acadêmica',
      'mobile': 'Mobile',
      'architecture': 'Arquitetura',
      'fullstack': 'Fullstack',
      'tools': 'Ferramentas',
      'languages': 'Idiomas',
      'age': 'anos',
    },
    'en': {
      'role': 'Flutter Mobile Software Developer',
      'contact': 'Contact',
      'skills': 'Skills',
      'objective': 'Objective',
      'summary': 'Summary',
      'experience': 'Professional Experience',
      'projects': 'Personal Projects',
      'certifications': 'Certifications',
      'education': 'Education',
      'mobile': 'Mobile',
      'architecture': 'Architecture',
      'fullstack': 'Fullstack',
      'tools': 'Tools',
      'languages': 'Languages',
      'age': 'years old',
    },
  };

  /// Builds the résumé rendered in [languageCode] ('pt' or 'en') in
  /// [layout] and hands it to the platform's share/save sheet as a ready
  /// file — a direct download on web. The suggested file name is
  /// date-stamped (`_yyyy_mm_dd`) so successive exports don't
  /// collide/overwrite one another on disk.
  static Future<void> download(
    String languageCode, {
    CvPdfLayout layout = CvPdfLayout.modern,
  }) async {
    final now = DateTime.now();
    final datestamp = '${now.year}'
        '_${now.month.toString().padLeft(2, '0')}'
        '_${now.day.toString().padLeft(2, '0')}';

    final bytes = await build(languageCode, layout: layout);

    final filename = languageCode == 'pt'
        ? 'Desenvolvedor_de_Software_Flutter'
        : 'Flutter_Software_Developer';
    // Tells the two versions apart in a downloads folder.
    final suffix = switch (layout) {
      CvPdfLayout.modern => languageCode == 'pt' ? '_Moderno' : '_Modern',
      CvPdfLayout.classic => '',
    };

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Roni_Paschoal_$filename${suffix}_$datestamp.pdf',
    );
  }

  /// The PDF bytes for [layout], without sharing them.
  static Future<Uint8List> build(
    String languageCode, {
    CvPdfLayout layout = CvPdfLayout.modern,
    PdfPageFormat format = PdfPageFormat.a4,
  }) {
    return switch (layout) {
      CvPdfLayout.modern => _build(languageCode, format),
      CvPdfLayout.classic => CvPdfClassicBuilder.build(languageCode, format),
    };
  }

  static Future<Uint8List> _build(
    String languageCode,
    PdfPageFormat format,
  ) async {
    final l = _labels[languageCode] ?? _labels['pt']!;

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ),
    );

    final pageTheme = pw.PageTheme(
      pageFormat: format,
      margin: const pw.EdgeInsets.all(_pageMargin),
      buildBackground: (context) => pw.Align(
        alignment: pw.Alignment.topLeft,
        child: pw.Container(
          width: _sidebarWidth,
          height: double.infinity,
          padding: const pw.EdgeInsets.only(right: 12),
          decoration: const pw.BoxDecoration(
            border: pw.Border(right: pw.BorderSide(color: _hairline)),
          ),
          child: context.pageNumber == 1 ? _sidebar(l, languageCode) : null,
        ),
      ),
    );

    final experienceGroups = CvCompanyGroup.groupByCompany(cvExperienceList);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          _main(_header(l)),
          _main(pw.SizedBox(height: 20)),
          _main(_sectionTitle(l['objective']!)),
          _main(_paragraph(cvObjective[languageCode] ?? cvObjective['pt']!)),
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['summary']!)),
          _main(_paragraph(cvSummary[languageCode] ?? cvSummary['pt']!)),
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['education']!)),
          for (final education in cvEducationList) _main(_education(education)),
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['experience']!)),
          for (var i = 0; i < experienceGroups.length; i++) ...[
            for (final widget in _company(experienceGroups[i], languageCode))
              _main(widget),
            if (i != experienceGroups.length - 1)
              _main(
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Divider(color: _hairline, thickness: 0.6),
                ),
              ),
          ],
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['projects']!)),
          for (final project in cvProjectList)
            _main(_project(project, languageCode)),
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['certifications']!)),
          for (final certification in cvCertificationList)
            _main(_certification(certification)),
        ],
      ),
    );

    return doc.save();
  }

  /// Pads a main-column widget clear of the sidebar band painted by
  /// [PageTheme.buildBackground] (which shares the same margin-relative
  /// coordinate space as the flowing content).
  static pw.Widget _main(pw.Widget child) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: _sidebarWidth + _gutter),
      child: child,
    );
  }

  static pw.Widget _header(Map<String, String> labels) {
    final age = DateTime.now().year - cvBirthYear;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Roni Paschoal', style: const pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 4),
        pw.Text(
          labels['role']!.toUpperCase(),
          style: const pw.TextStyle(
            fontSize: 10,
            color: _brand,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Flutter · Dart · Android · iOS · Santo André, SP · '
          '$age ${labels['age']}',
          style: const pw.TextStyle(fontSize: 9.5, color: _muted),
        ),
      ],
    );
  }

  static pw.Widget _sidebar(Map<String, String> labels, String languageCode) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sidebarTitle(labels['contact']!),
        for (final contact in cvContactList) ...[
          pw.UrlLink(
            destination: contact.url,
            child: pw.Text(
              contact.text,
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: _brand,
                decoration: pw.TextDecoration.underline,
                decorationColor: _brand,
              ),
            ),
          ),
          pw.SizedBox(height: 6),
        ],
        pw.SizedBox(height: 14),
        _sidebarTitle(labels['skills']!),
        for (final key in cvSkillGroupOrder) ...[
          pw.Text(
            labels[key]!.toUpperCase(),
            style: const pw.TextStyle(fontSize: 7, color: _muted),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            cvSkillGroups[key]!.join(', '),
            style: const pw.TextStyle(fontSize: 8.5, color: _ink),
          ),
          pw.SizedBox(height: 8),
        ],
        pw.Text(
          labels['languages']!.toUpperCase(),
          style: const pw.TextStyle(fontSize: 7, color: _muted),
        ),
        pw.SizedBox(height: 2),
        pw.RichText(
          text: pw.TextSpan(
            style: const pw.TextStyle(fontSize: 8.5, color: _ink),
            children: [
              for (final (i, item) in cvLanguageList.indexed) ...[
                if (i > 0) const pw.TextSpan(text: ', '),
                pw.TextSpan(
                  text: item.languageFor(languageCode),
                  style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.TextSpan(
                  text: [
                    ' (${item.levelFor(languageCode)})',
                    if (item.usageFor(languageCode) case final usage?) usage,
                  ].join(' - '),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _sidebarTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title.toUpperCase(),
        style: const pw.TextStyle(
          fontSize: 9.5,
          color: _brand,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  static pw.Widget _paragraph(String text) {
    return pw.Text(
      text,
      textAlign: pw.TextAlign.justify,
      style: const pw.TextStyle(fontSize: 10, color: _ink, lineSpacing: 3),
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style:
              const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 3),
        pw.Container(width: 28, height: 1.4, color: _brand),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static pw.Widget _project(CvProjectItem item, String languageCode) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.UrlLink(
            destination: item.url,
            child: pw.Text(
              item.title,
              style: const pw.TextStyle(
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
                color: _brand,
                decoration: pw.TextDecoration.underline,
                decorationColor: _brand,
              ),
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            item.descriptionFor(languageCode),
            textAlign: pw.TextAlign.justify,
            style: const pw.TextStyle(fontSize: 9.5, color: _ink),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            item.tech.join(' · '),
            style: const pw.TextStyle(fontSize: 8.5, color: _muted),
          ),
        ],
      ),
    );
  }

  /// A company block — heading with the whole tenure, the company's
  /// description and contractor line when there are any, then each role held there — as separate widgets
  /// so a long block can still break across pages.
  static List<pw.Widget> _company(CvCompanyGroup group, String languageCode) {
    final description =
        cvCompanyDescriptions[group.company]?.resolve(languageCode);
    final contractor =
        cvCompanyContractors[group.company]?.resolve(languageCode);

    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            group.company,
            style: const pw.TextStyle(
              fontSize: 11.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            group.periodWithDurationFor(languageCode),
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
      pw.SizedBox(height: 1),
      for (final note in [description, contractor].nonNulls)
        pw.Text(
          note,
          style: const pw.TextStyle(
            fontSize: 9.5,
            color: _muted,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
      for (var i = 0; i < group.roles.length; i++) ...[
        if (i > 0) pw.SizedBox(height: 6),
        ..._role(
          group.roles[i],
          languageCode,
          showPeriod: group.hasMultipleRoles,
        ),
      ],
    ];
  }

  /// A role's title, then its description as one bullet per sentence, as
  /// separate widgets so a long role can break across pages; [showPeriod]
  /// adds the role's own dates when the company heading spans several
  /// roles.
  static List<pw.Widget> _role(
    CvExperienceItem item,
    String languageCode, {
    required bool showPeriod,
  }) {
    const roleStyle = pw.TextStyle(
      fontSize: 9.5,
      color: _brand,
      fontWeight: pw.FontWeight.bold,
    );

    return [
      if (showPeriod)
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(item.roleFor(languageCode), style: roleStyle),
            ),
            pw.Text(
              item.periodWithDurationFor(languageCode),
              style: const pw.TextStyle(fontSize: 9, color: _muted),
            ),
          ],
        )
      else
        pw.Text(item.roleFor(languageCode), style: roleStyle),
      pw.SizedBox(height: 3),
      for (final highlight in item.highlightsFor(languageCode))
        _bullet(highlight),
    ];
  }

  /// A bullet line; the dot is drawn (not typed as `•`) because the
  /// standard Helvetica face only covers Latin-1.
  static pw.Widget _bullet(String text) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 1.5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 2.5,
              height: 2.5,
              margin: const pw.EdgeInsets.only(top: 4.2, right: 6),
              decoration: const pw.BoxDecoration(
                color: _ink,
                shape: pw.BoxShape.circle,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                text,
                style: const pw.TextStyle(
                  fontSize: 9.5,
                  color: _ink,
                  lineSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      );

  static pw.Widget _certification(CvCertificationItem item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(
              item.title,
              style: const pw.TextStyle(
                fontSize: 9.5,
                color: _ink,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Text(
            '${item.issuer} · ${item.date}',
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
    );
  }

  static pw.Widget _education(CvEducationItem item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.RichText(
              text: pw.TextSpan(
                style: const pw.TextStyle(fontSize: 9.5, color: _ink),
                children: [
                  pw.TextSpan(text: '${item.institution} · '),
                  pw.TextSpan(
                    text: item.course,
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          pw.Text(
            item.period,
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
    );
  }
}
