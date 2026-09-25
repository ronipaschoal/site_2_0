import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';

class FlutterBannerWidget extends StatelessWidget {
  final Widget child;

  const FlutterBannerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // No SafeArea around [child]: the pages lay themselves out against the
    // full screen and handle the insets per section (hero and section
    // SafeAreas, the gallery's paddingOf-based offsets, the AppBar's own
    // status-bar padding). Wrapping them here would zero those insets while
    // shrinking the visible area — so every viewport-height section ended
    // up taller than what's on screen, pushing bottom-anchored elements
    // (the hero's scroll cue, the gallery's progress) under the home
    // indicator on notched phones.
    //
    // Only the ribbon is kept inside the safe area, so it isn't hidden
    // behind a rounded display corner.
    return Container(
      color: context.rpColors.backgroundColor,
      child: Stack(
        children: [
          Positioned.fill(child: Center(child: child)),
          const Positioned.fill(
            child: IgnorePointer(
              child: SafeArea(
                child: Banner(
                  location: BannerLocation.topEnd,
                  message: 'Flutter',
                  color: RpTheme.bannerColor,
                  child: SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
