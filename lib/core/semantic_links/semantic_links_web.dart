import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// On web, a `Semantics(linkUrl: …)` node becomes an `<a href>` in the
/// accessibility DOM — so screen readers announce a real link with its
/// destination. Activating it, though, runs the widget's `onTap` (which
/// opens the page in a new tab via `url_launcher`) *and* the browser's
/// default anchor navigation, taking the current tab away from the site.
///
/// This cancels only that default navigation, for anchors inside Flutter's
/// semantics tree; the click still reaches the engine, so `onTap` runs.
void guardSemanticLinks() {
  web.document.addEventListener(
    'click',
    ((web.Event event) {
      final target = event.target;
      if (target is! web.Element) return;
      final anchor = target.closest('flt-semantics-host a[href]');
      if (anchor != null) event.preventDefault();
    }).toJS,
    true.toJS,
  );
}
