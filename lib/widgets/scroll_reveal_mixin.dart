import 'package:flutter/widgets.dart';

/// One-shot "has this widget scrolled into view yet" tracking, shared by
/// [RpRevealOnScrollWidget] and `RpDecodeTextWidget`: [revealAnchorKey]
/// marks the tracked widget, and [onReveal] fires exactly once, the first
/// time its top edge scrolls within [revealAtFraction] of the viewport
/// height from the top of the screen.
///
/// Tracking isn't started automatically (call [startRevealTracking] from
/// `initState`) since a caller may skip it entirely — e.g. under reduced
/// motion, where the widget can just start already revealed. [stopRevealTracking]
/// is always safe to call from `dispose`, tracking or not.
mixin ScrollRevealMixin<T extends StatefulWidget> on State<T> {
  final revealAnchorKey = GlobalKey();
  bool revealed = false;

  ScrollController get revealScrollController;
  double get revealAtFraction;

  /// Called once, synchronously inside `setState`, the first time the
  /// anchor is revealed.
  void onReveal();

  void startRevealTracking() {
    revealScrollController.addListener(_checkReveal);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkReveal());
  }

  void stopRevealTracking() {
    revealScrollController.removeListener(_checkReveal);
  }

  void _checkReveal() {
    if (revealed || !mounted) return;
    final box =
        revealAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < viewportHeight * revealAtFraction) {
      stopRevealTracking();
      setState(() {
        revealed = true;
        onReveal();
      });
    }
  }
}
