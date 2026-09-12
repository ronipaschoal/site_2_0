import 'package:go_router/go_router.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/pages/cv/cv_screen.dart';

sealed class CvRoute {
  static const String cv = '/cv';

  static GoRoute route() {
    return GoRoute(
      path: cv,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        const CvScreen(),
      ),
    );
  }
}
