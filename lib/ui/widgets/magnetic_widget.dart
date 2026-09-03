import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Desktop-only "magnetic button" effect: [child] drifts a fraction of the
/// distance towards the cursor while hovered, and eases back to rest on
/// exit. Touch devices never fire hover events, so this is inert there.
class RpMagneticWidget extends StatefulWidget {
  final Widget child;
  final double strength;

  const RpMagneticWidget({
    super.key,
    required this.child,
    this.strength = 0.35,
  });

  @override
  State<RpMagneticWidget> createState() => _RpMagneticWidgetState();
}

class _RpMagneticWidgetState extends State<RpMagneticWidget> {
  final _anchorKey = GlobalKey();
  Offset _offset = Offset.zero;

  void _onHover(PointerHoverEvent event) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) return;

    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final local = box.globalToLocal(event.position);
    final center = Offset(box.size.width / 2, box.size.height / 2);
    setState(() => _offset = (local - center) * widget.strength);
  }

  void _onExit(PointerExitEvent event) {
    setState(() => _offset = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final atRest = _offset == Offset.zero;

    return MouseRegion(
      key: _anchorKey,
      onHover: _onHover,
      onExit: _onExit,
      child: AnimatedContainer(
        duration:
            atRest ? const Duration(milliseconds: 400) : const Duration(milliseconds: 120),
        curve: atRest ? Curves.easeOutCubic : Curves.linear,
        transform: Matrix4.translationValues(_offset.dx, _offset.dy, 0.0),
        child: widget.child,
      ),
    );
  }
}
