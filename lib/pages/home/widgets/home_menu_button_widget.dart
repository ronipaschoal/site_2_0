import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/ui/theme.dart';

class HomeMenuButtonWidget extends StatelessWidget {
  final HomeMenu menu;

  const HomeMenuButtonWidget({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, current) => prev.activeMenu != current.activeMenu,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _goToSection(menu),
              child: Text(
                menu.translate(context),
                style: menu.section == state.activeMenu
                    ? TextStyle(color: RpTheme.textHighlightColor)
                    : TextStyle(color: RpTheme.textColor),
              ),
            ),
            if (menu.section == state.activeMenu)
              Container(
                width: 16.0,
                height: 2.0,
                color: RpTheme.brandColor,
              ),
          ],
        );
      },
    );
  }

  void _goToSection(HomeMenu menu) {
    menu.drawerKey.currentState?.closeDrawer();
    menu.scrollController.animateTo(
      menu.sectionPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
