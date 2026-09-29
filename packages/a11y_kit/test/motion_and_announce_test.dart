import 'package:a11y_kit/a11y_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('reduceMotion follows MediaQuery and rebuilds on change', (
    tester,
  ) async {
    final values = <bool>[];
    final durations = <Duration>[];
    Widget app(bool disable) => MediaQuery(
      data: MediaQueryData(disableAnimations: disable),
      child: Builder(
        builder: (context) {
          values.add(context.reduceMotion);
          durations.add(
            context.motionDuration(const Duration(milliseconds: 300)),
          );
          return const SizedBox();
        },
      ),
    );

    await tester.pumpWidget(app(false));
    await tester.pumpWidget(app(true));

    expect(values, [false, true]);
    expect(durations, [const Duration(milliseconds: 300), Duration.zero]);
  });

  testWidgets('boldText and highContrast read MediaQuery', (tester) async {
    late bool bold, contrast;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(boldText: true, highContrast: true),
        child: Builder(
          builder: (context) {
            bold = context.boldText;
            contrast = context.highContrast;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(bold, isTrue);
    expect(contrast, isTrue);
  });

  group('announcements', () {
    late List<Object?> sent;

    setUp(() {
      sent = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockDecodedMessageHandler<Object?>(
            SystemChannels.accessibility,
            (message) async => sent.add(message),
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockDecodedMessageHandler<Object?>(
            SystemChannels.accessibility,
            null,
          );
    });

    Future<BuildContext> pumpContext(WidgetTester tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      return ctx;
    }

    testWidgets('are sent on iOS', (tester) async {
      final context = await pumpContext(tester);
      await A11yAnnouncer.announce(context, 'Copied');
      expect(sent.toString(), contains('Copied'));
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets(
      'are skipped on Android, which uses live regions',
      (tester) async {
        final context = await pumpContext(tester);
        await A11yAnnouncer.announce(context, 'Copied');
        expect(sent, isEmpty);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  });

  group('A11yLiveRegion', () {
    Future<bool> isLive(WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: A11yLiveRegion(child: Text('Copied')),
        ),
      );
      final live = tester
          .getSemantics(find.text('Copied'))
          .getSemanticsData()
          .flagsCollection
          .isLiveRegion;
      handle.dispose();
      return live;
    }

    testWidgets(
      'is live on Android',
      (tester) async => expect(await isLive(tester), isTrue),
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );

    testWidgets(
      'is inert on iOS, which uses announcements',
      (tester) async => expect(await isLive(tester), isFalse),
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );
  });
}
