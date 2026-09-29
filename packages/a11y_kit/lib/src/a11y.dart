import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';

import 'web/link_guard.dart';

/// App-wide accessibility setup.
abstract final class A11y {
  static SemanticsHandle? _semantics;

  /// Call once from `main`, after `WidgetsFlutterBinding.ensureInitialized()`.
  ///
  /// On the web it:
  /// - keeps the semantics tree always on. Flutter Web renders to a canvas
  ///   and, by default, only builds its accessibility DOM after the visitor
  ///   finds and presses a hidden "Enable accessibility" button — so screen
  ///   readers would otherwise land on an empty page. Set [alwaysOnSemantics]
  ///   to false to keep Flutter's default and save the per-frame cost;
  /// - installs a guard so activating an [A11yTappable] link doesn't also
  ///   trigger the browser's own `<a href>` navigation.
  ///
  /// On Android and iOS it does nothing: the platform turns semantics on
  /// when TalkBack or VoiceOver starts, and there's no DOM to guard.
  static void ensureInitialized({bool alwaysOnSemantics = true}) {
    if (!kIsWeb) return;
    if (alwaysOnSemantics) {
      _semantics ??= SemanticsBinding.instance.ensureSemantics();
    }
    installSemanticLinkGuard();
  }
}
