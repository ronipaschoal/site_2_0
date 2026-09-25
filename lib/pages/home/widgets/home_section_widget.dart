import 'package:flutter/material.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/core/theme.dart';

class HomeSectionWidget extends StatefulWidget {
  final Widget child;

  const HomeSectionWidget({
    super.key,
    required this.child,
  });

  @override
  State<HomeSectionWidget> createState() => _HomeSectionWidgetState();
}

class _HomeSectionWidgetState extends State<HomeSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height,
          maxWidth: RpTheme.contentMaxWidth,
        ),
        padding: isSmallScreen
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : const EdgeInsets.symmetric(horizontal: 48.0),
        child: SafeArea(child: widget.child),
      ),
    );
  }
}
