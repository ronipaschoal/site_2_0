import 'package:flutter/material.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/ui/theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSectionWidget(
      child: Column(
        children: [
          RpTheme.spacerLarge,
          if (!MediaQueryHelper(context).isSmallScreen())
            HomeSectionTitleWidget(
              title: HomeSectionEnum.about.title(context),
            ),
          SelectableText(
            AppLocalizations.of(context)!.hybridTechnologyEnthusiast,
            semanticsLabel:
                AppLocalizations.of(context)!.hybridTechnologyEnthusiast,
            textAlign: TextAlign.justify,
          ),
          RpTheme.spacerLarge,
          SelectableText(
            AppLocalizations.of(context)!.totvsMobileApps,
            semanticsLabel: AppLocalizations.of(context)!.totvsMobileApps,
            textAlign: TextAlign.justify,
          ),
          RpTheme.spacerLarge,
          SelectableText(
            AppLocalizations.of(context)!.letSConnect,
            semanticsLabel: AppLocalizations.of(context)!.letSConnect,
            textAlign: TextAlign.justify,
          ),
          RpTheme.spacerLarge,
        ],
      ),
    );
  }
}
