import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('gtag')
external void _gtag(JSString command, JSString target, [JSAny? params]);

/// Injects the standard gtag.js snippet. `gtag` has to be a real JS function
/// pushing its `arguments` object — gtag.js ignores plain arrays — so it is
/// declared in an inline script rather than from Dart.
void loadGtag(String measurementId) {
  final head = web.document.head!;
  head.append(
    web.HTMLScriptElement()
      ..text = 'window.dataLayer = window.dataLayer || [];'
          'function gtag(){dataLayer.push(arguments);}'
          "gtag('js', new Date());"
          // Page views are sent by hand on each route change (see
          // RpAnalytics.init) rather than left to gtag's history tracking.
          "gtag('config', '$measurementId', {send_page_view: false});",
  );
  head.append(
    web.HTMLScriptElement()
      ..async = true
      ..src = 'https://www.googletagmanager.com/gtag/js?id=$measurementId',
  );
}

void sendGtagEvent(String name, Map<String, Object> params) {
  _gtag('event'.toJS, name.toJS, params.jsify());
}
