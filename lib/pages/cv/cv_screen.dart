import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';
import 'package:ronip/pages/home/home_route.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/flutter_banner_widget.dart';
import 'package:ronip/ui/widgets/locale_button_widget.dart';

/// Full-page `/cv` route: the same [CvContentWidget] shown by
/// `CvDialogWidget`, wrapped in the site's usual page chrome so it also
/// works as a shareable, directly-linkable URL.
class CvScreen extends StatefulWidget {
  final AppCubit appCubit;

  const CvScreen({
    super.key,
    required this.appCubit,
  });

  @override
  State<CvScreen> createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();

    return FlutterBannerWidget(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200.0),
        child: SizedBox(
          width: double.infinity,
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: RpTheme.menuColor,
              backgroundColor: RpTheme.menuColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: RpTheme.textHighlightColor,
                ),
                tooltip: AppLocalizations.of(context)!.cvBackToHome,
                onPressed: () => context.go(HomeRoute.home),
              ),
              title: SelectableText(
                AppLocalizations.of(context)!.cvHeading,
                semanticsLabel: AppLocalizations.of(context)!.cvHeading,
                style: const TextStyle(
                  fontFamily: RpTheme.fontFamilyDisplay,
                  fontSize: RpTheme.fontSizeMedium,
                  color: RpTheme.textHighlightColor,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.print_outlined,
                    color: RpTheme.textHighlightColor,
                  ),
                  tooltip: AppLocalizations.of(context)!.cvPrint,
                  onPressed: () => CvPdfBuilder.print(
                    Localizations.localeOf(context).languageCode,
                  ),
                ),
                LocaleButtonWidget(changeLocale: widget.appCubit.changeLocale),
                RpTheme.spacerMedium,
              ],
            ),
            body: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16.0 : 48.0,
                RpTheme.spacingLarge,
                isSmallScreen ? 16.0 : 48.0,
                RpTheme.spacingLargeX2,
              ),
              child: SafeArea(
                child: CvContentWidget(scrollController: _scrollController),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
