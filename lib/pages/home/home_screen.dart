import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/media_query_helper.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/models/locale_model.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/cv/cv_dialog_widget.dart';
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
import 'package:ronip/widgets/ambient_background_widget.dart';
import 'package:ronip/widgets/command_palette_widget.dart';
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
    RpCommandPaletteButtonWidget(
      onPressed: () {
        _drawerKey.currentState?.closeDrawer();
        _openCommandPalette();
      },
    ),
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
    HardwareKeyboard.instance.addHandler(_onKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() => _onScroll(_scrollController.offset));
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _scrollController.dispose();
    super.dispose();
  }

  /// ⌘K / Ctrl+K, handled globally rather than through a `Shortcuts`
  /// ancestor, so it works regardless of where keyboard focus sits on the
  /// page. Ignored while another route (the résumé dialog, or the palette
  /// itself) is on top.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.keyK) {
      return false;
    }
    final keyboard = HardwareKeyboard.instance;
    if (!keyboard.isMetaPressed && !keyboard.isControlPressed) return false;
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? true)) return false;

    _openCommandPalette();
    return true;
  }

  void _openCommandPalette() {
    final l10n = AppLocalizations.of(context)!;
    final nextLocale = Localizations.localeOf(context) == LocaleEnum.pt.locale
        ? LocaleEnum.en
        : LocaleEnum.pt;

    RpCommandPaletteWidget.show(context, [
      for (final menu in _menuList)
        RpCommand(
          label: l10n.commandGoTo(menu.translate(context)),
          icon: Icons.subdirectory_arrow_right,
          keywords: menu.section.name,
          run: menu.goTo,
        ),
      RpCommand(
        label: l10n.commandOpenCv,
        icon: Icons.description_outlined,
        keywords: 'cv resume curriculo',
        run: () => CvDialogWidget.show(context),
      ),
      RpCommand(
        label: l10n.copyEmail,
        icon: Icons.alternate_email,
        keywords: 'email mail contato contact $contactEmail',
        run: () async {
          await Clipboard.setData(const ClipboardData(text: contactEmail));
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.copied} ✓  $contactEmail'),
              behavior: SnackBarBehavior.floating,
              width: 360.0,
            ),
          );
        },
      ),
      for (final external in _externalMenuList)
        RpCommand(
          label: l10n.commandOpen(external.text),
          icon: Icons.north_east,
          run: external.goToExternal,
        ),
      RpCommand(
        label: l10n.commandOpen(l10n.sourceCode),
        icon: Icons.code,
        keywords: 'github source repo',
        run: () => HyperlinkHelper.open(RpProfile.sourceUrl),
      ),
      RpCommand(
        label: l10n.commandToggleTheme,
        icon: Icons.contrast,
        keywords: 'theme tema dark light escuro claro',
        run: _appCubit.toggleTheme,
      ),
      RpCommand(
        label: l10n.commandChangeLanguage,
        icon: Icons.translate,
        keywords: 'language idioma english portugues',
        run: () => _appCubit.changeLocale(nextLocale.locale),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = context.isSmallScreen;

    // The page itself spans the whole window — background, app bar, scroll
    // progress and the scrollbar all reach the edges. Only the content is
    // capped to RpTheme.contentMaxWidth, per section (HomeSectionWidget, the
    // gallery's edge padding, the app bar's inner row).
    return FlutterBannerWidget(
      child: RpAmbientBackgroundWidget(
        scrollController: _scrollController,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Scaffold(
                key: _drawerKey,
                backgroundColor: Colors.transparent,
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
                        maxContentWidth: RpTheme.contentMaxWidth,
                        // Excluded: the hero already exposes the name as
                        // the page's <h1>; AppBar would add a second
                        // heading.
                        title: ExcludeSemantics(
                          child: SelectableText(
                            'Roni Paschoal',
                            style: RpTheme.pageTitleStyle(
                              context.rpColors.textHighlightColor,
                            ),
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
                            onOpenCommandPalette: _openCommandPalette,
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
