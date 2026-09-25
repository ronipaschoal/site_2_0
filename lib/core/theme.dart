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

  /// Slightly lifted panel color for tiles/cards sitting on [backgroundColor].
  final Color surfaceColor;

  /// Faint lines/dots of the ambient background grid.
  final Color gridColor;

  /// The brand hue tuned per palette to reach WCAG AA (4.5:1) for small
  /// text and focus rings — the raw [RpTheme.brandColor] only reaches ~3.7:1
  /// on the dark background, fine for large type and decoration only.
  final Color accentTextColor;

  const RpColors({
    required this.textColor,
    required this.textHighlightColor,
    required this.menuColor,
    required this.backgroundColor,
    required this.hairlineColor,
    required this.surfaceColor,
    required this.gridColor,
    required this.accentTextColor,
  });

  // Cool neutrals, so the single warm brand accent reads as a "signal".
  static const dark = RpColors(
    textColor: Color(0xFF9BA3B4),
    textHighlightColor: Color(0xFFE8ECF4),
    menuColor: Color(0xCC07080F),
    backgroundColor: Color(0xFF07080F),
    hairlineColor: Color(0x24E8ECF4),
    surfaceColor: Color(0xFF0D0F18),
    gridColor: Color(0x1FE8ECF4),
    accentTextColor: Color(0xFFF0674A),
  );

  static const light = RpColors(
    textColor: Color(0xFF525A6B),
    textHighlightColor: Color(0xFF0B0D14),
    menuColor: Color(0xCCF6F7FA),
    backgroundColor: Color(0xFFF6F7FA),
    hairlineColor: Color(0x240B0D14),
    surfaceColor: Color(0xFFFFFFFF),
    gridColor: Color(0x1C0B0D14),
    accentTextColor: Color(0xFFB8290C),
  );

  @override
  RpColors copyWith({
    Color? textColor,
    Color? textHighlightColor,
    Color? menuColor,
    Color? backgroundColor,
    Color? hairlineColor,
    Color? surfaceColor,
    Color? gridColor,
    Color? accentTextColor,
  }) {
    return RpColors(
      textColor: textColor ?? this.textColor,
      textHighlightColor: textHighlightColor ?? this.textHighlightColor,
      menuColor: menuColor ?? this.menuColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hairlineColor: hairlineColor ?? this.hairlineColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      gridColor: gridColor ?? this.gridColor,
      accentTextColor: accentTextColor ?? this.accentTextColor,
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
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      gridColor: Color.lerp(gridColor, other.gridColor, t)!,
      accentTextColor: Color.lerp(accentTextColor, other.accentTextColor, t)!,
    );
  }
}

/// Shortcut for `Theme.of(context).extension<RpColors>()!`.
extension RpColorsContext on BuildContext {
  RpColors get rpColors => Theme.of(this).extension<RpColors>()!;
}

sealed class RpTheme {
  static const Color whiteColor = Color(0xFFFEFEFE);
  static const Color blackColor = Color(0xFF07080F);
  static const Color transparentColor = Color(0x00FEFEFE);

  // Same in both palettes — the brand identity doesn't change with theme.
  static const Color brandColor = Color(0xFFC92F10);
  static const Color bannerColor = Color(0xFF1A73E8);

  /// The "online" dot of the hero status line.
  static const Color statusColor = Color(0xFF3DDC97);

  /// Handwritten face, kept for the signature/name only.
  static const String fontFamilyDisplay = 'Inkburrow';
  static const String fontFamilyHeading = 'Space Grotesk';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyMono = 'IBM Plex Mono';

  /// Width of the content column. Only content is capped to it — page
  /// chrome (app bar, scrollbar, scroll progress, background) spans the
  /// whole window.
  static const double contentMaxWidth = 1200.0;

  static const double fontSizeLarge = 44.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLabel = 13.0;

  /// A size that scales with the viewport width ([factor] × width), clamped
  /// to [min]..[max] — the Flutter take on CSS `clamp()` fluid type.
  static double fluid(
    BuildContext context, {
    required double min,
    required double max,
    required double factor,
  }) =>
      (MediaQuery.sizeOf(context).width * factor).clamp(min, max);

  /// Takes [color] rather than a [BuildContext] so this stays a plain style
  /// constructor — callers pass `context.rpColors.textColor`.
  static TextStyle labelStyle(Color color) => TextStyle(
        fontFamily: fontFamilyMono,
        fontSize: fontSizeLabel,
        fontWeight: FontWeight.w500,
        letterSpacing: 2.0,
        color: color,
      );

  /// Space Grotesk ships as a variable font, so the weight is driven through
  /// its `wght` axis rather than [FontWeight] (which would only pick between
  /// declared static faces).
  static TextStyle headingStyle(
    Color color, {
    required double fontSize,
    double weight = 500,
    double height = 1.1,
  }) =>
      TextStyle(
        fontFamily: fontFamilyHeading,
        fontSize: fontSize,
        fontVariations: [FontVariation.weight(weight)],
        letterSpacing: -fontSize * 0.025,
        height: height,
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
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: brandColor.withAlpha(90),
        cursorColor: brandColor,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: colors.textColor,
          fontSize: fontSizeRegular,
          height: 1.7,
        ),
      ),
      extensions: [colors],
    );
  }
}
