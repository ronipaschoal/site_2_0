import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/scroll_reveal_mixin.dart';

/// The name in the handwritten display face, "written" left to right (a
/// clip wipe with a brand-colored pen tip) the first time it scrolls into
/// view.
class RpSignatureWidget extends StatefulWidget {
  final ScrollController scrollController;
  final double fontSize;

  const RpSignatureWidget({
    super.key,
    required this.scrollController,
    this.fontSize = 40.0,
  });

  @override
  State<RpSignatureWidget> createState() => _RpSignatureWidgetState();
}

class _RpSignatureWidgetState extends State<RpSignatureWidget>
    with SingleTickerProviderStateMixin, ScrollRevealMixin {
  late final AnimationController _controller;

  @override
  ScrollController get revealScrollController => widget.scrollController;

  @override
  double get revealAtFraction => 0.95;

  @override
  void onReveal() => _controller.forward();

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (reduceMotion) {
      revealed = true;
      _controller.value = 1.0;
    } else {
      startRevealTracking();
    }
  }

  @override
  void dispose() {
    stopRevealTracking();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      'Roni Paschoal',
      semanticsLabel: 'Roni Paschoal',
      style: TextStyle(
        fontFamily: RpTheme.fontFamilyDisplay,
        fontSize: widget.fontSize,
        height: 1.3,
        color: context.rpColors.textHighlightColor,
      ),
    );

    // Labelled outside the wipe: before the reveal the clip is zero-width,
    // which would otherwise drop the name from the semantics tree.
    return Semantics(
      label: 'Roni Paschoal',
      child: ExcludeSemantics(
        child: KeyedSubtree(
          key: revealAnchorKey,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = Curves.easeInOutSine.transform(_controller.value);
              return Stack(
                children: [
                  ClipRect(clipper: _WipeClipper(t), child: child),
                  if (t > 0.0 && t < 1.0)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment(t * 2 - 1, 0.2),
                        child: Container(
                          width: 2.0,
                          height: widget.fontSize * 0.7,
                          color: RpTheme.brandColor,
                        ),
                      ),
                    ),
                ],
              );
            },
            child: text,
          ),
        ),
      ),
    );
  }
}

/// Reveals the leftmost [fraction] of the child; clipping (rather than
/// resizing) keeps the final size, so the wipe never shifts the layout.
class _WipeClipper extends CustomClipper<Rect> {
  final double fraction;

  _WipeClipper(this.fraction);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0.0, 0.0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_WipeClipper oldClipper) => oldClipper.fraction != fraction;
}
