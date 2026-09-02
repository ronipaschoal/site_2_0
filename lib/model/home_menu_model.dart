import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/helpers/hyperlink_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/ui/theme.dart';

extension SectionExtensions on HomeSectionEnum {
  String title(BuildContext context) {
    switch (this) {
      case HomeSectionEnum.home:
        return '';
      case HomeSectionEnum.about:
        return AppLocalizations.of(context)!.aboutMe;
      case HomeSectionEnum.programs:
        return AppLocalizations.of(context)!.myPrograms;
      case HomeSectionEnum.contact:
        return AppLocalizations.of(context)!.getInTouch;
    }
  }
}

enum HomeSectionEnum {
  home,
  about,
  programs,
  contact,
}

extension PageTypeExtensions on HomeMenu {
  String translate(BuildContext context) {
    switch (section) {
      case HomeSectionEnum.home:
        return AppLocalizations.of(context)!.home;
      case HomeSectionEnum.about:
        return AppLocalizations.of(context)!.about;
      case HomeSectionEnum.programs:
        return AppLocalizations.of(context)!.programs;
      case HomeSectionEnum.contact:
        return AppLocalizations.of(context)!.contact;
    }
  }
}

class HomeMenu {
  final GlobalKey key;
  final HomeSectionEnum section;
  final GlobalKey<ScaffoldState> drawerKey;
  final ScrollController scrollController;
  final List<HomeMenu> previousMenuList;

  HomeMenu({
    required this.key,
    required this.section,
    required this.drawerKey,
    required this.scrollController,
    this.previousMenuList = const [],
  });

  double get sectionSize => key.currentContext?.size?.height ?? 0.0;

  double get sectionPosition => previousMenuList.fold(
        0.0,
        (previous, element) => previous + element.sectionSize,
      );
}

class ExternalMenu {
  final String text;
  final String icon;
  final String url;

  ExternalMenu({
    required this.text,
    required this.icon,
    required this.url,
  });

  void goToExternal() {
    HyperlinkHelper.targetBlank(url);
  }

  Widget iconWidget(Size size) {
    return SvgPicture.asset(
      icon,
      width: size.width,
      height: size.height,
      colorFilter: const ColorFilter.mode(
        RpTheme.textColor,
        BlendMode.srcIn,
      ),
    );
  }
}
