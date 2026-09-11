import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/helpers/routes_helper.dart';
import 'package:ronip/pages/cv/cv_screen.dart';

sealed class CvRoute {
  static const String cv = '/cv';

  static GoRoute route() {
    return GoRoute(
      path: cv,
      pageBuilder: (context, __) => RoutesHelper.transitionPage(
        CvScreen(
          appCubit: context.read<AppCubit>(),
        ),
      ),
    );
  }
}
