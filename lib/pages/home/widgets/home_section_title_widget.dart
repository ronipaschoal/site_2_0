import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/decode_text_widget.dart';

class HomeSectionTitleWidget extends StatelessWidget {
  final String title;
  final ScrollController scrollController;

  /// Shown as a mono `[01]` marker above a large heading, so home sections
  /// read like numbered chapters. Null keeps the compact underlined heading
  /// used by the résumé.
  final int? index;

  /// Whether the title, marker, and text are centered or left-aligned.
  /// Sections laid out as a centered column want this set to true; sections
  /// that overlay a left-aligned block (e.g. the work gallery) keep the
  /// default.
  final bool centered;

  const HomeSectionTitleWidget({
    super.key,
    required this.title,
    required this.scrollController,
    this.index,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;
    final colors = context.rpColors;

    final index = this.index;
    if (index == null) return _compact(context);

    // A short fixed-width hairline — a marker, not a divider, so it doesn't
    // stretch with the title's available width.
    // Decorative numbering — "[01]" would be read as "left bracket zero one".
    final marker = ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '[${index.toString().padLeft(2, '0')}]',
            style: RpTheme.labelStyle(colors.accentTextColor)
                .copyWith(letterSpacing: 1.0),
          ),
          RpTheme.spacerSmall,
          Container(width: 48.0, height: 1.0, color: colors.hairlineColor),
        ],
      ),
    );

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        marker,
        RpTheme.spacerMedium,
        _heading(
          RpDecodeTextWidget(
            text: title,
            scrollController: scrollController,
            style: RpTheme.headingStyle(
              colors.textHighlightColor,
              fontSize: RpTheme.fluid(
                context,
                min: 30.0,
                max: 48.0,
                factor: 0.04,
              ),
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        isSmallScreen ? RpTheme.spacerLarge : RpTheme.spacerLargeX,
      ],
    );
  }

  /// Exposes the title as an `<h2>` on web, so screen reader users can jump
  /// between sections by heading. The label is set here (and the decoding
  /// text excluded) so the heading always reads as the final title, never
  /// the scrambled frames.
  Widget _heading(Widget child) => Semantics(
        headingLevel: 2,
        label: title,
        excludeSemantics: true,
        child: child,
      );

  Widget _compact(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;
    final underline = Container(
      height: 2.0,
      width: 42.0,
      color: RpTheme.brandColor,
    );

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _heading(
          RpDecodeTextWidget(
            text: title,
            scrollController: scrollController,
            style: RpTheme.headingStyle(
              context.rpColors.textHighlightColor,
              fontSize: RpTheme.fontSizeMedium,
              weight: 600,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        RpTheme.spacerSmall,
        centered ? Center(child: underline) : underline,
        isSmallScreen ? RpTheme.spacerLarge : RpTheme.spacerLargeX,
      ],
    );
  }
}
