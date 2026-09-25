import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/pages/cv/cv_data.dart';
import 'package:ronip/pages/home/sections/contact_section.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('copy email puts the address on the clipboard and confirms it',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpApp(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          child: ContactSection(
            externalMenuList: const [],
            scrollController: controller,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('COPY EMAIL'));
    await tester.pump();

    expect(copied, contactEmail);
    expect(find.text('COPIED ✓'), findsOneWidget);

    // Flips back after a moment.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('COPY EMAIL'), findsOneWidget);
  });
}
