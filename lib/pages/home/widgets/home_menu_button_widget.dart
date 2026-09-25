import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/core/theme.dart';

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
        // `selected` tells screen readers which section is current — the
        // underline alone is visual only.
        return Semantics(
          selected: menu.section == state.activeMenu,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: menu.goTo,
                child: Text(
                  menu.translate(context),
                  style: menu.section == state.activeMenu
                      ? TextStyle(color: context.rpColors.textHighlightColor)
                      : TextStyle(color: context.rpColors.textColor),
                ),
              ),
              if (menu.section == state.activeMenu)
                Container(
                  width: 16.0,
                  height: 2.0,
                  color: RpTheme.brandColor,
                ),
            ],
          ),
        );
      },
    );
  }
}
