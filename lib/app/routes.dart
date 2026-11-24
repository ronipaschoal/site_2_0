import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ronip/app/locale_paths.dart';
import 'package:ronip/models/locale_model.dart';
import 'package:ronip/pages/cv/cv_route.dart';
import 'package:ronip/pages/home/home_route.dart';

sealed class RpRoutes {
  static const String home = HomeRoute.home;
  static const String cv = CvRoute.cv;

  /// Each page exists once per language (`/` and `/en`, `/cv` and
  /// `/en/cv`); see [RpLocalePaths]. The URL decides the app's locale.
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      for (final language in RpLocalePaths.languages) ...[
        HomeRoute.route(RpLocalePaths.localize(home, language)),
        CvRoute.route(RpLocalePaths.localize(cv, language)),
      ],
    ],
  );

  /// The locale a URL [path] is served in.
  static Locale localeFor(String path) =>
      RpLocalePaths.languageOf(path) == RpLocalePaths.english
          ? LocaleEnum.en.locale
          : LocaleEnum.pt.locale;

  /// [basePath] (e.g. [home], [cv]) in the language currently shown.
  static String localized(BuildContext context, String basePath) =>
      RpLocalePaths.localize(
        basePath,
        Localizations.localeOf(context).languageCode,
      );

  /// Switches language by going to the current page's URL in [locale]
  /// (`/cv` ↔ `/en/cv`), keeping its query string. The router listener set
  /// up in `main()` then updates the app's locale.
  static void switchLanguage(BuildContext context, Locale locale) {
    final router = GoRouter.of(context);
    final uri = router.routerDelegate.currentConfiguration.uri;
    final path = RpLocalePaths.switchLanguage(uri.path, locale.languageCode);
    router.go(uri.replace(path: path).toString());
  }
}
