import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/core/page_meta/page_meta.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/home_screen.dart';

sealed class HomeRoute {
  static const String home = '/';

  static GoRoute route() {
    return GoRoute(
      path: home,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        RpPageMeta(
          title: (l10n) => l10n.metaTitleHome,
          description: (l10n) => l10n.metaDescriptionHome,
          child: BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}
