import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/pages/cv/cv_content_widget.dart';
import 'package:ronip/pages/cv/cv_pdf_builder.dart';
import 'package:ronip/pages/home/home_route.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/flutter_banner_widget.dart';
import 'package:ronip/widgets/locale_button_widget.dart';
import 'package:ronip/widgets/rp_app_bar.dart';
import 'package:ronip/widgets/theme_button_widget.dart';

/// Full-page `/cv` route: the same [CvContentWidget] shown by
/// `CvDialogWidget`, wrapped in the site's usual page chrome so it also
/// works as a shareable, directly-linkable URL.
class CvScreen extends StatefulWidget {
  const CvScreen({super.key});

  @override
  State<CvScreen> createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
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

    return FlutterBannerWidget(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200.0),
        child: SizedBox(
          width: double.infinity,
          child: Scaffold(
            appBar: RpAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: context.rpColors.textHighlightColor,
                ),
                tooltip: AppLocalizations.of(context)!.cvBackToHome,
                onPressed: () => context.go(HomeRoute.home),
              ),
              title: SelectableText(
                AppLocalizations.of(context)!.cvHeading,
                semanticsLabel: AppLocalizations.of(context)!.cvHeading,
                style: RpTheme.pageTitleStyle(
                  context.rpColors.textHighlightColor,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.download_outlined,
                    color: context.rpColors.textHighlightColor,
                  ),
                  tooltip: AppLocalizations.of(context)!.cvDownload,
                  onPressed: () => CvPdfBuilder.download(
                    Localizations.localeOf(context).languageCode,
                  ),
                ),
                LocaleButtonWidget(changeLocale: _appCubit.changeLocale),
                ThemeButtonWidget(toggleTheme: _appCubit.toggleTheme),
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
