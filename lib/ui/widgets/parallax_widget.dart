import 'package:flutter/material.dart';

/// Shifts [child] vertically as [scrollController] scrolls, based on how far
/// this widget's own laid-out position sits from the viewport's vertical
/// centre — a classic scroll-linked parallax drift.
///
/// [speed] of `0` keeps the child pinned to the screen; `1` makes it track
/// the scroll like regular content; negative values drift the opposite way.
/// The [GlobalKey] used to read the layout position sits outside the
/// [Transform], so the translation it applies doesn't feed back into itself.
class RpParallaxWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double speed;

  /// Clamps the applied shift to +/- this many logical pixels. Useful when
  /// the child has limited visual overflow room (e.g. a cropped image) and
  /// a large [speed] would otherwise reveal empty edges.
  final double? maxShift;

  const RpParallaxWidget({
    super.key,
    required this.child,
    required this.scrollController,
    this.speed = 0.12,
    this.maxShift,
  });

  @override
  State<RpParallaxWidget> createState() => _RpParallaxWidgetState();
}

class _RpParallaxWidgetState extends State<RpParallaxWidget> {
  final _anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return KeyedSubtree(
      key: _anchorKey,
      child: reduceMotion
          ? widget.child
          : AnimatedBuilder(
              animation: widget.scrollController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _verticalShift()),
                child: child,
              ),
              child: widget.child,
            ),
    );
  }

  double _verticalShift() {
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return 0.0;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final centerY = box.localToGlobal(Offset.zero).dy + box.size.height / 2;
    final distanceFromViewportCenter = centerY - viewportHeight / 2;

    final shift = -distanceFromViewportCenter * widget.speed;
    final maxShift = widget.maxShift;
    return maxShift == null ? shift : shift.clamp(-maxShift, maxShift);
  }
}
