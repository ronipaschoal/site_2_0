import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

bool get _isNativeAndroid =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

/// Speaks a status message ("Copied", "Payment approved") that has no
/// focusable UI of its own.
///
/// Platform behavior differs, so pair it with [A11yLiveRegion]:
/// - web and iOS: sent as an announcement;
/// - Android: skipped. Android deprecated announcement events (they cut
///   off TalkBack's speech queue); wrap the text that changes in an
///   [A11yLiveRegion] instead, which covers Android.
abstract final class A11yAnnouncer {
  /// Announces [message] politely, in [context]'s view and text direction.
  static Future<void> announce(
    BuildContext context,
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) async {
    if (_isNativeAndroid) return;
    await SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      Directionality.of(context),
      assertiveness: assertiveness,
    );
  }
}

/// Marks [child] as a live region: when its label changes, the screen reader
/// reads the new one without focus moving there.
///
/// Enabled on Android only by default, as the counterpart of
/// [A11yAnnouncer]. On web the engine also announces a live region's label
/// as soon as the node appears (e.g. "Copy email" on page load), and on
/// iOS support is limited; set [enabled] to force it.
class A11yLiveRegion extends StatelessWidget {
  /// The content whose label changes.
  final Widget child;

  /// Overrides the platform default.
  final bool? enabled;

  /// Creates a live region.
  const A11yLiveRegion({super.key, required this.child, this.enabled});

  @override
  Widget build(BuildContext context) {
    if (!(enabled ?? _isNativeAndroid)) return child;
    return Semantics(liveRegion: true, child: child);
  }
}
