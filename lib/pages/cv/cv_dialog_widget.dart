import 'package:flutter/material.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/locale_button_widget.dart';
import 'package:ronip/ui/widgets/theme_button_widget.dart';

/// Shows the résumé as a dismissible overlay above the current page,
/// instead of navigating away to the `/cv` route: a centered "window" with
/// a close (X) button on wide screens, a full-screen sheet on small ones.
class CvDialogWidget extends StatefulWidget {
  final AppCubit appCubit;

  const CvDialogWidget({super.key, required this.appCubit});

  static Future<void> show(BuildContext context, AppCubit appCubit) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      barrierColor: const Color(0xCC000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, _, __) => CvDialogWidget(appCubit: appCubit),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween(begin: 0.97, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  State<CvDialogWidget> createState() => _CvDialogWidgetState();
}

class _CvDialogWidgetState extends State<CvDialogWidget> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();

    final closeButton = IconButton(
      onPressed: () => Navigator.of(context).pop(),
      tooltip: MaterialLocalizations.of(context).closeButtonLabel,
      icon: Icon(Icons.close, color: RpTheme.textHighlightColor),
    );

    final downloadButton = IconButton(
      onPressed: () => CvPdfBuilder.download(
        Localizations.localeOf(context).languageCode,
      ),
      tooltip: AppLocalizations.of(context)!.cvDownload,
      icon: Icon(
        Icons.download_outlined,
        color: RpTheme.textHighlightColor,
      ),
    );

    final content = SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16.0 : 40.0,
        RpTheme.spacingLarge,
        isSmallScreen ? 16.0 : 40.0,
        RpTheme.spacingLargeX2,
      ),
      child: CvContentWidget(scrollController: _scrollController),
    );

    if (isSmallScreen) {
      return Scaffold(
        backgroundColor: RpTheme.backgroundColor,
        appBar: AppBar(
          surfaceTintColor: RpTheme.menuColor,
          backgroundColor: RpTheme.menuColor,
          leading: closeButton,
          actions: [
            downloadButton,
            LocaleButtonWidget(changeLocale: widget.appCubit.changeLocale),
            ThemeButtonWidget(toggleTheme: widget.appCubit.toggleTheme),
            RpTheme.spacerMedium,
          ],
        ),
        body: SafeArea(child: content),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 960.0,
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: Material(
          color: RpTheme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              content,
              Positioned(
                top: RpTheme.spacingSmall,
                right: RpTheme.spacingSmall,
                child: Material(
                  color: RpTheme.menuColor,
                  shape: const CircleBorder(),
                  child: closeButton,
                ),
              ),
              Positioned(
                top: RpTheme.spacingSmall,
                right: 56.0,
                child: Material(
                  color: RpTheme.menuColor,
                  shape: const CircleBorder(),
                  child: downloadButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
