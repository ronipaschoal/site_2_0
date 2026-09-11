import 'package:flutter/material.dart';
import 'package:ronip/ui/widgets/logo_widget.dart';

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
    extends State<RpLogoScrollTransitionWidget> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (!widget.scrollController.hasClients) return;
    final extent = widget.sectionKey.currentContext?.size?.height ?? 0.0;
    final progress = extent <= 0
        ? 0.0
        : (widget.scrollController.offset / extent).clamp(0.0, 1.0);
    if (progress != _progress) {
      setState(() => _progress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final t = reduceMotion ? 1.0 : Curves.easeOutCubic.transform(_progress);
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
