import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';

/// The site's standard `AppBar` chrome (menu-colored surface, no elevation
/// tint) shared by [HomeScreen], `CvScreen`, and `CvDialogWidget`'s
/// small-screen sheet.
class RpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  const RpAppBar({super.key, this.leading, this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: context.rpColors.menuColor,
      backgroundColor: context.rpColors.menuColor,
      leading: leading,
      title: title,
      actions: actions,
    );
  }
}
