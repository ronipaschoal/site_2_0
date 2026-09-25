import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/scroll_progress_mixin.dart';

/// A full-width band highlighting a short statement between home sections.
/// Its words light up one by one, in step with the band's travel through
/// the viewport, so the sentence "reads itself" as the page scrolls.
class HomeQuoteBandWidget extends StatefulWidget {
  final String text;
  final ScrollController scrollController;

  const HomeQuoteBandWidget({
    super.key,
    required this.text,
    required this.scrollController,
  });

  @override
  State<HomeQuoteBandWidget> createState() => _HomeQuoteBandWidgetState();
}

class _HomeQuoteBandWidgetState extends State<HomeQuoteBandWidget>
    with ScrollProgressMixin {
  final _anchorKey = GlobalKey();

  @override
  ScrollController get scrollProgressController => widget.scrollController;

  /// 0 when the band's top enters the bottom of the viewport, 1 once it
  /// has risen 10% above the top — by then the (padded) text sits around
  /// the upper third, so the words finish lighting up while being read.
  @override
  double computeScrollProgress() {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return 0.0;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    return (viewportHeight * 0.95 - top) / (viewportHeight * 1.05);
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;
    final colors = context.rpColors;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final lit = reduceMotion ? 1.0 : progress;

    final words = widget.text.split(' ');
    final style = RpTheme.headingStyle(
      colors.textHighlightColor,
      fontSize: RpTheme.fluid(context, min: 22.0, max: 40.0, factor: 0.032),
      weight: 400,
      height: 1.35,
    );
    // A short fade window per word, so a few words are always mid-glow.
    final spread = words.length.toDouble();

    return Container(
      key: _anchorKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : 48.0,
        vertical: isSmallScreen ? RpTheme.spacingLargeX : 120.0,
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: colors.hairlineColor),
        ),
      ),
      child: Column(
        children: [
          // Decorative glyph — would be read as "left double quotation mark".
          ExcludeSemantics(
            child: Text(
              '“',
              style: RpTheme.headingStyle(
                RpTheme.brandColor,
                fontSize: 72.0,
                height: 0.8,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980.0),
            child: SelectableText.rich(
              TextSpan(
                children: [
                  for (var i = 0; i < words.length; i++)
                    TextSpan(
                      text: i == words.length - 1 ? words[i] : '${words[i]} ',
                      style: style.copyWith(
                        color: colors.textHighlightColor.withValues(
                          alpha: 0.16 +
                              0.84 *
                                  (lit * (spread + 3) - i).clamp(0.0, 3.0) /
                                  3,
                        ),
                      ),
                    ),
                ],
              ),
              semanticsLabel: widget.text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
