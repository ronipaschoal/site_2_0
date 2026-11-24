// Turns a built index.html into the site's four static entry pages, one per
// route and language, for crawlers and link previews that don't run Flutter:
//
//   index.html   → /        (Portuguese home)
//   cv.html      → /cv      (Portuguese résumé)
//   en.html      → /en      (English home)
//   en-cv.html   → /en/cv   (English résumé)
//
// web/.htaccess serves each one at its route. They're all the same Flutter
// app; what changes is the `lang`, title, descriptions, canonical URL,
// hreflang alternates, Open Graph / Twitter tags, the Person JSON-LD and the
// visually hidden `<!-- seo-content -->` copy of the résumé. Link previews
// (LinkedIn, WhatsApp…) don't run JavaScript, so this is the only way a
// shared `/cv` or `/en` link gets its own preview.
//
// Nothing here is typed twice: the résumé comes from cv_data.dart, the
// titles, descriptions, h1 and section headings from the ARB files the app
// itself reads (lib/l10n/app_<language>.arb), and the URLs from
// RpLocalePaths, which the router also uses. Only the copy that exists
// nowhere in the UI (share descriptions, image alt, JSON-LD) lives below.
//
// Usage, from the repository root (after `flutter build web`):
//   dart run tool/seo_content.dart build/web/index.html
import 'dart:convert';
import 'dart:io';

import 'package:ronip/app/locale_paths.dart';
import 'package:ronip/core/profile.dart';
import 'package:ronip/models/localized_map.dart';
import 'package:ronip/pages/cv/cv_data.dart';

const _contentSlot = '<!-- seo-content -->';
const _jsonLdSlot = '<!-- seo-json-ld -->';
const origin = 'https://ronipaschoal.com.br';

/// One static entry page: a route ([basePath], as in Portuguese) in a
/// [language].
class SeoPage {
  const SeoPage(this.basePath, this.language);

  final String basePath;
  final String language;

  bool get isCv => basePath == '/cv';

  /// The route this page is served at (`/en/cv`).
  String get path => RpLocalePaths.localize(basePath, language);

  String get url => '$origin$path';

  /// The built file, next to index.html (`en-cv.html`). Flat files rather
  /// than an `en/` folder, which Apache would redirect to `/en/`.
  String get fileName => path == '/'
      ? 'index.html'
      : '${path.substring(1).replaceAll('/', '-')}.html';

  /// hreflang value → URL of this page in every language, plus x-default.
  Map<String, String> get alternates {
    String urlIn(String language) =>
        '$origin${RpLocalePaths.localize(basePath, language)}';
    return {
      for (final language in RpLocalePaths.languages)
        RpLocalePaths.hreflang[language]!: urlIn(language),
      'x-default': urlIn(RpLocalePaths.defaultLanguage),
    };
  }
}

/// Every entry page, in sitemap order.
final seoPages = [
  for (final language in RpLocalePaths.languages) ...[
    SeoPage('/', language),
    SeoPage('/cv', language),
  ],
];

/// Copy that only the static pages use, so it has no ARB entry.
class _SeoCopy {
  const _SeoCopy({
    required this.htmlLang,
    required this.ogLocale,
    required this.homeShareDescription,
    required this.cvShareDescription,
    required this.imageAlt,
    required this.jobTitle,
    required this.personDescription,
    required this.knowsAbout,
    required this.languageName,
  });

  final String htmlLang;
  final String ogLocale;

  /// Link previews already show the title, so these don't repeat it.
  final String homeShareDescription;
  final String cvShareDescription;
  final String imageAlt;
  final List<String> jobTitle;
  final String personDescription;
  final List<String> knowsAbout;

  /// The language's own name, for the link to it from the other language.
  final String languageName;
}

const _years = RpProfile.yearsOfExperience;
const _yearsHybrid = RpProfile.yearsHybridMobile;

const _copy = {
  RpLocalePaths.portuguese: _SeoCopy(
    htmlLang: 'pt-BR',
    ogLocale: 'pt_BR',
    homeShareDescription: 'Desenvolvedor Flutter sênior: apps Android, iOS '
        'e SmartPOS com Dart, BLoC/Cubit, Offline First e CI/CD.',
    cvShareDescription: 'Experiência, competências e projetos em Flutter, '
        'Android, iOS e SmartPOS. Download do currículo em PDF.',
    imageAlt: 'Logotipo de Roni Paschoal ao lado do nome, do cargo '
        'Desenvolvedor de Software Mobile Flutter e de Flutter, Dart, '
        'Android e iOS',
    jobTitle: [
      'Desenvolvedor Mobile Flutter Sênior',
      'Senior Flutter Developer',
    ],
    personDescription: 'Desenvolvedor mobile Flutter sênior, com $_years '
        'anos em software e $_yearsHybrid em mobile híbrido: apps Android, '
        'iOS e SmartPOS.',
    knowsAbout: [
      'Flutter', 'Dart', 'Desenvolvimento mobile multiplataforma', //
      'Desenvolvimento mobile híbrido', 'Android', 'iOS', 'React Native',
      'BLoC/Cubit', 'Clean Architecture', 'MVVM', 'Offline First',
      'Testes automatizados', 'CI/CD', 'Publicação na App Store e Google Play',
      'Firebase', 'SmartPOS', 'Integração com meios de pagamento',
      'APIs REST', 'React', 'TypeScript', 'Node.js', 'Go',
    ],
    languageName: 'Português',
  ),
  RpLocalePaths.english: _SeoCopy(
    htmlLang: 'en',
    ogLocale: 'en_US',
    homeShareDescription: 'Senior Flutter developer: Android, iOS and '
        'SmartPOS apps with Dart, BLoC/Cubit, Offline First and CI/CD.',
    cvShareDescription: 'Experience, skills and projects in Flutter, '
        'Android, iOS and SmartPOS. Résumé PDF download.',
    imageAlt: 'Roni Paschoal logo next to the name, the title Flutter Mobile '
        'Software Developer, and Flutter, Dart, Android and iOS',
    jobTitle: ['Senior Flutter Mobile Developer', 'Senior Flutter Developer'],
    personDescription: 'Senior Flutter mobile developer with $_years years '
        'in software and $_yearsHybrid in hybrid mobile: Android, iOS and '
        'SmartPOS apps.',
    knowsAbout: [
      'Flutter', 'Dart', 'Cross-platform mobile development', //
      'Hybrid mobile development', 'Android', 'iOS', 'React Native',
      'BLoC/Cubit', 'Clean Architecture', 'MVVM', 'Offline First',
      'Automated testing', 'CI/CD', 'App Store and Google Play publishing',
      'Firebase', 'SmartPOS', 'Payment integration', 'REST APIs', 'React',
      'TypeScript', 'Node.js', 'Go',
    ],
    languageName: 'English',
  ),
};

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/seo_content.dart <index.html>');
    exit(64);
  }

  final file = File(args.single);
  final template = file.readAsStringSync();
  final strings = {
    for (final language in RpLocalePaths.languages) language: readArb(language),
  };

  // Every page is built from the untouched template before any is written,
  // so index.html can be overwritten in place.
  final Map<SeoPage, String> pages;
  try {
    pages = {
      for (final page in seoPages)
        page: buildPage(template, page, strings[page.language]!),
    };
  } on StateError catch (error) {
    stderr.writeln('${error.message} (in ${file.path})');
    exit(1);
  }

  for (final MapEntry(key: page, value: html) in pages.entries) {
    final out = File.fromUri(file.uri.resolve(page.fileName));
    out.writeAsStringSync(html);
    stdout.writeln('${page.path} written to ${out.path}.');
  }
}

/// The app's UI strings for [language], straight from its ARB file (the
/// generated AppLocalizations need Flutter, which this plain Dart tool
/// can't load). Paths are relative to the repository root.
Map<String, String> readArb(String language) {
  final json = jsonDecode(
    File('lib/l10n/app_$language.arb').readAsStringSync(),
  ) as Map<String, dynamic>;
  return {
    for (final MapEntry(:key, :value) in json.entries)
      if (!key.startsWith('@') && value is String) key: value,
  };
}

/// [template] (web/index.html as built) turned into [page], with [strings]
/// from that language's ARB file. Throws a [StateError] if a tag or slot it
/// rewrites is missing, so an edit to web/index.html can't silently ship
/// the wrong page's metadata.
String buildPage(String template, SeoPage page, Map<String, String> strings) {
  const attr = HtmlEscape(HtmlEscapeMode.attribute);
  const e = HtmlEscape(HtmlEscapeMode.element);
  final copy = _copy[page.language]!;
  String arb(String key) =>
      strings[key] ?? (throw StateError('No "$key" in the ARB file.'));

  final title = arb(page.isCv ? 'metaTitleCv' : 'metaTitleHome');
  final description =
      arb(page.isCv ? 'metaDescriptionCv' : 'metaDescriptionHome');
  final shareDescription =
      page.isCv ? copy.cvShareDescription : copy.homeShareDescription;
  final otherLocales = [
    for (final language in RpLocalePaths.languages)
      if (language != page.language) _copy[language]!.ogLocale,
  ];

  var html = template;

  void replace(RegExp pattern, String value, String what) {
    if (!pattern.hasMatch(html)) throw StateError('No $what tag found.');
    html = html.replaceFirstMapped(
      pattern,
      (match) => '${match[1]}$value${match[2]}',
    );
  }

  void fill(String slot, String content) {
    if (!html.contains(slot)) throw StateError('No "$slot" slot found.');
    html = html.replaceFirst(slot, content);
  }

  RegExp meta(String key, String name) =>
      RegExp('(<meta\\s+$key="${RegExp.escape(name)}"\\s+content=")[^"]*(")');

  replace(RegExp('(<html\\s+lang=")[^"]*(")'), copy.htmlLang, '<html lang>');
  replace(RegExp('(<title>)[^<]*(</title>)'), e.convert(title), '<title>');
  replace(
    RegExp('(<link\\s+rel="canonical"\\s+href=")[^"]*(")'),
    attr.convert(page.url),
    'canonical',
  );
  for (final MapEntry(key: hreflang, value: url) in page.alternates.entries) {
    replace(
      RegExp('(<link\\s+rel="alternate"\\s+hreflang="'
          '${RegExp.escape(hreflang)}"\\s+href=")[^"]*(")'),
      attr.convert(url),
      'hreflang="$hreflang"',
    );
  }
  for (final (key, name, value) in [
    ('name', 'description', description),
    ('property', 'og:locale', copy.ogLocale),
    ('property', 'og:locale:alternate', otherLocales.single),
    ('property', 'og:url', page.url),
    ('property', 'og:title', title),
    ('property', 'og:description', shareDescription),
    ('property', 'og:image:alt', copy.imageAlt),
    ('name', 'twitter:title', title),
    ('name', 'twitter:description', shareDescription),
  ]) {
    replace(meta(key, name), attr.convert(value), name);
  }

  fill(_jsonLdSlot, buildJsonLd(page.language));
  fill(_contentSlot, buildSeoContent(page.language, strings));
  return html;
}

/// The schema.org Person, in [language]. The `@id` is the same in both
/// languages, so search engines treat them as one person.
String buildJsonLd(String language) {
  final copy = _copy[language]!;
  final person = {
    '@context': 'https://schema.org',
    '@type': 'Person',
    '@id': '$origin/#person',
    'name': 'Roni Paschoal',
    'jobTitle': copy.jobTitle,
    'description': copy.personDescription,
    'url': '$origin${RpLocalePaths.localize('/', language)}',
    'image': '$origin/og-image.png',
    'email': 'mailto:$contactEmail',
    'address': {
      '@type': 'PostalAddress',
      'addressLocality': 'Santo André',
      'addressRegion': 'SP',
      'addressCountry': 'BR',
    },
    'alumniOf': [
      {
        '@type': 'CollegeOrUniversity',
        'name': 'Universidade de São Paulo (USP)',
      },
      {
        '@type': 'CollegeOrUniversity',
        'name': 'Instituto Federal de São Paulo (IFSP)',
      },
    ],
    'knowsAbout': copy.knowsAbout,
    'knowsLanguage': [
      for (final language in RpLocalePaths.languages)
        RpLocalePaths.hreflang[language],
    ],
    'sameAs': [
      'https://www.linkedin.com/in/roni-paschoal/',
      'https://github.com/ronipaschoal',
    ],
  };
  // `</` can't appear inside a <script>; JSON allows escaping the slash.
  final json = const JsonEncoder.withIndent('  ')
      .convert(person)
      .replaceAll('</', '<\\/');
  return '<script type="application/ld+json">\n$json\n</script>';
}

/// The résumé as plain HTML in [language], for the hidden
/// `<main id="seo-content">`. Headings come from that language's ARB
/// [strings], so they match what the app shows.
String buildSeoContent(String language, Map<String, String> strings) {
  const e = HtmlEscape(HtmlEscapeMode.element);
  const attr = HtmlEscape(HtmlEscapeMode.attribute);
  String arb(String key) => e.convert(
        strings[key] ?? (throw StateError('No "$key" in the ARB file.')),
      );
  String href(String basePath) =>
      attr.convert(RpLocalePaths.localize(basePath, language));

  final out = StringBuffer()
    // The same <h1> the app exposes (A11yHeading in the hero): the name
    // alone carries none of the terms people search for.
    ..writeln('<h1>${arb('heroHeading')}</h1>')
    ..writeln('<p>Santo André, SP</p>')
    ..writeln('<nav>')
    ..writeln('<a href="${href('/')}">${arb('home')}</a>')
    ..writeln('<a href="${href('/cv')}">${arb('cvHeading')}</a>');
  for (final other in RpLocalePaths.languages) {
    if (other == language) continue;
    final hreflang = RpLocalePaths.hreflang[other]!;
    out.writeln('<a href="${attr.convert(RpLocalePaths.localize('/', other))}" '
        'hreflang="$hreflang" lang="$hreflang">'
        '${e.convert(_copy[other]!.languageName)}</a>');
  }
  out
    ..writeln('</nav>')
    ..writeln('<section><h2>${arb('cvSummary')}</h2>')
    ..writeln('<p>${e.convert(cvSummaryFor(language))}</p></section>')
    ..writeln('<section><h2>${arb('cvObjective')}</h2>')
    ..writeln('<p>${e.convert(cvObjectiveFor(language))}</p></section>');

  out.writeln('<section><h2>${arb('cvEducation')}</h2><ul>');
  for (final item in cvEducationList) {
    out.writeln('<li>${e.convert(item.course)} — '
        '${e.convert(item.institution)} (${e.convert(item.period)})</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>${arb('cvExperience')}</h2>');
  for (final item in cvExperienceList) {
    out.writeln('<article><h3>${e.convert(item.role.resolve(language))} — '
        '${e.convert(item.company)}</h3>');
    out.writeln('<p>${e.convert(item.period)}</p>');
    out.writeln('<p>${e.convert(item.description.resolve(language))}</p>'
        '</article>');
  }
  out.writeln('</section>');

  out.writeln('<section><h2>${arb('cvProjects')}</h2>');
  for (final item in cvProjectList) {
    out.writeln('<article><h3><a href="${attr.convert(item.url)}">'
        '${e.convert(item.title)}</a></h3>');
    out.writeln('<p>${e.convert(item.descriptionFor(language))}</p>');
    out.writeln('<p>${e.convert(item.tech.join(', '))}</p></article>');
  }
  out.writeln('</section>');

  out.writeln('<section><h2>${arb('cvSkills')}</h2><ul>');
  for (final key in cvSkillGroupOrder) {
    out.writeln('<li>${e.convert(cvSkillGroups[key]!.join(', '))}</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>${arb('cvSkillsLanguages')}</h2><ul>');
  for (final item in cvLanguageList) {
    final usage = item.usage?.resolve(language);
    out.writeln('<li>${e.convert(item.languageFor(language))}: '
        '${e.convert(item.level.resolve(language))}'
        '${usage == null ? '' : ' (${e.convert(usage)})'}</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>${arb('cvCertifications')}</h2><ul>');
  for (final item in cvCertificationList) {
    out.writeln('<li>${e.convert(item.title)} — ${e.convert(item.issuer)} '
        '(${e.convert(item.date)})</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>${arb('contact')}</h2><ul>');
  for (final item in cvContactList) {
    out.writeln('<li><a href="${attr.convert(item.url)}">'
        '${e.convert(item.text)}</a></li>');
  }
  out.writeln('</ul></section>');

  return out.toString();
}
