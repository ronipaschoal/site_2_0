import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/sections/home_section.dart';
import 'package:ronip/pages/home/widgets/cv_menu_link_widget.dart';
import 'package:ronip/pages/home/widgets/home_drawer_widget.dart';
import 'package:ronip/pages/home/widgets/home_menu_widget.dart';
import 'package:ronip/pages/home/widgets/home_quote_band_widget.dart';
import 'package:ronip/pages/home/sections/about_section.dart';
import 'package:ronip/pages/home/sections/contact_section.dart';
import 'package:ronip/pages/home/sections/work_gallery_section.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/widgets/flutter_banner_widget.dart';
import 'package:ronip/widgets/locale_button_widget.dart';
import 'package:ronip/widgets/logo_scroll_transition_widget.dart';
import 'package:ronip/widgets/logo_widget.dart';
import 'package:ronip/widgets/rp_app_bar.dart';
import 'package:ronip/widgets/scroll_progress_widget.dart';
import 'package:ronip/widgets/theme_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _drawerKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  late final _appCubit = context.read<AppCubit>();
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
  );

  late final _programsMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.programs,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
  );

  late final _contactMenu = HomeMenu(
    key: GlobalKey(),
    section: HomeSectionEnum.contact,
    drawerKey: _drawerKey,
    scrollController: _scrollController,
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
    CvMenuLinkWidget(
      drawerKey: _drawerKey,
    ),
    LocaleButtonWidget(
      changeLocale: _appCubit.changeLocale,
    ),
    ThemeButtonWidget(
      toggleTheme: _appCubit.toggleTheme,
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
    final isSmallScreen = context.isSmallScreen;

    return FlutterBannerWidget(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200.0),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Scaffold(
                key: _drawerKey,
                extendBody: true,
                extendBodyBehindAppBar: true,
                drawer: isSmallScreen
                    ? HomeDrawerWidget(
                        menuList: _menuList,
                        externalMenuList: _externalMenuList,
                        actionList: _actionList,
                      )
                    : null,
                appBar: isSmallScreen
                    ? RpAppBar(
                        leading: IconButton(
                          icon: const RpLogoWidget.menu(),
                          onPressed: () =>
                              _drawerKey.currentState?.openDrawer(),
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        ),
                      )
                    : RpAppBar(
                        title: SelectableText(
                          'Roni Paschoal',
                          semanticsLabel: 'Roni Paschoal',
                          style: RpTheme.pageTitleStyle(
                            context.rpColors.textHighlightColor,
                          ),
                        ),
                        actions: [
                          HomeMenuWidget(
                            menuList: _menuList,
                            externalMenuList: _externalMenuList,
                            actionList: _actionList,
                          ),
                          RpTheme.spacerLarge,
                        ],
                      ),
                body: Stack(
                  children: [
                    Positioned(
                      bottom: -MediaQuery.sizeOf(context).height / 7,
                      left: -MediaQuery.sizeOf(context).width / 4,
                      child: RpLogoScrollTransitionWidget(
                        scrollController: _scrollController,
                        sectionKey: _homeMenu.key,
                      ),
                    ),
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          HomeSection(
                            key: _getKeyByTitle(HomeSectionEnum.home),
                          ),
                          HomeQuoteBandWidget(
                            text: AppLocalizations.of(context)!
                                .solutionPhilosophy,
                            scrollController: _scrollController,
                          ),
                          AboutSection(
                            key: _getKeyByTitle(HomeSectionEnum.about),
                            scrollController: _scrollController,
                          ),
                          WorkGallerySection(
                            key: _getKeyByTitle(HomeSectionEnum.programs),
                            scrollController: _scrollController,
                          ),
                          ContactSection(
                            key: _getKeyByTitle(HomeSectionEnum.contact),
                            externalMenuList: _externalMenuList,
                            scrollController: _scrollController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: RpScrollProgressWidget(
                  scrollController: _scrollController,
                ),
              ),
            ],
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
