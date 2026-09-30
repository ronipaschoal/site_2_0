// Fills the `<!-- seo-content -->` slot of a built index.html with the
// résumé as plain HTML, for crawlers and link previews that don't run
// Flutter. Content comes from cv_data.dart, so it never drifts from the app.
//
// Usage (after `flutter build web`):
//   dart run tool/seo_content.dart build/web/index.html
import 'dart:convert';
import 'dart:io';

import 'package:ronip/models/localized_map.dart';
import 'package:ronip/pages/cv/cv_data.dart';

const _slot = '<!-- seo-content -->';
const _language = 'pt';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/seo_content.dart <index.html>');
    exit(64);
  }

  final file = File(args.single);
  final html = file.readAsStringSync();
  if (!html.contains(_slot)) {
    stderr.writeln('No "$_slot" slot found in ${file.path}.');
    exit(1);
  }

  file.writeAsStringSync(html.replaceFirst(_slot, buildSeoContent()));
  stdout.writeln('SEO content written to ${file.path}.');
}

String buildSeoContent() {
  const e = HtmlEscape(HtmlEscapeMode.element);
  const attr = HtmlEscape(HtmlEscapeMode.attribute);
  final out = StringBuffer()
    ..writeln('<h1>Roni Paschoal</h1>')
    ..writeln(
      '<p>Desenvolvedor de Software Mobile Flutter · Santo André, SP</p>',
    )
    ..writeln('<nav>')
    ..writeln('<a href="/">Início</a>')
    ..writeln('<a href="/cv">Currículo</a>')
    ..writeln('<a href="/insura">Insura</a>')
    ..writeln('</nav>')
    ..writeln('<section><h2>Resumo</h2>')
    ..writeln('<p>${e.convert(cvSummary.resolve(_language))}</p></section>')
    ..writeln('<section><h2>Objetivo</h2>')
    ..writeln('<p>${e.convert(cvObjective.resolve(_language))}</p></section>');

  out.writeln('<section><h2>Formação Acadêmica</h2><ul>');
  for (final item in cvEducationList) {
    out.writeln('<li>${e.convert(item.course)} — '
        '${e.convert(item.institution)} (${e.convert(item.period)})</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>Experiência Profissional</h2>');
  for (final item in cvExperienceList) {
    out.writeln('<article><h3>${e.convert(item.role.resolve(_language))} — '
        '${e.convert(item.company)}</h3>');
    out.writeln('<p>${e.convert(item.period)}</p>');
    out.writeln('<p>${e.convert(item.description.resolve(_language))}</p>'
        '</article>');
  }
  out.writeln('</section>');

  out.writeln('<section><h2>Projetos</h2>');
  for (final item in cvProjectList) {
    out.writeln('<article><h3><a href="${attr.convert(item.url)}">'
        '${e.convert(item.title)}</a></h3>');
    out.writeln('<p>${e.convert(item.descriptionFor(_language))}</p>');
    out.writeln('<p>${e.convert(item.tech.join(', '))}</p></article>');
  }
  out.writeln('</section>');

  out.writeln('<section><h2>Competências</h2><ul>');
  for (final key in cvSkillGroupOrder) {
    out.writeln('<li>${e.convert(cvSkillGroups[key]!.join(', '))}</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>Certificações</h2><ul>');
  for (final item in cvCertificationList) {
    out.writeln('<li>${e.convert(item.title)} — ${e.convert(item.issuer)} '
        '(${e.convert(item.date)})</li>');
  }
  out.writeln('</ul></section>');

  out.writeln('<section><h2>Contato</h2><ul>');
  for (final item in cvContactList) {
    out.writeln('<li><a href="${attr.convert(item.url)}">'
        '${e.convert(item.text)}</a></li>');
  }
  out.writeln('</ul></section>');

  return out.toString();
}
