import 'package:web/web.dart' as web;

/// Updates the description meta tag, the Open Graph / Twitter title and
/// description, the canonical link and `og:url`, so a crawler that renders
/// the page sees tags matching the current route. Only tags already present
/// in `web/index.html` are touched.
void setPageDescription(
  String description, {
  required String title,
  required String url,
}) {
  _setContent('meta[name="description"]', description);
  _setContent('meta[property="og:title"]', title);
  _setContent('meta[property="og:description"]', description);
  _setContent('meta[name="twitter:title"]', title);
  _setContent('meta[name="twitter:description"]', description);
  _setContent('meta[property="og:url"]', url);
  _setAttribute('link[rel="canonical"]', 'href', url);
}

void _setContent(String selector, String content) =>
    _setAttribute(selector, 'content', content);

void _setAttribute(String selector, String name, String value) {
  final element = web.document.querySelector(selector);
  if (element == null || element.getAttribute(name) == value) return;
  element.setAttribute(name, value);
}
