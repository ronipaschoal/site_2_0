import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;

  const AboutSection({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RpTheme.spacerLarge,
          HomeSectionTitleWidget(
            title: HomeSectionEnum.about.title(context),
            scrollController: scrollController,
          ),
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.softwareDeveloperOverview,
              semanticsLabel:
                  AppLocalizations.of(context)!.softwareDeveloperOverview,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.flutterTeamContribution,
              semanticsLabel:
                  AppLocalizations.of(context)!.flutterTeamContribution,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.mobileAppLifecycle,
              semanticsLabel: AppLocalizations.of(context)!.mobileAppLifecycle,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.webAndAiBackground,
              semanticsLabel: AppLocalizations.of(context)!.webAndAiBackground,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              AppLocalizations.of(context)!.continuousFlutterEvolution,
              semanticsLabel:
                  AppLocalizations.of(context)!.continuousFlutterEvolution,
              textAlign: TextAlign.justify,
            ),
          ),
          RpTheme.spacerLarge,
        ],
      ),
    );
  }
}
