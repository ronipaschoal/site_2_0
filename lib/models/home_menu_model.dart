import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ronip/core/hyperlink_helper.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/theme.dart';

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

  HomeMenu({
    required this.key,
    required this.section,
    required this.drawerKey,
    required this.scrollController,
  });

  /// The full, ordered list of home sections, set once by [HomeScreen] right
  /// after building it. [sectionPosition] sums the size of every menu ahead
  /// of this one in that list, rather than each [HomeMenu] carrying its own
  /// copy of "everything that came before".
  List<HomeMenu> siblingsInOrder = const [];

  double get sectionSize => key.currentContext?.size?.height ?? 0.0;

  double get sectionPosition {
    final index = siblingsInOrder.indexOf(this);
    return siblingsInOrder
        .take(index < 0 ? 0 : index)
        .fold(0.0, (sum, menu) => sum + menu.sectionSize);
  }
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
    HyperlinkHelper.open(url);
  }

  Widget iconWidget(BuildContext context, Size size) {
    return SvgPicture.asset(
      icon,
      width: size.width,
      height: size.height,
      colorFilter: ColorFilter.mode(
        context.rpColors.textColor,
        BlendMode.srcIn,
      ),
    );
  }
}
