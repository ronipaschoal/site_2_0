import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/seo_content.dart' show buildCvPage;

void main() {
  final index = File('web/index.html').readAsStringSync();
  final canonical = RegExp('<link\\s+rel="canonical"\\s+href="([^"]*)"');

  test('index.html declares the home page as its only canonical URL', () {
    final matches = canonical.allMatches(index).toList();
    expect(matches, hasLength(1));
    expect(matches.single[1], 'https://ronipaschoal.com.br/');
  });

  test('cv.html swaps the canonical URL and og:url to /cv', () {
    final cv = buildCvPage(index);
    final matches = canonical.allMatches(cv).toList();
    expect(matches, hasLength(1));
    expect(matches.single[1], 'https://ronipaschoal.com.br/cv');
    expect(
      cv,
      contains('og:url" content="https://ronipaschoal.com.br/cv"'),
    );
  });

  test('cv.html fails loudly if the canonical tag is gone', () {
    final withoutCanonical = index.replaceFirst(canonical, '');
    expect(() => buildCvPage(withoutCanonical), throwsStateError);
  });
}
