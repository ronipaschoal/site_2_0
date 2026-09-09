import 'package:flutter/material.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/image_widget.dart';

class RpLogoWidget extends StatelessWidget {
  final Size? size;
  final Color? color;
  final String asset;
  final EdgeInsets padding;
  final double opacity;

  const RpLogoWidget({
    super.key,
    this.size = const Size(80.0, 80.0),
    this.color,
    this.asset = 'assets/images/logos/logo.png',
    this.padding = const EdgeInsets.all(1.0),
    this.opacity = 1.0,
  });

  const RpLogoWidget.menu({
    super.key,
    this.size = const Size(36.0, 36.0),
    this.color,
    this.asset = 'assets/images/logos/logo-menu.png',
    this.padding = const EdgeInsets.all(0.4),
    this.opacity = 1.0,
  });

  const RpLogoWidget.screen({
    super.key,
    this.color,
    this.asset = 'assets/images/logos/logo-original.png',
    this.padding = const EdgeInsets.all(1.0),
    this.opacity = 0.1,
  }) : size = null;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? MediaQuery.sizeOf(context);
    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          Padding(
            padding: padding,
            child: RpImageWidget(
              asset: asset,
              width: effectiveSize.width,
              height: effectiveSize.height,
              color: RpTheme.brandColor,
              fit: BoxFit.contain,
            ),
          ),
          RpImageWidget(
            asset: asset,
            width: effectiveSize.width,
            height: effectiveSize.height,
            color: RpTheme.textHighlightColor,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
