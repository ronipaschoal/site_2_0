import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/app/routes_helper.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/home_screen.dart';

sealed class HomeRoute {
  static const String home = '/';

  static GoRoute route() {
    return GoRoute(
      path: home,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        BlocProvider(
          create: (context) => HomeCubit(),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
