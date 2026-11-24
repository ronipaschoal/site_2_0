import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/core/page_meta/page_meta.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/cv/cv_screen.dart';

sealed class CvRoute {
  static const String cv = '/cv';

  /// The résumé page at [path]: [cv] or its English version (`/en/cv`).
  static GoRoute route(String path) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => RoutesHelper.transitionPage(
        key: const ValueKey(cv),
        RpPageMeta(
          path: path,
          title: (l10n) => l10n.metaTitleCv,
          description: (l10n) => l10n.metaDescriptionCv,
          child: CvScreen(
            focus: cvFocusFrom(state.uri.queryParameters['focus']),
          ),
        ),
      ),
    );
  }
}
