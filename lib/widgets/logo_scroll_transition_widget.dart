import 'package:flutter/material.dart';
import 'package:ronip/widgets/logo_widget.dart';
import 'package:ronip/widgets/scroll_progress_mixin.dart';

/// Grows the big background watermark logo out of the small hero logo in
/// `HomeSection` as the user scrolls past it, so the two read as one logo
/// transitioning rather than two unrelated marks.
///
/// At scroll offset `0` the logo sits shrunk and offset near the hero logo's
/// spot, fully transparent. As [scrollController] scrolls across the height
/// of [sectionKey]'s widget, it grows, slides and fades into whatever final
/// position/size this widget is given (via its parent `Positioned`).
class RpLogoScrollTransitionWidget extends StatefulWidget {
  final ScrollController scrollController;
  final GlobalKey sectionKey;
  final double targetOpacity;
  final double startScale;

  /// Start offset expressed as a fraction of the screen width/height,
  /// applied on top of this widget's own (final) position.
  final Offset startOffset;

  const RpLogoScrollTransitionWidget({
    super.key,
    required this.scrollController,
    required this.sectionKey,
    this.targetOpacity = 0.05,
    this.startScale = 0.13,
    this.startOffset = const Offset(0.23, -0.37),
  });

  @override
  State<RpLogoScrollTransitionWidget> createState() =>
      _RpLogoScrollTransitionWidgetState();
}

class _RpLogoScrollTransitionWidgetState
    extends State<RpLogoScrollTransitionWidget> with ScrollProgressMixin {
  @override
  ScrollController get scrollProgressController => widget.scrollController;

  @override
  double computeScrollProgress() {
    final extent = widget.sectionKey.currentContext?.size?.height ?? 0.0;
    return extent <= 0 ? 0.0 : widget.scrollController.offset / extent;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final t = reduceMotion ? 1.0 : Curves.easeOutCubic.transform(progress);
    final size = MediaQuery.sizeOf(context);

    return Transform.translate(
      offset: Offset(
        widget.startOffset.dx * size.width * (1 - t),
        widget.startOffset.dy * size.height * (1 - t),
      ),
      child: Transform.scale(
        scale: widget.startScale + (1 - widget.startScale) * t,
        child: RpLogoWidget.screen(opacity: t * widget.targetOpacity),
      ),
    );
  }
}
