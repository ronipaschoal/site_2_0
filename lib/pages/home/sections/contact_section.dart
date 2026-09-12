import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/home/widgets/home_contact_item_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';

class ContactSection extends StatelessWidget {
  final List<ExternalMenu> externalMenuList;
  final ScrollController scrollController;

  const ContactSection({
    super.key,
    required this.externalMenuList,
    required this.scrollController,
  });

  Widget _emailCard(BuildContext context) {
    const iconSize = Size(RpTheme.fontSizeLarge, RpTheme.fontSizeLarge);

    return HomeContactItemWidget(
      text: contactEmail,
      icon: SvgPicture.asset(
        'assets/images/logos/email.svg',
        width: iconSize.width,
        height: iconSize.height,
        colorFilter: ColorFilter.mode(
          context.rpColors.textColor,
          BlendMode.srcIn,
        ),
      ),
      onPressed: () => HyperlinkHelper.open(
        'mailto:$contactEmail?subject=Website contact!',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = Size(RpTheme.fontSizeLarge, RpTheme.fontSizeLarge);
    final isSmallScreen = context.isSmallScreen;

    final externalCards = [
      for (final externalMenu in externalMenuList)
        HomeContactItemWidget(
          text: externalMenu.text,
          icon: externalMenu.iconWidget(context, iconSize),
          onPressed: externalMenu.goToExternal,
        ),
    ];

    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RpTheme.spacerLarge,
          HomeSectionTitleWidget(
            title: HomeSectionEnum.contact.title(context),
            scrollController: scrollController,
          ),
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.sayHello,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLargeX,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: isSmallScreen
                ? Column(
                    children: [
                      RpTheme.spacerSmall,
                      Center(
                        child: SizedBox(
                          width: 260.0,
                          child: _emailCard(context),
                        ),
                      ),
                      RpTheme.spacerMedium,
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: RpTheme.spacingMedium,
                        runSpacing: RpTheme.spacingMedium,
                        children: [
                          for (final card in externalCards)
                            SizedBox(width: 260.0, child: card),
                        ],
                      ),
                    ],
                  )
                : Wrap(
                    alignment: WrapAlignment.center,
                    spacing: RpTheme.spacingMedium,
                    runSpacing: RpTheme.spacingMedium,
                    children: [
                      SizedBox(height: 160.0, child: _emailCard(context)),
                      for (final card in externalCards)
                        SizedBox(height: 160.0, child: card),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
