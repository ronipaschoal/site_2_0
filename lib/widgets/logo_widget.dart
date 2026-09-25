import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/image_widget.dart';

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
    this.padding = const EdgeInsets.all(0.2),
    this.opacity = 1.0,
  });

  const RpLogoWidget.menu({
    super.key,
    this.size = const Size(36.0, 36.0),
    this.color,
    this.asset = 'assets/images/logos/logo-menu.png',
    this.padding = const EdgeInsets.all(0.0),
    this.opacity = 1.0,
  });

  const RpLogoWidget.screen({
    super.key,
    this.color,
    this.asset = 'assets/images/logos/logo-original.png',
    this.padding = const EdgeInsets.all(0.6),
    this.opacity = 0.1,
  }) : size = null;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? MediaQuery.sizeOf(context);
    // Decorative: three stacked, unlabelled copies of the mark (shadow, brand
    // offset, face) would otherwise be announced as three blank images. The
    // name always sits next to it.
    return ExcludeSemantics(
      child: Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            RpImageWidget(
              asset: asset,
              width: effectiveSize.width,
              height: effectiveSize.height,
              color: RpTheme.blackColor,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: padding.copyWith(
                left: padding.left * 10,
                top: padding.top * 10,
              ),
              child: RpImageWidget(
                asset: asset,
                width: effectiveSize.width,
                height: effectiveSize.height,
                color: RpTheme.brandColor,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: padding,
              child: RpImageWidget(
                asset: asset,
                width: effectiveSize.width,
                height: effectiveSize.height,
                color: RpTheme.whiteColor,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
