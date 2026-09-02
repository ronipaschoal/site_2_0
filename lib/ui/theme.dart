import 'package:flutter/material.dart';

sealed class RpTheme {
  static const Color witheColor = Color(0xFFFEFEFE);
  static const Color transparentColor = Color(0x00FEFEFE);

  static const Color textColor = Color(0xFFB9B3B3);
  static const Color textHighlightColor = Color(0xFFEFEDED);
  static const Color brandColor = Color(0xFFC92F10);
  static const Color bannerColor = Color(0xFF1A73E8);
  static const Color menuColor = Color(0xCC0B0B18);
  static const Color backgroundColor = Color(0xFF0B0B18);
  static const Color backgroundColorDark = Color(0xFF0B0B18);
  static const Color hairlineColor = Color(0x40B9B3B3);

  static const String fontFamilyDisplay = 'Inkburrow';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyMono = 'IBM Plex Mono';

  static const double fontSizeLarge = 44.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLabel = 13.0;

  static const TextStyle labelStyle = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: fontSizeLabel,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.0,
    color: textColor,
  );

  static const double spacingSmallX = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 32.0;
  static const double spacingLargeX = 64.0;
  static const double spacingLargeX2 = 80.0;

  static const SizedBox spacerSmallX =
      SizedBox(height: spacingSmallX, width: spacingSmallX);
  static const SizedBox spacerSmall =
      SizedBox(height: spacingSmall, width: spacingSmall);
  static const SizedBox spacerMedium =
      SizedBox(height: spacingMedium, width: spacingMedium);
  static const SizedBox spacerLarge =
      SizedBox(height: spacingLarge, width: spacingLarge);
  static const SizedBox spacerLargeX =
      SizedBox(height: spacingLargeX, width: spacingLargeX);
  static const SizedBox spacerLargeX2 =
      SizedBox(height: spacingLargeX2, width: spacingLargeX2);

  static final theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: RpTheme.brandColor),
    scaffoldBackgroundColor: RpTheme.backgroundColor,
    fontFamily: fontFamilyBody,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: RpTheme.textColor,
        fontSize: RpTheme.fontSizeRegular,
        height: 1.6,
      ),
    ),
  );
}
