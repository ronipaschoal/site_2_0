import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/helpers/hyperlink_helper.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_contact_item_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/reveal_on_scroll_widget.dart';

class ContactSection extends StatelessWidget {
  final List<ExternalMenu> externalMenuList;
  final ScrollController scrollController;

  const ContactSection({
    super.key,
    required this.externalMenuList,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = Size(
      RpTheme.fontSizeLarge,
      RpTheme.fontSizeLarge,
    );

    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RpTheme.spacerLarge,
          HomeSectionTitleWidget(
            title: HomeSectionEnum.contact.title(context),
            scrollController: scrollController,
          ),
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: Text(
              AppLocalizations.of(context)!.sayHello,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLargeX,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: MediaQueryHelper(context).isSmallScreen()
                ? Column(
                    children: [
                      RpTheme.spacerLargeX2,
                      HomeContactItemWidget(
                        text: 'roni@ronipaschoal.com.br',
                        icon: SvgPicture.asset(
                          'assets/images/logos/email.svg',
                          width: iconSize.width,
                          height: iconSize.height,
                          colorFilter: const ColorFilter.mode(
                            RpTheme.textColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () => HyperlinkHelper.mail(
                          'mailto:roni@ronipaschoal.com.br?subject=Website contact!',
                        ),
                      ),
                      RpTheme.spacerLargeX,
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (_, index) {
                          final externalMenu = externalMenuList[index];
                          return HomeContactItemWidget(
                            text: externalMenu.text,
                            icon: externalMenu.iconWidget(iconSize),
                            onPressed: externalMenu.goToExternal,
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeContactItemWidget(
                        text: 'roni@ronipaschoal.com.br',
                        icon: SvgPicture.asset(
                          'assets/images/logos/email.svg',
                          width: iconSize.width,
                          height: iconSize.height,
                          colorFilter: const ColorFilter.mode(
                            RpTheme.textColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () => HyperlinkHelper.mail(
                          'mailto:roni@ronipaschoal.com.br?subject=Website contact!',
                        ),
                      ),
                      const SizedBox(width: RpTheme.spacingMedium),
                      SizedBox(
                        height: 160.0,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 1,
                          itemBuilder: (_, index) {
                            final externalMenu = externalMenuList[index];
                            return HomeContactItemWidget(
                              text: externalMenu.text,
                              icon: externalMenu.iconWidget(iconSize),
                              onPressed: externalMenu.goToExternal,
                            );
                          },
                          separatorBuilder: (_, __) => RpTheme.spacerSmallX,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
