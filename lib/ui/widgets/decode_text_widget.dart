import 'dart:math';

import 'package:flutter/material.dart';

/// Displays [text] scrambled through random characters that progressively
/// lock into the real glyphs, left to right, once the widget first scrolls
/// within [revealAtFraction] of the viewport height from the top.
class RpDecodeTextWidget extends StatefulWidget {
  final String text;
  final ScrollController scrollController;
  final TextStyle? style;
  final TextAlign? textAlign;
  final double revealAtFraction;

  const RpDecodeTextWidget({
    super.key,
    required this.text,
    required this.scrollController,
    this.style,
    this.textAlign,
    this.revealAtFraction = 0.88,
  });

  @override
  State<RpDecodeTextWidget> createState() => _RpDecodeTextWidgetState();
}

class _RpDecodeTextWidgetState extends State<RpDecodeTextWidget>
    with SingleTickerProviderStateMixin {
  static const _charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#%&*+-/\\';

  final _anchorKey = GlobalKey();
  final _random = Random();
  late final AnimationController _controller;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    final charDuration = 55 * widget.text.length;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion
          ? Duration.zero
          : Duration(milliseconds: charDuration.clamp(350, 1600)),
    );

    if (reduceMotion) {
      _triggered = true;
      _controller.value = 1.0;
    } else {
      widget.scrollController.addListener(_checkReveal);
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkReveal());
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkReveal);
    _controller.dispose();
    super.dispose();
  }

  void _checkReveal() {
    if (_triggered || !mounted) return;
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < viewportHeight * widget.revealAtFraction) {
      setState(() => _triggered = true);
      widget.scrollController.removeListener(_checkReveal);
      _controller.forward();
    }
  }

  String _scrambledAt(double progress) {
    final revealCount = (progress * widget.text.length).ceil();
    final runes = widget.text.runes.toList();
    return String.fromCharCodes(
      List.generate(runes.length, (i) {
        final rune = runes[i];
        if (rune == 32 || i < revealCount) return rune;
        return _charset.codeUnitAt(_random.nextInt(_charset.length));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _anchorKey,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Opacity(
          opacity: _triggered ? 1.0 : 0.0,
          child: Text(
            _triggered ? _scrambledAt(_controller.value) : widget.text,
            semanticsLabel: widget.text,
            textAlign: widget.textAlign,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
