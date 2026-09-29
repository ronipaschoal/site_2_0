import 'package:flutter/widgets.dart';

/// Reduce-motion helpers.
///
/// Read the preference through these rather than
/// `platformDispatcher.accessibilityFeatures` in `initState`: that is a
/// one-off snapshot, so the widget ignores a setting changed while it's on
/// screen, and it bypasses [MediaQuery] overrides (including tests).
///
/// Maps to "Remove animations" on Android, "Reduce Motion" on iOS and
/// `prefers-reduced-motion` on the web.
extension A11yMotionContext on BuildContext {
  /// Whether the user asked for animations to be reduced. Registers a
  /// [MediaQuery] dependency, so the calling widget rebuilds (and
  /// `didChangeDependencies` runs) when it changes.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  /// [duration], or [Duration.zero] under reduced motion.
  Duration motionDuration(Duration duration) =>
      reduceMotion ? Duration.zero : duration;
}

/// Reduce-motion lookup for code without a [BuildContext] (e.g. a model that
/// scrolls a controller). Read it at the moment of animating, not once up
/// front, so it stays current.
abstract final class A11yMotion {
  /// The platform's current reduce-motion setting.
  static bool get platformReduceMotion => WidgetsBinding
      .instance
      .platformDispatcher
      .accessibilityFeatures
      .disableAnimations;

  /// [duration], or [Duration.zero] under reduced motion.
  static Duration duration(Duration duration) =>
      platformReduceMotion ? Duration.zero : duration;
}

/// Other system display preferences worth honoring on mobile.
extension A11yDisplayContext on BuildContext {
  /// iOS "Bold Text" / Android "Bold text". [Text] already applies it; use
  /// this for custom-painted text or icon stroke weight.
  bool get boldText => MediaQuery.maybeBoldTextOf(this) ?? false;

  /// iOS "Increase Contrast". Swap to higher-contrast colors when true.
  bool get highContrast => MediaQuery.maybeHighContrastOf(this) ?? false;
}
