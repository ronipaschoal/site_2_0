import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';

/// The site's standard `AppBar` chrome (menu-colored surface, no elevation
/// tint) shared by [HomeScreen], `CvScreen`, and `CvDialogWidget`'s
/// small-screen sheet.
///
/// With [maxContentWidth], the bar itself still spans the whole window but
/// its leading/title/actions are laid out inside a centered column of that
/// width — so on wide screens they line up with the page content instead of
/// drifting to the window edges.
class RpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final double? maxContentWidth;

  const RpAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.maxContentWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final maxWidth = maxContentWidth;
    if (maxWidth == null) {
      return AppBar(
        surfaceTintColor: context.rpColors.menuColor,
        backgroundColor: context.rpColors.menuColor,
        leading: leading,
        title: title,
        actions: actions,
      );
    }

    // Mirrors AppBar's own spacing: a 56px leading slot, 16px before the
    // title (NavigationToolbar's default middle spacing), actions flush
    // right.
    return AppBar(
      surfaceTintColor: context.rpColors.menuColor,
      backgroundColor: context.rpColors.menuColor,
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      title: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              if (leading != null)
                SizedBox(width: kToolbarHeight, child: leading),
              const SizedBox(width: NavigationToolbar.kMiddleSpacing),
              // A single flexible slot, so the free space pushes the
              // actions flush right (a Flexible title plus a Spacer would
              // split it between them).
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: title,
                ),
              ),
              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}
