import 'package:flutter/material.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_menu_button_widget.dart';
import 'package:ronip/core/theme.dart';

/// The site's nav content — section menu, external links, and the
/// locale/theme/CV actions — shared by `HomeMenuWidget` (the wide-screen
/// `AppBar`, laid out horizontally) and `HomeDrawerWidget` (the small-screen
/// drawer, laid out vertically).
///
/// The external-link icons always sit in a row, regardless of [direction] —
/// only the section menu and the two dividers flip to match it.
class HomeMenuContentWidget extends StatelessWidget {
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final List<HomeMenu> menuList;
  final List<ExternalMenu> externalMenuList;
  final List<Widget> actionList;

  const HomeMenuContentWidget({
    super.key,
    required this.direction,
    required this.menuList,
    required this.externalMenuList,
    required this.actionList,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  static Widget _flex(
    Axis axis,
    List<Widget> children, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) {
    return axis == Axis.horizontal
        ? Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  static Widget _spaced(Axis axis, List<Widget> children, SizedBox spacer) {
    return _flex(axis, [
      for (var i = 0; i < children.length; i++) ...[
        if (i != 0) spacer,
        children[i],
      ],
    ]);
  }

  Widget _divider() => direction == Axis.horizontal
      ? Container(width: 1.0, height: 24.0, color: RpTheme.brandColor)
      : Container(width: 120.0, height: 1.0, color: RpTheme.brandColor);

  @override
  Widget build(BuildContext context) {
    final menuGroup = _spaced(
      direction,
      [for (final menu in menuList) HomeMenuButtonWidget(menu: menu)],
      RpTheme.spacerSmallX,
    );

    final externalGroup = _spaced(
      Axis.horizontal,
      [
        for (final externalMenu in externalMenuList)
          IconButton(
            onPressed: externalMenu.goToExternal,
            icon: externalMenu.iconWidget(context, const Size(16.0, 16.0)),
          ),
      ],
      RpTheme.spacerSmallX,
    );

    return _flex(
      direction,
      [
        menuGroup,
        RpTheme.spacerMedium,
        _divider(),
        RpTheme.spacerMedium,
        externalGroup,
        RpTheme.spacerMedium,
        _divider(),
        RpTheme.spacerMedium,
        ...actionList,
      ],
      mainAxisAlignment: mainAxisAlignment,
    );
  }
}
