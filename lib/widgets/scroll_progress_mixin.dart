import 'package:flutter/widgets.dart';

/// Recomputes a 0..1 [progress] value from [scrollProgressController]
/// whenever it scrolls, rebuilding only when the (clamped) value actually
/// changes. Shared by [RpScrollProgressWidget] and
/// `RpLogoScrollTransitionWidget`.
mixin ScrollProgressMixin<T extends StatefulWidget> on State<T> {
  double progress = 0.0;

  ScrollController get scrollProgressController;

  /// Called only while the controller has clients; the result is clamped
  /// to 0..1 for you.
  double computeScrollProgress();

  @override
  void initState() {
    super.initState();
    scrollProgressController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    scrollProgressController.removeListener(_updateScrollProgress);
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!scrollProgressController.hasClients) return;
    final next = computeScrollProgress().clamp(0.0, 1.0);
    if (next != progress) setState(() => progress = next);
  }
}
