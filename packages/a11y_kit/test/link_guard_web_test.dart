// Run with: flutter test --platform chrome test/link_guard_web_test.dart
@TestOn('browser')
library;

import 'package:a11y_kit/src/web/link_guard_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart' as web;

void main() {
  setUpAll(installSemanticLinkGuard);

  bool clickPrevented(web.Element host) {
    final anchor = web.document.createElement('a')
      ..setAttribute('href', 'https://example.com');
    host.append(anchor);
    web.document.body!.append(host);
    addTearDown(() => host.remove());

    final event = web.MouseEvent(
      'click',
      web.MouseEventInit(bubbles: true, cancelable: true),
    );
    anchor.dispatchEvent(event);
    return event.defaultPrevented;
  }

  test('cancels navigation for anchors in the semantics host', () {
    expect(
      clickPrevented(web.document.createElement('flt-semantics-host')),
      isTrue,
    );
  });

  test('leaves other anchors alone', () {
    expect(clickPrevented(web.document.createElement('div')), isFalse);
  });
}
