import 'package:flutter/material.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/magnetic_widget.dart';

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
    return Center(
      child: RpMagneticWidget(
        child: SizedBox(
          width: 280.0,
          height: 140.0,
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color.fromARGB(152, 6, 6, 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
            onPressed: onPressed,
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                RpTheme.spacerMedium,
                Text(
                  text,
                  style: const TextStyle(
                    color: RpTheme.textColor,
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
