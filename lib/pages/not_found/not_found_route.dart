import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/app/locale_paths.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/core/page_meta/page_meta.dart';
import 'package:ronip/pages/not_found/not_found_screen.dart';

sealed class NotFoundRoute {
  /// The router's error page: any path it doesn't know (`/foo`, `/en/foo`)
  /// gets the "page not found" screen in that path's language, instead of
  /// go_router's exception screen.
  static Page<void> page(GoRouterState state) {
    final path = state.uri.path;
    final homePath = RpLocalePaths.localize(
      '/',
      RpLocalePaths.languageOf(path),
    );

    return RoutesHelper.transitionPage(
      key: const ValueKey('not-found'),
      RpPageMeta(
        // The home page's URL, so canonical/og:url never point at a path
        // that doesn't exist (the server answers it with a 404 anyway).
        path: homePath,
        title: (l10n) => l10n.notFoundMetaTitle,
        description: (l10n) => l10n.metaDescriptionHome,
        child: NotFoundScreen(path: path, homePath: homePath),
      ),
    );
  }
}
