import 'package:web/web.dart' as web;

/// Updates the description meta tag, the Open Graph / Twitter title and
/// description, the canonical link, `og:url`, `og:locale` and the hreflang
/// alternates ([alternates] maps each hreflang value to its URL), so a
/// crawler that renders the page sees tags matching the current route. Only
/// tags already present in the page (see tool/seo_content.dart) are touched.
void setPageDescription(
  String description, {
  required String title,
  required String url,
  required String ogLocale,
  required Map<String, String> alternates,
}) {
  _setContent('meta[name="description"]', description);
  _setContent('meta[property="og:title"]', title);
  _setContent('meta[property="og:description"]', description);
  _setContent('meta[name="twitter:title"]', title);
  _setContent('meta[name="twitter:description"]', description);
  _setContent('meta[property="og:url"]', url);
  _setContent('meta[property="og:locale"]', ogLocale);
  _setAttribute('link[rel="canonical"]', 'href', url);
  for (final MapEntry(key: hreflang, value: href) in alternates.entries) {
    _setAttribute('link[rel="alternate"][hreflang="$hreflang"]', 'href', href);
  }
}

void _setContent(String selector, String content) =>
    _setAttribute(selector, 'content', content);

void _setAttribute(String selector, String name, String value) {
  final element = web.document.querySelector(selector);
  if (element == null || element.getAttribute(name) == value) return;
  element.setAttribute(name, value);
}
