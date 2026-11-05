import 'package:go_router/go_router.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/core/page_meta/page_meta.dart';
import 'package:ronip/pages/cv/cv_screen.dart';

sealed class CvRoute {
  static const String cv = '/cv';

  static GoRoute route() {
    return GoRoute(
      path: cv,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        RpPageMeta(
          title: (l10n) => l10n.metaTitleCv,
          description: (l10n) => l10n.metaDescriptionCv,
          child: const CvScreen(),
        ),
      ),
    );
  }
}
