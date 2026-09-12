import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ronip/models/cv_item_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';

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
/// (summary/experience/certifications/education) padded clear of it. Both
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
      'role': 'Engenheiro de Software Flutter',
      'contact': 'Contato',
      'skills': 'Competências',
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
      'role': 'Flutter Software Engineer',
      'contact': 'Contact',
      'skills': 'Skills',
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

  /// Builds the résumé rendered in [languageCode] ('pt' or 'en') and hands
  /// it to the platform's share/save sheet as a ready file — a direct
  /// download on web. The suggested file name is date-stamped
  /// (`_yyyy_mm_dd`) so successive exports don't collide/overwrite one
  /// another on disk.
  static Future<void> download(String languageCode) async {
    final now = DateTime.now();
    final datestamp = '${now.year}'
        '_${now.month.toString().padLeft(2, '0')}'
        '_${now.day.toString().padLeft(2, '0')}';

    final bytes = await _build(languageCode, PdfPageFormat.a4);

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Roni_Paschoal_Mobile_Developer_Flutter_$datestamp.pdf',
    );
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

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          _main(_header(l)),
          _main(pw.SizedBox(height: 20)),
          _main(_sectionTitle(l['summary']!)),
          _main(
            pw.Text(
              cvSummary[languageCode] ?? cvSummary['pt']!,
              textAlign: pw.TextAlign.justify,
              style: const pw.TextStyle(
                fontSize: 10,
                color: _ink,
                lineSpacing: 3,
              ),
            ),
          ),
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['experience']!)),
          for (var i = 0; i < cvExperienceList.length; i++) ...[
            _main(_experience(cvExperienceList[i], languageCode)),
            if (i != cvExperienceList.length - 1)
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
          _main(pw.SizedBox(height: 18)),
          _main(_sectionTitle(l['education']!)),
          for (final education in cvEducationList) _main(_education(education)),
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
        pw.Text(
          cvLanguageList
              .map(
                (item) => '${item.languageFor(languageCode)} '
                    '(${item.levelFor(languageCode)})',
              )
              .join(', '),
          style: const pw.TextStyle(fontSize: 8.5, color: _ink),
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

  static pw.Widget _experience(CvExperienceItem item, String languageCode) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              item.company,
              style: const pw.TextStyle(
                fontSize: 11.5,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              item.period,
              style: const pw.TextStyle(fontSize: 9, color: _muted),
            ),
          ],
        ),
        pw.SizedBox(height: 1),
        pw.Text(
          item.roleFor(languageCode),
          style: const pw.TextStyle(
            fontSize: 9.5,
            color: _brand,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          item.descriptionFor(languageCode),
          textAlign: pw.TextAlign.justify,
          style: const pw.TextStyle(fontSize: 9.5, color: _ink, lineSpacing: 2),
        ),
      ],
    );
  }

  static pw.Widget _certification(CvCertificationItem item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(
              item.title,
              style: const pw.TextStyle(fontSize: 9.5, color: _ink),
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
            child: pw.Text(
              '${item.institution} · ${item.course}',
              style: const pw.TextStyle(fontSize: 9.5, color: _ink),
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
