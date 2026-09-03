import 'package:flutter/material.dart';

/// Fades and slides [child] up once it first scrolls within
/// [revealAtFraction] of the viewport height from the top — a one-time
/// scroll-triggered reveal, distinct from [RpParallaxWidget]'s continuous
/// scroll-linked drift.
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
  State<RpRevealOnScrollWidget> createState() =>
      _RpRevealOnScrollWidgetState();
}

class _RpRevealOnScrollWidgetState extends State<RpRevealOnScrollWidget>
    with SingleTickerProviderStateMixin {
  final _anchorKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    widget.scrollController.addListener(_checkReveal);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkReveal());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkReveal);
    _controller.dispose();
    super.dispose();
  }

  void _checkReveal() {
    if (_revealed || !mounted) return;
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < viewportHeight * widget.revealAtFraction) {
      _revealed = true;
      widget.scrollController.removeListener(_checkReveal);
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _anchorKey,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Opacity(
          opacity: _animation.value,
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
