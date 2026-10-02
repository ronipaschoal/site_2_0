import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Matches anchors inside Flutter's accessibility DOM.
///
/// This is engine-internal markup, not a public contract: if a Flutter
/// upgrade renames the host element, links fall back to the browser's own
/// navigation. `test/link_guard_web_test.dart` (run with
/// `flutter test --platform chrome`) pins the behavior this relies on.
const semanticLinkSelector = 'flt-semantics-host a[href]';

bool _installed = false;

/// On web, a `Semantics(linkUrl: …)` node becomes an `<a href>` in the
/// accessibility DOM, so screen readers announce a real link with its
/// destination. Activating it, though, runs the widget's `onTap` *and* the
/// browser's default anchor navigation, taking the current tab away.
///
/// This cancels only that default navigation, for anchors inside Flutter's
/// semantics tree; the click still reaches the engine, so `onTap` runs.
void installSemanticLinkGuard() {
  if (_installed) return;
  _installed = true;
  web.document.addEventListener(
    'click',
    ((web.Event event) {
      // `is` can't tell JS types apart (it's always true for interop types,
      // so a Text node target would throw on `closest`); `isA` checks the
      // real DOM type.
      final target = event.target;
      if (target == null || !target.isA<web.Element>()) return;
      final element = target as web.Element;
      if (element.closest(semanticLinkSelector) != null) {
        event.preventDefault();
      }
    }).toJS,
    true.toJS,
  );
}
