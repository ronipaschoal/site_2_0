import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  double get sectionSize => key.currentContext?.size?.height ?? 0.0;

  /// The scroll offset at which this section's top reaches the top of the
  /// viewport, read from the actual layout — so anything placed between
  /// sections (e.g. a quote band) is accounted for, instead of assuming the
  /// sections are stacked back to back.
  double get sectionPosition {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null) return 0.0;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    return viewport?.getOffsetToReveal(renderObject, 0.0).offset ?? 0.0;
  }

  /// Closes the drawer (if open) and scrolls this section into view — shared
  /// by the nav buttons and the command palette.
  void goTo() {
    drawerKey.currentState?.closeDrawer();
    scrollController.animateTo(
      sectionPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
