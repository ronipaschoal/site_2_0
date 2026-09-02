import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/helpers/media_query_helper.dart';
import 'package:ronip/model/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/sections/home_section.dart';
import 'package:ronip/pages/home/widgets/home_drawer_widget.dart';
import 'package:ronip/pages/home/widgets/home_menu_widget.dart';
import 'package:ronip/pages/home/sections/about_section.dart';
import 'package:ronip/pages/home/sections/contact_section.dart';
import 'package:ronip/pages/home/sections/work_section.dart';
import 'package:ronip/ui/theme.dart';
import 'package:ronip/ui/widgets/flutter_banner_widget.dart';
import 'package:ronip/ui/widgets/locale_button_widget.dart';
import 'package:ronip/ui/widgets/logo_widget.dart';

class HomeScreen extends StatefulWidget {
  final AppCubit appCubit;

  const HomeScreen({
    super.key,
    required this.appCubit,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _drawerKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  late final _homeCubit = context.read<HomeCubit>();

  late final _homeMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.home,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
  );

  late final _aboutMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.about,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
    previousMenuList: [_homeMenu],
  );

  late final _programsMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.programs,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
    previousMenuList: [_homeMenu, _aboutMenu],
  );

  late final _contactMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.contact,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
    previousMenuList: [_homeMenu, _aboutMenu, _programsMenu],
  );

  late final _menuList = [
    _homeMenu,
    _aboutMenu,
    _programsMenu,
    _contactMenu,
  ];

  late final _externalMenuList = [
    ExternalMenu(
      text: 'LinkedIn',
      icon: 'assets/images/logos/linkedin.svg',
      url: 'https://www.linkedin.com/in/roni-paschoal/',
    ),
    ExternalMenu(
      text: 'GitHub',
      icon: 'assets/images/logos/github.svg',
      url: 'https://github.com/ronipaschoal/',
    ),
  ];

  late final _actionList = <Widget>[
    LocaleButtonWidget(
      changeLocale: widget.appCubit.changeLocale,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() => _onScroll(_scrollController.offset));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBannerWidget(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200.0),
        child: SizedBox(
          width: double.infinity,
          child: Scaffold(
            key: _drawerKey,
            extendBody: true,
            extendBodyBehindAppBar: true,
            drawer: MediaQueryHelper(context).isSmallScreen()
                ? HomeDrawerWidget(
                    drawerKey: _drawerKey,
                    scrollController: _scrollController,
                    menuList: _menuList,
                    externalMenuList: _externalMenuList,
                    actionList: _actionList,
                  )
                : null,
            appBar: MediaQueryHelper(context).isSmallScreen()
                ? AppBar(
                    title: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Text(
                          state.activeMenu.title(context),
                          style: const TextStyle(
                            color: RpTheme.textHighlightColor,
                          ),
                        );
                      },
                    ),
                    surfaceTintColor: RpTheme.menuColor,
                    backgroundColor: RpTheme.menuColor,
                    leading: IconButton(
                      icon: const RpLogoWidget.menu(),
                      onPressed: () => _drawerKey.currentState?.openDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  )
                : AppBar(
                    surfaceTintColor: RpTheme.menuColor,
                    backgroundColor: RpTheme.menuColor,
                    title: const RpLogoWidget(size: Size(36.0, 36.0)),
                    actions: [
                      HomeMenuWidget(
                        drawerKey: _drawerKey,
                        scrollController: _scrollController,
                        menuList: _menuList,
                        externalMenuList: _externalMenuList,
                        actionList: _actionList,
                      ),
                      RpTheme.spacerLarge,
                    ],
                  ),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HomeSection(key: _getKeyByTitle(HomeSectionEnum.home)),
                  AboutSection(key: _getKeyByTitle(HomeSectionEnum.about)),
                  WorkSection(key: _getKeyByTitle(HomeSectionEnum.programs)),
                  ContactSection(
                    key: _getKeyByTitle(HomeSectionEnum.contact),
                    externalMenuList: _externalMenuList,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onScroll(double controllerHeight) {
    for (var menu in _menuList) {
      if (controllerHeight >= menu.sectionPosition &&
          controllerHeight < menu.sectionPosition + menu.sectionSize) {
        _homeCubit.activeMenu(menu.section);
      }
    }
  }

  Key _getKeyByTitle(HomeSectionEnum title) {
    return _menuList.firstWhere((menu) => menu.section == title).key;
  }
}
