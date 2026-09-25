import 'package:flutter/material.dart';
import 'package:ronip/widgets/scroll_reveal_mixin.dart';

/// Fades and slides [child] up once it first scrolls within
/// [revealAtFraction] of the viewport height from the top — a one-time
/// reveal, not a continuous scroll-linked drift.
class RpRevealOnScrollWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;
  final double offsetY;
  final double revealAtFraction;

  const RpRevealOnScrollWidget({
    super.key,
    required this.child,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 600),
    this.offsetY = 24.0,
    this.revealAtFraction = 0.88,
  });

  @override
  State<RpRevealOnScrollWidget> createState() => _RpRevealOnScrollWidgetState();
}

class _RpRevealOnScrollWidgetState extends State<RpRevealOnScrollWidget>
    with SingleTickerProviderStateMixin, ScrollRevealMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  ScrollController get revealScrollController => widget.scrollController;

  @override
  double get revealAtFraction => widget.revealAtFraction;

  @override
  void onReveal() => _controller.forward();

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : widget.duration,
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    startRevealTracking();
  }

  @override
  void dispose() {
    stopRevealTracking();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: revealAnchorKey,
      child: AnimatedBuilder(
        animation: _animation,
        // alwaysIncludeSemantics: a not-yet-revealed (fully transparent)
        // child must still be reachable by screen readers, which navigate
        // the whole page without scrolling it into view first.
        builder: (context, child) => Opacity(
          opacity: _animation.value,
          alwaysIncludeSemantics: true,
          child: Transform.translate(
            offset: Offset(0, (1 - _animation.value) * widget.offsetY),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
