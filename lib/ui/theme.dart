import 'package:flutter/material.dart';

sealed class RpTheme {
  /// Which palette the color getters below resolve to. Defaults to dark —
  /// [main.dart] sets this from the persisted preference (or the
  /// system/browser brightness, on first visit) before the first frame, and
  /// again on every toggle via `AppCubit.toggleTheme`.
  static Brightness brightness = Brightness.dark;

  static bool get _isDark => brightness == Brightness.dark;

  static const Color whiteColor = Color(0xFFFEFEFE);
  static const Color blackColor = Color(0xFF0B0B18);
  static const Color transparentColor = Color(0x00FEFEFE);

  // Same in both palettes — the brand identity doesn't change with theme.
  static const Color brandColor = Color(0xFFC92F10);
  static const Color bannerColor = Color(0xFF1A73E8);

  static const Color _textColorDark = Color(0xFFB9B3B3);
  static const Color _textColorLight = Color(0xFF5F5959);
  static Color get textColor => _isDark ? _textColorDark : _textColorLight;

  static const Color _textHighlightColorDark = Color(0xFFEFEDED);
  static const Color _textHighlightColorLight = Color(0xFF1A1818);
  static Color get textHighlightColor =>
      _isDark ? _textHighlightColorDark : _textHighlightColorLight;

  static const Color _menuColorDark = Color(0xCC0B0B18);
  static const Color _menuColorLight = Color(0xCCFEFEFE);
  static Color get menuColor => _isDark ? _menuColorDark : _menuColorLight;

  static const Color _backgroundColorDark = Color(0xFF0B0B18);
  static const Color _backgroundColorLight = Color(0xFFFEFEFE);
  static Color get backgroundColor =>
      _isDark ? _backgroundColorDark : _backgroundColorLight;

  static const Color _hairlineColorDark = Color(0x40B9B3B3);
  static const Color _hairlineColorLight = Color(0x405F5959);
  static Color get hairlineColor =>
      _isDark ? _hairlineColorDark : _hairlineColorLight;

  static const String fontFamilyDisplay = 'Inkburrow';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyMono = 'IBM Plex Mono';

  static const double fontSizeLarge = 44.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLabel = 13.0;

  static TextStyle get labelStyle => TextStyle(
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

  static ThemeData get theme => ThemeData(
        brightness: brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RpTheme.brandColor,
          brightness: brightness,
        ),
        scaffoldBackgroundColor: RpTheme.backgroundColor,
        fontFamily: fontFamilyBody,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: RpTheme.textColor,
            fontSize: RpTheme.fontSizeRegular,
            height: 1.6,
          ),
        ),
      );
}
