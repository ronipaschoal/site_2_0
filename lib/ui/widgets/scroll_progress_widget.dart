import 'package:flutter/material.dart';
import 'package:ronip/ui/theme.dart';

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

class _RpScrollProgressWidgetState extends State<RpScrollProgressWidget> {
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
    final position = widget.scrollController.position;
    final maxExtent = position.maxScrollExtent;
    final progress =
        maxExtent <= 0 ? 0.0 : (position.pixels / maxExtent).clamp(0.0, 1.0);
    if (progress != _progress) {
      setState(() => _progress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _progress,
        child: ColoredBox(color: widget.color),
      ),
    );
  }
}
