import 'package:flutter/material.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_menu_content_widget.dart';

class HomeMenuWidget extends StatelessWidget {
  final List<HomeMenu> menuList;
  final List<ExternalMenu> externalMenuList;
  final List<Widget> actionList;

  const HomeMenuWidget({
    super.key,
    required this.menuList,
    required this.externalMenuList,
    required this.actionList,
  });

  @override
  Widget build(BuildContext context) {
    return HomeMenuContentWidget(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      menuList: menuList,
      externalMenuList: externalMenuList,
      actionList: actionList,
    );
  }
}
