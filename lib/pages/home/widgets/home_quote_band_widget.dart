import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/reveal_on_scroll_widget.dart';

/// A full-width band highlighting a short statement between home sections,
/// using the same frosted-glass look as [HomeContactItemWidget].
class HomeQuoteBandWidget extends StatelessWidget {
  final String text;
  final ScrollController scrollController;

  const HomeQuoteBandWidget({
    super.key,
    required this.text,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;
    final borderSide = BorderSide(
      color: context.rpColors.textHighlightColor.withAlpha(40),
      width: 1.5,
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 48.0,
            vertical:
                isSmallScreen ? RpTheme.spacingLarge : RpTheme.spacingLargeX,
          ),
          decoration: BoxDecoration(
            color: context.rpColors.textHighlightColor.withAlpha(20),
            border: Border(top: borderSide, bottom: borderSide),
          ),
          child: RpRevealOnScrollWidget(
            scrollController: scrollController,
            child: SelectableText(
              text,
              semanticsLabel: text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.rpColors.textHighlightColor,
                fontSize: isSmallScreen
                    ? RpTheme.fontSizeRegular + 2.0
                    : RpTheme.fontSizeMedium - 2.0,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
