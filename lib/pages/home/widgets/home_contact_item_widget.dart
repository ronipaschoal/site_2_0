import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';
import 'dart:ui';

class HomeContactItemWidget extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const HomeContactItemWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: 280.0,
          height: 140.0,
          decoration: BoxDecoration(
            color: context.rpColors.textHighlightColor.withAlpha(20),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: context.rpColors.textHighlightColor.withAlpha(40),
              width: 1.5,
            ),
          ),
          child: IconButton(
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
            onPressed: onPressed,
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                RpTheme.spacerMedium,
                Text(
                  text,
                  style: TextStyle(
                    color: context.rpColors.textColor,
                    fontSize: RpTheme.fontSizeRegular,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
