import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';

/// The résumé's download action: a menu offering both PDF layouts, in the
/// current language. Shared by the `/cv` page and the résumé dialog.
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
      onSelected: (layout) =>
          CvPdfBuilder.download(languageCode, layout: layout),
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
