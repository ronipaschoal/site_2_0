import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ronip/config/routes.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/ui/theme.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AppCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => previous.locale != current.locale,
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Roni Paschoal',
          locale: state.locale,
          debugShowCheckedModeBanner: false,
          routerConfig: RpRoutes.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          theme: RpTheme.theme,
        );
      },
    );
  }
}
