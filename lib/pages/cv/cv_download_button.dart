import 'package:flutter/material.dart';
import 'package:ronip/core/analytics/analytics.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart' deferred as pdf_builder;
import 'package:ronip/pages/cv/cv_pdf_layout.dart';

/// The résumé's download action: a menu offering both PDF layouts, in the
/// current language. Shared by the `/cv` page and the résumé dialog.
///
/// The PDF builder — with the `pdf` and `printing` packages behind it — is
/// a deferred library, so on web it stays out of `main.dart.js` and is only
/// fetched once someone opens this menu.
class CvDownloadButton extends StatelessWidget {
  const CvDownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return PopupMenuButton<CvPdfLayout>(
      tooltip: l10n.cvDownload,
      icon: Icon(
        Icons.download_outlined,
        color: context.rpColors.textHighlightColor,
      ),
      // Start fetching the builder as soon as the menu opens, so it's
      // usually loaded by the time a layout is picked.
      onOpened: () => pdf_builder.loadLibrary(),
      onSelected: (layout) async {
        RpAnalytics.cvDownload(layout: layout.name, language: languageCode);
        await pdf_builder.loadLibrary();
        await pdf_builder.CvPdfBuilder.download(languageCode, layout: layout);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: CvPdfLayout.modern,
          child: Text(l10n.cvDownloadModern),
        ),
        PopupMenuItem(
          value: CvPdfLayout.classic,
          child: Text(l10n.cvDownloadClassic),
        ),
      ],
    );
  }
}
