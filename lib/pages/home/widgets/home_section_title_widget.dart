import 'package:flutter/material.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/ui/theme.dart';

class HomeSectionTitleWidget extends StatelessWidget {
  final String title;

  const HomeSectionTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQueryHelper(context).isSmallScreen();

    return Column(
      children: [
        SelectableText(
          title,
          semanticsLabel: title,
          style: const TextStyle(
            fontFamily: RpTheme.fontFamilyBody,
            fontWeight: FontWeight.w600,
            fontSize: RpTheme.fontSizeMedium,
            color: RpTheme.textHighlightColor,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        ),
        RpTheme.spacerSmall,
        Center(
          child: Container(
            height: 2.0,
            width: 42.0,
            color: RpTheme.brandColor,
          ),
        ),
        isSmallScreen ? RpTheme.spacerLarge : RpTheme.spacerLargeX,
      ],
    );
  }
}
