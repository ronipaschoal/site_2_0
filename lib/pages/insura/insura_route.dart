import 'package:go_router/go_router.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/pages/insura/insura_screen.dart';

sealed class InsuraRoute {
  static const String insura = '/insura';

  static GoRoute route() {
    return GoRoute(
      path: insura,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        const InsuraScreen(),
      ),
    );
  }
}
