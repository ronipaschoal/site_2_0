import 'package:flutter/material.dart';

class RpImageWidget extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final Color? color;

  const RpImageWidget({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      color: color,
    );
  }
}
