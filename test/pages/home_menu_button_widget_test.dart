import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/widgets/home_menu_button_widget.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('highlights its label once its section becomes active',
      (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    final drawerKey = GlobalKey<ScaffoldState>();
    final homeCubit = HomeCubit();
    addTearDown(homeCubit.close);

    final menu = HomeMenu(
      key: GlobalKey(),
      section: HomeSectionEnum.about,
      drawerKey: drawerKey,
      scrollController: scrollController,
    );

    await pumpApp(
      tester,
      BlocProvider.value(
        value: homeCubit,
        child: Scaffold(
          key: drawerKey,
          body: SingleChildScrollView(
            controller: scrollController,
            child: HomeMenuButtonWidget(menu: menu),
          ),
        ),
      ),
      brightness: Brightness.dark,
    );

    Color labelColor() => tester.widget<Text>(find.text('About')).style!.color!;

    final colors = RpTheme.themeFor(Brightness.dark).extension<RpColors>()!;

    expect(labelColor(), colors.textColor);

    homeCubit.activeMenu(HomeSectionEnum.about);
    await tester.pump();

    expect(labelColor(), colors.textHighlightColor);

    // Tapping scrolls to the section without throwing, even though this
    // menu's own section widget isn't mounted anywhere in this test tree.
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
  });
}
