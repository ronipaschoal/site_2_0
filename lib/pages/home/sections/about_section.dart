import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/reveal_on_scroll_widget.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;

  const AboutSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RpTheme.spacerLarge,
          HomeSectionTitleWidget(
            title: HomeSectionEnum.about.title(context),
            scrollController: scrollController,
          ),
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.hybridTechnologyEnthusiast,
              semanticsLabel:
                  AppLocalizations.of(context)!.hybridTechnologyEnthusiast,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.totvsMobileApps,
              semanticsLabel: AppLocalizations.of(context)!.totvsMobileApps,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.letSConnect,
              semanticsLabel: AppLocalizations.of(context)!.letSConnect,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
        ],
      ),
    );
  }
}
