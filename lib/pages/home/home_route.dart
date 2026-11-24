import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/core/page_meta/page_meta.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/home_screen.dart';

sealed class HomeRoute {
  static const String home = '/';

  /// The home page at [path]: [home] or its English version (`/en`).
  static GoRoute route(String path) {
    return GoRoute(
      path: path,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        key: const ValueKey(home),
        RpPageMeta(
          path: path,
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
