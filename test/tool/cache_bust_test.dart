import 'package:flutter_test/flutter_test.dart';

import '../../tool/cache_bust.dart';

void main() {
  test('the version depends only on the entry files', () {
    final a = buildVersion([
      [1, 2, 3],
      [4],
    ]);
    expect(a, hasLength(8));
    expect(
      buildVersion([
        [1, 2, 3],
        [4],
      ]),
      a,
    );
    expect(
      buildVersion([
        [1, 2, 3],
        [5],
      ]),
      isNot(a),
    );
  });

  test('versions the bootstrap script tag, idempotently', () {
    const html = '<script src="flutter_bootstrap.js" async></script>';
    final once = versionBootstrapScript(html, 'abc');
    expect(once, '<script src="flutter_bootstrap.js?v=abc" async></script>');
    expect(versionBootstrapScript(once, 'def'), contains('.js?v=def"'));
  });

  test('versions every entry file in the build config', () {
    const js = '_flutter.buildConfig = {"builds":[{"compileTarget":"dart2wasm",'
        '"mainWasmPath":"main.dart.wasm","jsSupportRuntimePath":'
        '"main.dart.mjs"},{"compileTarget":"dart2js","mainJsPath":'
        '"main.dart.js"}]};';
    final out = versionBuildConfig(js, 'abc');
    expect(out, contains('"mainWasmPath":"main.dart.wasm?v=abc"'));
    expect(out, contains('"jsSupportRuntimePath":"main.dart.mjs?v=abc"'));
    expect(out, contains('"mainJsPath":"main.dart.js?v=abc"'));
    expect(versionBuildConfig(out, 'abc'), out);
  });

  test('versions the deferred part names', () {
    const js = 'deferredPartUris:["main.dart.js_1.part.js"],';
    expect(
      versionDeferredParts(js, 'abc'),
      'deferredPartUris:["main.dart.js_1.part.js?v=abc"],',
    );
  });
}
