import 'package:go_router/go_router.dart';
import 'package:ronip/pages/cv/cv_route.dart';
import 'package:ronip/pages/home/home_route.dart';
import 'package:ronip/pages/insura/insura_route.dart';

sealed class RpRoutes {
  static const String home = HomeRoute.home;
  static const String cv = CvRoute.cv;
  static const String insura = InsuraRoute.insura;

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      HomeRoute.route(),
      CvRoute.route(),
      InsuraRoute.route(),
    ],
  );
}
