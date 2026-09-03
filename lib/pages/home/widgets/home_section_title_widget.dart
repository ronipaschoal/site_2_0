import 'package:flutter/material.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/decode_text_widget.dart';

class HomeSectionTitleWidget extends StatelessWidget {
  final String title;
  final ScrollController scrollController;

  /// Whether the title, underline, and text are centered or left-aligned.
  /// Sections laid out as a centered column want the default (centered);
  /// sections that overlay a left-aligned block (e.g. the work gallery)
  /// want this set to false.
  final bool centered;

  const HomeSectionTitleWidget({
    super.key,
    required this.title,
    required this.scrollController,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();
    final underline = Container(
      height: 2.0,
      width: 42.0,
      color: RpTheme.brandColor,
    );

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        RpDecodeTextWidget(
          text: title,
          scrollController: scrollController,
          style: const TextStyle(
            fontFamily: RpTheme.fontFamilyBody,
            fontWeight: FontWeight.w600,
            fontSize: RpTheme.fontSizeMedium,
            color: RpTheme.textHighlightColor,
            letterSpacing: -0.2,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
        RpTheme.spacerSmall,
        centered ? Center(child: underline) : underline,
        isSmallScreen ? RpTheme.spacerLarge : RpTheme.spacerLargeX,
      ],
    );
  }
}
