import 'package:flutter/material.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_menu_button_widget.dart';
import 'package:ronip/ui/theme.dart';

class HomeMenuWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  final ScrollController scrollController;
  final List<HomeMenu> menuList;
  final List<ExternalMenu> externalMenuList;
  final List<Widget> actionList;

  const HomeMenuWidget({
    super.key,
    required this.drawerKey,
    required this.scrollController,
    required this.menuList,
    required this.externalMenuList,
    required this.actionList,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: menuList.length,
          itemBuilder: (_, index) =>
              HomeMenuButtonWidget(menu: menuList[index]),
          separatorBuilder: (_, __) => RpTheme.spacerSmallX,
        ),
        RpTheme.spacerMedium,
        Container(
          width: 1.0,
          height: 24.0,
          color: RpTheme.brandColor,
        ),
        RpTheme.spacerMedium,
        ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: externalMenuList.length,
          itemBuilder: (_, index) {
            final externalMenu = externalMenuList[index];
            return IconButton(
              onPressed: externalMenu.goToExternal,
              icon: externalMenu.iconWidget(const Size(16.0, 16.0)),
            );
          },
          separatorBuilder: (_, __) => RpTheme.spacerSmallX,
        ),
        RpTheme.spacerMedium,
        Container(
          width: 1.0,
          height: 24.0,
          color: RpTheme.brandColor,
        ),
        RpTheme.spacerMedium,
        ...actionList,
      ],
    );
  }
}
