import 'dart:ui' show SemanticsHitTestBehavior;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/home/sections/work_gallery_section.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets(
      'every project stays reachable as a link, including cards scrubbed '
      'off-screen', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final handle = tester.ensureSemantics();
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: WorkGallerySection(scrollController: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // At rest only the first cards are on screen; the rest sit translated
    // (and clipped) to the right — which used to drop them from semantics.
    const projects = {
      'Minha Comanda': 'play.google.com',
      'This site': 'github.com/ronipaschoal/site_2_0',
      'O Eremita do Iceberg': 'eremitaflutter.ronipaschoal.com.br',
      'Roni Paschoal (V1)': 'angular.ronipaschoal.com.br',
      'Reali Plásticos': 'realiplasticos.com.br',
    };
    for (final MapEntry(key: title, value: url) in projects.entries) {
      final link = find.bySemanticsLabel(RegExp('^${RegExp.escape(title)}'));
      expect(link, findsOneWidget, reason: title);
      final data = tester.getSemantics(link).getSemanticsData();
      expect(data.flagsCollection.isLink, isTrue, reason: title);
      expect(data.linkUrl.toString(), contains(url), reason: title);
      // The proxies are stacked over the visual cards; on web they must let
      // real clicks through, or the topmost one catches them all.
      expect(
        data.hitTestBehavior,
        SemanticsHitTestBehavior.transparent,
        reason: title,
      );
    }

    handle.dispose();
  });
}
