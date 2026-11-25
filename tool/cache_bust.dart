// Adds a `?v=<hash of the build>` query to every URL that loads the Flutter
// app, so a deploy is never mixed with files a browser cached from the
// previous one (e.g. a new en.html running an old main.dart.js that has no
// `/en` route):
//
//   *.html               → flutter_bootstrap.js?v=…
//   flutter_bootstrap.js → main.dart.wasm / main.dart.mjs / main.dart.js?v=…
//   main.dart.js         → main.dart.js_<n>.part.js?v=… (deferred PDF code)
//
// web/.htaccess also sends `Cache-Control: no-cache`, so from now on every
// file is revalidated anyway; this query also reaches browsers holding
// copies cached before that header existed, which never ask the server.
// The hash is of the build's own entry files, so an identical rebuild keeps
// the same URLs.
//
// Usage (after tool/seo_content.dart, which writes the other .html files):
//   dart run tool/cache_bust.dart build/web
import 'dart:io';

const _entryFiles = ['main.dart.js', 'main.dart.wasm', 'main.dart.mjs'];

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/cache_bust.dart <build/web>');
    exit(64);
  }
  final dir = Directory(args.single);
  File file(String name) => File('${dir.path}/$name');

  final version = buildVersion([
    for (final name in _entryFiles)
      if (file(name).existsSync()) file(name).readAsBytesSync(),
  ]);

  try {
    void rewrite(File target, String Function(String) change) {
      final before = target.readAsStringSync();
      final after = change(before);
      if (after == before) {
        throw StateError('Nothing to version in ${target.path}.');
      }
      target.writeAsStringSync(after);
      stdout.writeln('Versioned ${target.path} (v=$version).');
    }

    for (final html in dir.listSync().whereType<File>()) {
      if (!html.path.endsWith('.html')) continue;
      rewrite(html, (s) => versionBootstrapScript(s, version));
    }
    rewrite(
      file('flutter_bootstrap.js'),
      (s) => versionBuildConfig(s, version),
    );
    final mainJs = file('main.dart.js');
    if (mainJs.readAsStringSync().contains(_deferredPart)) {
      rewrite(mainJs, (s) => versionDeferredParts(s, version));
    }
  } on StateError catch (error) {
    stderr.writeln(error.message);
    exit(1);
  }
}

/// Short FNV-1a hash of [files], as hex.
String buildVersion(List<List<int>> files) {
  var hash = 0x811c9dc5;
  for (final bytes in files) {
    for (final byte in bytes) {
      hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
    }
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

/// The `<script src="flutter_bootstrap.js">` tag of an entry page.
String versionBootstrapScript(String html, String version) => html.replaceAll(
      RegExp(r'src="flutter_bootstrap\.js(\?v=[^"]*)?"'),
      'src="flutter_bootstrap.js?v=$version"',
    );

/// The entry files named in `_flutter.buildConfig`, which the loader turns
/// into URLs as they are.
String versionBuildConfig(String js, String version) => js.replaceAllMapped(
      RegExp(
        r'"(mainWasmPath|jsSupportRuntimePath|mainJsPath)":"([^"?]*)(\?v=[^"]*)?"',
      ),
      (m) => '"${m[1]}":"${m[2]}?v=$version"',
    );

final _deferredPart = RegExp(r'main\.dart\.js_\d+\.part\.js');

/// The deferred-part file names dart2js writes into main.dart.js (the PDF
/// code), so a new main.dart.js never pairs with an old cached part.
String versionDeferredParts(String js, String version) => js.replaceAllMapped(
      RegExp(r'"(main\.dart\.js_\d+\.part\.js)(\?v=[^"]*)?"'),
      (m) => '"${m[1]}?v=$version"',
    );
