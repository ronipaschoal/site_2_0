import 'package:flutter/material.dart';
import 'package:ronip/ui/theme.dart';

class FlutterBannerWidget extends StatelessWidget {
  final Widget child;

  const FlutterBannerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RpTheme.backgroundColor,
      child: SafeArea(
        child: Banner(
          location: BannerLocation.topEnd,
          message: 'Flutter',
          color: RpTheme.bannerColor,
          child: Center(child: child),
        ),
      ),
    );
  }
}
