import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/seo_content.dart';

void main() {
  final template = File('web/index.html').readAsStringSync();
  final strings = {
    for (final l in ['pt', 'en']) l: readArb(l),
  };
  final canonical = RegExp('<link\\s+rel="canonical"\\s+href="([^"]*)"');

  String build(String basePath, String language) => buildPage(
        template,
        SeoPage(basePath, language),
        strings[language]!,
      );

  String? alternate(String html, String hreflang) => RegExp(
        '<link\\s+rel="alternate"\\s+hreflang="$hreflang"\\s+href="([^"]*)"',
      ).firstMatch(html)?[1];

  test('index.html declares the home page as its only canonical URL', () {
    final matches = canonical.allMatches(template).toList();
    expect(matches, hasLength(1));
    expect(matches.single[1], 'https://ronipaschoal.com.br/');
  });

  test('builds one file per route and language', () {
    expect(
      {for (final page in seoPages) page.path: page.fileName},
      {
        '/': 'index.html',
        '/cv': 'cv.html',
        '/en': 'en.html',
        '/en/cv': 'en-cv.html',
      },
    );
  });

  for (final (basePath, language, url, pt, en) in [
    ('/', 'pt', '/', '/', '/en'),
    ('/cv', 'pt', '/cv', '/cv', '/en/cv'),
    ('/', 'en', '/en', '/', '/en'),
    ('/cv', 'en', '/en/cv', '/cv', '/en/cv'),
  ]) {
    test('$url: self canonical, og:url and hreflang alternates', () {
      final html = build(basePath, language);
      const origin = 'https://ronipaschoal.com.br';
      final matches = canonical.allMatches(html).toList();
      expect(matches, hasLength(1));
      expect(matches.single[1], '$origin$url');
      expect(html, contains('og:url" content="$origin$url"'));
      expect(alternate(html, 'pt-BR'), '$origin$pt');
      expect(alternate(html, 'en'), '$origin$en');
      expect(alternate(html, 'x-default'), '$origin$pt');
      expect(html, isNot(contains('<!-- seo-')));
    });
  }

  test('/en is in English throughout', () {
    final html = build('/', 'en');
    expect(html, contains('<html lang="en">'));
    expect(html, contains('<title>${strings['en']!['metaTitleHome']}</title>'));
    expect(html, contains('og:locale" content="en_US"'));
    expect(html, contains('og:locale:alternate" content="pt_BR"'));
    expect(
      html,
      contains('<h1>Roni Paschoal — Senior Flutter Mobile Developer</h1>'),
    );
    expect(html, contains('"jobTitle": [\n    "Senior Flutter Mobile'));
    expect(html, contains('<h2>Professional Experience</h2>'));
    expect(html, isNot(contains('Experiência Profissional')));
  });

  test('the Portuguese home keeps its Portuguese metadata', () {
    final html = build('/', 'pt');
    expect(html, contains('<html lang="pt-BR">'));
    expect(
      html,
      contains('<h1>Roni Paschoal — Desenvolvedor Mobile Flutter Sênior</h1>'),
    );
    expect(html, contains('og:locale" content="pt_BR"'));
    expect(html, contains('<a href="/en" hreflang="en" lang="en">English'));
  });

  test('fails loudly if a tag it rewrites is gone', () {
    final withoutCanonical = template.replaceFirst(canonical, '');
    expect(() => build('/cv', 'pt'), returnsNormally);
    expect(
      () => buildPage(
        withoutCanonical,
        const SeoPage('/cv', 'pt'),
        strings['pt']!,
      ),
      throwsStateError,
    );
  });
}
