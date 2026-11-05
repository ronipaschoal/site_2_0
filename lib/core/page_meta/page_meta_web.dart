import 'package:web/web.dart' as web;

/// Updates the description meta tag, plus the Open Graph / Twitter title and
/// description, so a crawler that renders the page sees tags matching the
/// current route. Only tags already present in `web/index.html` are touched.
void setPageDescription(String description, {required String title}) {
  _setContent('meta[name="description"]', description);
  _setContent('meta[property="og:title"]', title);
  _setContent('meta[property="og:description"]', description);
  _setContent('meta[name="twitter:title"]', title);
  _setContent('meta[name="twitter:description"]', description);
}

void _setContent(String selector, String content) {
  final element = web.document.querySelector(selector);
  if (element == null || element.getAttribute('content') == content) return;
  element.setAttribute('content', content);
}
