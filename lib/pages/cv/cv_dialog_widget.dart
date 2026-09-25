import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/locale_button_widget.dart';
import 'package:ronip/widgets/rp_app_bar.dart';
import 'package:ronip/widgets/theme_button_widget.dart';

/// Shows the résumé as a dismissible overlay above the current page,
/// instead of navigating away to the `/cv` route: a centered "window" with
/// a close (X) button on wide screens, a full-screen sheet on small ones.
class CvDialogWidget extends StatefulWidget {
  const CvDialogWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierDismissible: true,
      barrierColor: const Color(0xCC000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, _, __) => const CvDialogWidget(),
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
  late final _appCubit = context.read<AppCubit>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;

    final closeButton = IconButton(
      onPressed: () => Navigator.of(context).pop(),
      tooltip: MaterialLocalizations.of(context).closeButtonLabel,
      icon: Icon(Icons.close, color: context.rpColors.textHighlightColor),
    );

    final downloadButton = IconButton(
      onPressed: () => CvPdfBuilder.download(
        Localizations.localeOf(context).languageCode,
      ),
      tooltip: AppLocalizations.of(context)!.cvDownload,
      icon: Icon(
        Icons.download_outlined,
        color: context.rpColors.textHighlightColor,
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

    // Names the overlay route, so screen readers announce "Résumé" when it
    // opens (the wide layout has no visible title to take it from) and keep
    // their reading within it.
    Widget route(Widget child) => Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: AppLocalizations.of(context)!.cvHeading,
          child: child,
        );

    if (isSmallScreen) {
      return route(
        Scaffold(
          backgroundColor: context.rpColors.backgroundColor,
          appBar: RpAppBar(
            leading: closeButton,
            actions: [
              downloadButton,
              LocaleButtonWidget(changeLocale: _appCubit.changeLocale),
              ThemeButtonWidget(toggleTheme: _appCubit.toggleTheme),
              RpTheme.spacerMedium,
            ],
          ),
          body: SafeArea(child: content),
        ),
      );
    }

    return route(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 960.0,
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: Material(
            color: context.rpColors.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Painted under the actions, but read after them: the sort
                // keys put Download/Close first for screen readers, instead
                // of after the whole résumé.
                Semantics(
                  container: true,
                  sortKey: const OrdinalSortKey(1.0),
                  child: content,
                ),
                Positioned(
                  top: RpTheme.spacingSmall,
                  right: RpTheme.spacingSmall,
                  child: Semantics(
                    container: true,
                    sortKey: const OrdinalSortKey(0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Material(
                          color: context.rpColors.menuColor,
                          shape: const CircleBorder(),
                          child: downloadButton,
                        ),
                        const SizedBox(width: 4.0),
                        Material(
                          color: context.rpColors.menuColor,
                          shape: const CircleBorder(),
                          child: closeButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
