import 'package:flutter/material.dart';

/// The palette-dependent colors, exposed to widgets via
/// `Theme.of(context).extension<RpColors>()!` (or the [RpColorsContext]
/// shortcut below) so reading one of them registers the calling widget as a
/// dependent of [Theme] — an ancestor rebuild with a new [RpColors] (e.g.
/// [AppCubit.toggleTheme]) reaches it automatically, the same way any other
/// `Theme.of(context)` read does. No manual propagation or full-tree remount
/// needed.
@immutable
class RpColors extends ThemeExtension<RpColors> {
  final Color textColor;
  final Color textHighlightColor;
  final Color menuColor;
  final Color backgroundColor;
  final Color hairlineColor;

  const RpColors({
    required this.textColor,
    required this.textHighlightColor,
    required this.menuColor,
    required this.backgroundColor,
    required this.hairlineColor,
  });

  static const dark = RpColors(
    textColor: Color(0xFFB9B3B3),
    textHighlightColor: Color(0xFFEFEDED),
    menuColor: Color(0xCC0B0B18),
    backgroundColor: Color(0xFF0B0B18),
    hairlineColor: Color(0x40B9B3B3),
  );

  static const light = RpColors(
    textColor: Color(0xFF5F5959),
    textHighlightColor: Color(0xFF1A1818),
    menuColor: Color(0xCCFEFEFE),
    backgroundColor: Color(0xFFFEFEFE),
    hairlineColor: Color(0x405F5959),
  );

  @override
  RpColors copyWith({
    Color? textColor,
    Color? textHighlightColor,
    Color? menuColor,
    Color? backgroundColor,
    Color? hairlineColor,
  }) {
    return RpColors(
      textColor: textColor ?? this.textColor,
      textHighlightColor: textHighlightColor ?? this.textHighlightColor,
      menuColor: menuColor ?? this.menuColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hairlineColor: hairlineColor ?? this.hairlineColor,
    );
  }

  @override
  RpColors lerp(ThemeExtension<RpColors>? other, double t) {
    if (other is! RpColors) return this;
    return RpColors(
      textColor: Color.lerp(textColor, other.textColor, t)!,
      textHighlightColor:
          Color.lerp(textHighlightColor, other.textHighlightColor, t)!,
      menuColor: Color.lerp(menuColor, other.menuColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      hairlineColor: Color.lerp(hairlineColor, other.hairlineColor, t)!,
    );
  }
}

/// Shortcut for `Theme.of(context).extension<RpColors>()!`.
extension RpColorsContext on BuildContext {
  RpColors get rpColors => Theme.of(this).extension<RpColors>()!;
}

sealed class RpTheme {
  static const Color whiteColor = Color(0xFFFEFEFE);
  static const Color blackColor = Color(0xFF0B0B18);
  static const Color transparentColor = Color(0x00FEFEFE);

  // Same in both palettes — the brand identity doesn't change with theme.
  static const Color brandColor = Color(0xFFC92F10);
  static const Color bannerColor = Color(0xFF1A73E8);

  static const String fontFamilyDisplay = 'Inkburrow';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyMono = 'IBM Plex Mono';

  static const double fontSizeLarge = 44.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLabel = 13.0;

  /// Takes [color] rather than a [BuildContext] so this stays a plain style
  /// constructor — callers pass `context.rpColors.textColor`.
  static TextStyle labelStyle(Color color) => TextStyle(
        fontFamily: fontFamilyMono,
        fontSize: fontSizeLabel,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
        color: color,
      );

  /// The site name/page-heading style shown in every `AppBar` title
  /// (`HomeScreen`, `CvScreen`, `CvDialogWidget`).
  static TextStyle pageTitleStyle(Color color) => TextStyle(
        fontFamily: fontFamilyDisplay,
        fontSize: fontSizeMedium,
        color: color,
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

  static ThemeData themeFor(Brightness brightness) {
    final colors =
        brightness == Brightness.dark ? RpColors.dark : RpColors.light;

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandColor,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.backgroundColor,
      fontFamily: fontFamilyBody,
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: colors.textColor,
          fontSize: fontSizeRegular,
          height: 1.6,
        ),
      ),
      extensions: [colors],
    );
  }
}
