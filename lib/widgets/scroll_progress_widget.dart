import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/scroll_progress_mixin.dart';

/// Thin bar pinned to the top of the page that fills left-to-right in step
/// with [scrollController]'s scroll progress through the full page height.
class RpScrollProgressWidget extends StatefulWidget {
  final ScrollController scrollController;
  final double height;
  final Color color;

  const RpScrollProgressWidget({
    super.key,
    required this.scrollController,
    this.height = 2.0,
    this.color = RpTheme.brandColor,
  });

  @override
  State<RpScrollProgressWidget> createState() => _RpScrollProgressWidgetState();
}

class _RpScrollProgressWidgetState extends State<RpScrollProgressWidget>
    with ScrollProgressMixin {
  @override
  ScrollController get scrollProgressController => widget.scrollController;

  @override
  double computeScrollProgress() {
    final position = widget.scrollController.position;
    final maxExtent = position.maxScrollExtent;
    return maxExtent <= 0 ? 0.0 : position.pixels / maxExtent;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: ColoredBox(color: widget.color),
      ),
    );
  }
}
