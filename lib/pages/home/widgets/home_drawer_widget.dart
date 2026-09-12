import 'package:flutter/material.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/widgets/home_menu_content_widget.dart';
import 'package:ronip/core/theme.dart';

class HomeDrawerWidget extends StatelessWidget {
  final List<HomeMenu> menuList;
  final List<ExternalMenu> externalMenuList;
  final List<Widget> actionList;

  const HomeDrawerWidget({
    super.key,
    required this.menuList,
    required this.externalMenuList,
    required this.actionList,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.rpColors.menuColor,
      child: Center(
        child: HomeMenuContentWidget(
          direction: Axis.vertical,
          menuList: menuList,
          externalMenuList: externalMenuList,
          actionList: actionList,
        ),
      ),
    );
  }
}
