import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';
import 'package:ronip/pages/home/widgets/home_section_widget.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';

class AboutSection extends StatelessWidget {
  final ScrollController scrollController;

  const AboutSection({super.key, required this.scrollController});

  /// Comfortable reading measure (~65 characters) for the body paragraphs.
  static const _readingWidth = 680.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.rpColors;

    final paragraphs = [
      l10n.softwareDeveloperOverview,
      l10n.flutterTeamContribution,
      l10n.mobileAppLifecycle,
      l10n.webAndAiBackground,
      l10n.continuousFlutterEvolution,
    ];

    return HomeSectionWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RpTheme.spacerLargeX2,
          HomeSectionTitleWidget(
            index: 1,
            title: HomeSectionEnum.about.title(context),
            scrollController: scrollController,
          ),
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860.0),
              child: SelectableText(
                l10n.aboutLead,
                semanticsLabel: l10n.aboutLead,
                style: RpTheme.headingStyle(
                  colors.textHighlightColor,
                  fontSize: RpTheme.fluid(
                    context,
                    min: 28.0,
                    max: 52.0,
                    factor: 0.045,
                  ),
                  weight: 400,
                ),
              ),
            ),
          ),
          RpTheme.spacerLargeX,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: const _FactBento(),
          ),
          RpTheme.spacerLargeX,
          for (final paragraph in paragraphs) ...[
            RpRevealOnScrollWidget(
              scrollController: scrollController,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _readingWidth),
                child: SelectableText(paragraph, semanticsLabel: paragraph),
              ),
            ),
            RpTheme.spacerLarge,
          ],
          RpTheme.spacerLarge,
          RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: const _Timeline(),
          ),
          RpTheme.spacerLargeX,
        ],
      ),
    );
  }
}

class _Fact {
  final String value;
  final String caption;
  final bool live;

  /// Spans two cells in the 3-column layout (see [_FactBento]).
  final bool wide;

  const _Fact(
    this.value,
    this.caption, {
    this.live = false,
    this.wide = false,
  });
}

/// Quick-scan facts in a bento grid: the experience figures first, ending
/// with a live "Now" tile. Eight tiles close evenly at 2 or 1 columns; at 3
/// columns the "Now" tile spans two cells so the last row closes too.
class _FactBento extends StatelessWidget {
  const _FactBento();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final facts = [
      _Fact(RpProfile.yearsOfExperience, l10n.factExperience),
      _Fact(RpProfile.yearsHybridMobile, l10n.factHybridMobile),
      _Fact(RpProfile.yearsFlutter, l10n.factFlutter),
      _Fact(cvSkillGroups['mobile']!.join(' · '), l10n.factStack),
      _Fact('Android · iOS · Smart POS', l10n.factPlatforms),
      _Fact(cvSkillGroups['fullstack']!.join(' · '), l10n.factSecondaryStack),
      _Fact(cvSkillGroups['tools']!.join(' · '), l10n.cvSkillsTools),
      _Fact(l10n.nowText, l10n.nowTitle, live: true, wide: true),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = RpTheme.spacingMedium;
        final columns = constraints.maxWidth >= 900.0
            ? 3
            : constraints.maxWidth >= 480.0
                ? 2
                : 1;
        final cell = (constraints.maxWidth - gap * (columns - 1)) / columns;
        int span(_Fact fact) => fact.wide && columns == 3 ? 2 : 1;

        // Pack the tiles into rows of `columns` cells, so each row can be
        // laid out on its own and every tile stretched to the row's tallest
        // one (a Wrap sizes each tile to its own content).
        final rows = <List<_Fact>>[];
        var used = columns;
        for (final fact in facts) {
          if (used + span(fact) > columns) {
            rows.add([]);
            used = 0;
          }
          rows.last.add(fact);
          used += span(fact);
        }

        return Column(
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              if (r != 0) const SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < rows[r].length; i++) ...[
                      if (i != 0) const SizedBox(width: gap),
                      SizedBox(
                        width: cell * span(rows[r][i]) +
                            gap * (span(rows[r][i]) - 1),
                        child: _FactTile(fact: rows[r][i]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FactTile extends StatefulWidget {
  final _Fact fact;

  const _FactTile({required this.fact});

  @override
  State<_FactTile> createState() => _FactTileState();
}

class _FactTileState extends State<_FactTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final fact = widget.fact;
    final isNumber = RegExp(r'^[\d+]+$').hasMatch(fact.value);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // One stop per tile for screen readers: "Years of experience, 8+".
    return MergeSemantics(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          constraints: const BoxConstraints(minHeight: 150.0),
          padding: const EdgeInsets.all(RpTheme.spacingLarge - 8.0),
          decoration: BoxDecoration(
            color: colors.surfaceColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: _hovering
                  ? RpTheme.brandColor.withValues(alpha: 0.6)
                  : colors.hairlineColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Fills the row-stretched height: caption on top, value pinned
            // to the bottom, aligned across the tiles of a row.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (fact.live) ...[
                    Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: RpTheme.statusColor,
                      ),
                    ),
                    RpTheme.spacerSmall,
                  ],
                  Flexible(
                    child: Text(
                      fact.caption.toUpperCase(),
                      semanticsLabel: fact.caption,
                      style: RpTheme.labelStyle(colors.textColor)
                          .copyWith(fontSize: 11.0, letterSpacing: 1.4),
                    ),
                  ),
                ],
              ),
              RpTheme.spacerLarge,
              Text(
                fact.value,
                style: RpTheme.headingStyle(
                  colors.textHighlightColor,
                  fontSize: isNumber ? 48.0 : (fact.live ? 17.0 : 22.0),
                  weight: isNumber ? 500 : 400,
                  height: fact.live ? 1.45 : 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact career path built from the résumé data.
class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final languageCode = Localizations.localeOf(context).languageCode;
    final isSmallScreen = context.isSmallScreen;
    final periodStyle = RpTheme.labelStyle(colors.textColor)
        .copyWith(fontSize: 12.0, letterSpacing: 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          headingLevel: 3,
          label: AppLocalizations.of(context)!.timelineTitle,
          excludeSemantics: true,
          child: Text(
            AppLocalizations.of(context)!.timelineTitle.toUpperCase(),
            style: RpTheme.labelStyle(colors.textHighlightColor),
          ),
        ),
        RpTheme.spacerMedium,
        for (final item in cvExperienceList)
          // Read as one line: "Jul/2025 - Jun/2026, Mercado Livre, …".
          MergeSemantics(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.hairlineColor)),
              ),
              child: Flex(
                direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isSmallScreen ? null : 200.0,
                    child: Text(
                      item.period.toUpperCase(),
                      semanticsLabel: item.period,
                      style: periodStyle,
                    ),
                  ),
                  if (isSmallScreen) RpTheme.spacerSmallX,
                  SizedBox(
                    width: isSmallScreen ? null : 240.0,
                    child: Text(
                      item.company,
                      style: TextStyle(
                        color: colors.textHighlightColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isSmallScreen)
                    Text(item.roleFor(languageCode))
                  else
                    Expanded(child: Text(item.roleFor(languageCode))),
                ],
              ),
            ),
          ),
        Container(height: 1.0, color: colors.hairlineColor),
      ],
    );
  }
}
