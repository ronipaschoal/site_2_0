import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronip/l10n/app_localizations.dart';

import 'page_meta_stub.dart' if (dart.library.js_interop) 'page_meta_web.dart';

/// Per-route `<title>`, description and canonical URL, in the current locale.
///
/// `web/index.html` ships the home page's metadata, and every route is
/// served by that same file, so without this `/cv` would keep the home
/// page's title and description after Googlebot renders it.
///
/// The title goes through the same call as Flutter's [Title] widget, which
/// writes `document.title` on the web (and the task switcher label on
/// Android). The description, its Open Graph / Twitter copies, the
/// canonical link and `og:url` are updated in the DOM with `package:web`;
/// a no-op on Android and iOS.
///
/// Link previews (WhatsApp, LinkedIn, Facebook…) don't run JavaScript, so
/// they always show the static tags from `web/index.html`; this only reaches
/// crawlers that render the page, and the browser tab.
class RpPageMeta extends StatelessWidget {
  const RpPageMeta({
    super.key,
    required this.path,
    required this.title,
    required this.description,
    required this.child,
  });

  /// The site's single canonical origin, as in `web/index.html`.
  static const String origin = 'https://ronipaschoal.com.br';

  /// The route's path (e.g. `/cv`), without query string, so `/cv?focus=…`
  /// and www/http copies all name the same canonical URL.
  final String path;
  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Every dependency below also rebuilds this right after `MaterialApp`
    // rewrites its own title (theme or locale change), so the page's wins.
    // A page left underneath another one (e.g. home under a pushed `/cv`)
    // stays mounted, so only the top route writes; reading the route also
    // rebuilds this once it's back on top.
    final isCurrent = ModalRoute.isCurrentOf(context) ?? true;
    final l10n = AppLocalizations.of(context)!;
    // The browser's `theme-color` comes from this too, so it follows the
    // page background rather than the brand color.
    final background = Theme.of(context).scaffoldBackgroundColor;

    if (isCurrent) {
      final pageTitle = title(l10n);
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: pageTitle,
          primaryColor: background.withAlpha(0xFF).toARGB32(),
        ),
      );
      setPageDescription(
        description(l10n),
        title: pageTitle,
        url: '$origin$path',
      );
    }

    return child;
  }
}
