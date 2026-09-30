import 'package:go_router/go_router.dart';

import 'analytics_stub.dart' if (dart.library.js_interop) 'analytics_web.dart';

/// Google Analytics 4 for the web build.
///
/// Only active when the measurement ID is passed at build time
/// (`--dart-define=GA_MEASUREMENT_ID=G-XXXXXXXXXX`), so local runs and the
/// mobile apps never report anything.
sealed class RpAnalytics {
  static const _measurementId = String.fromEnvironment('GA_MEASUREMENT_ID');

  static bool get _enabled => _measurementId.isNotEmpty;

  static String? _lastPath;

  /// Loads gtag.js and reports a page view for every route [router] settles
  /// on, including the first one.
  static void init(GoRouter router) {
    if (!_enabled) return;
    loadGtag(_measurementId);

    void reportRoute() =>
        _pageView(router.routerDelegate.currentConfiguration.uri.path);
    router.routerDelegate.addListener(reportRoute);
    reportRoute();
  }

  /// A résumé PDF download, with the chosen [layout] and [language].
  static void cvDownload({required String layout, required String language}) {
    _event('cv_download', {'layout': layout, 'language': language});
  }

  static void _pageView(String path) {
    if (path.isEmpty || path == _lastPath) return;
    _lastPath = path;
    // Reported as a regular path (`/cv`) rather than the hash URL (`/#/cv`),
    // so GA's page reports tell the routes apart.
    _event('page_view', {
      'page_location': '${Uri.base.origin}$path',
    });
  }

  static void _event(String name, Map<String, Object> params) {
    if (!_enabled) return;
    sendGtagEvent(name, params);
  }
}
