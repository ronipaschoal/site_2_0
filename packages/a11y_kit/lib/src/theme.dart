import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Visual defaults for a11y_kit widgets, added to
/// [ThemeData.extensions]. Without it, widgets fall back to
/// [ColorScheme.primary] for focus rings.
@immutable
class A11yTheme extends ThemeExtension<A11yTheme> {
  /// Color of the keyboard focus ring. Pick one that reaches at least 3:1
  /// against the background (WCAG 2.2, 1.4.11 Non-text Contrast).
  final Color? focusColor;

  /// Stroke width of the keyboard focus ring.
  final double focusWidth;

  /// Creates the theme extension.
  const A11yTheme({this.focusColor, this.focusWidth = 2.0});

  /// The [A11yTheme] in [context]'s theme, or the defaults.
  static A11yTheme of(BuildContext context) =>
      Theme.of(context).extension<A11yTheme>() ?? const A11yTheme();

  /// [focusColor], or the theme's primary color when unset.
  Color resolveFocusColor(BuildContext context) =>
      focusColor ?? Theme.of(context).colorScheme.primary;

  @override
  A11yTheme copyWith({Color? focusColor, double? focusWidth}) => A11yTheme(
    focusColor: focusColor ?? this.focusColor,
    focusWidth: focusWidth ?? this.focusWidth,
  );

  @override
  A11yTheme lerp(ThemeExtension<A11yTheme>? other, double t) {
    if (other is! A11yTheme) return this;
    return A11yTheme(
      focusColor: Color.lerp(focusColor, other.focusColor, t),
      focusWidth: lerpDouble(focusWidth, other.focusWidth, t)!,
    );
  }
}
