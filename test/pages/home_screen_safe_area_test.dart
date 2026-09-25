import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';
import 'package:ronip/pages/home/home_screen.dart';
import 'package:ronip/pages/home/sections/work_gallery_section.dart';
import 'package:ronip/pages/home/widgets/home_section_title_widget.dart';

import '../helpers/pump_app.dart';

/// iPhone-like: 390×844 logical, 47pt status bar, 34pt home indicator.
void _notchedPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3.0;
  tester.view.padding = const FakeViewPadding(top: 47 * 3, bottom: 34 * 3);
  addTearDown(tester.view.reset);
}

Future<void> _pumpHome(WidgetTester tester) async {
  await pumpApp(
    tester,
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppCubit()),
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: const HomeScreen(),
    ),
  );
  // Let the hero's entrance animation finish (its loops never settle).
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  testWidgets(
      'on a notched phone, the hero scroll cue sits inside the visible area',
      (tester) async {
    _notchedPhone(tester);
    await _pumpHome(tester);

    final cue = tester.getRect(find.text('SCROLL'));
    expect(cue.bottom, lessThanOrEqualTo(844 - 34));
    expect(cue.top, greaterThan(0));
  });

  testWidgets(
      'on a phone, the pinned gallery cards fill the band between the '
      'title and the progress readout', (tester) async {
    _notchedPhone(tester);
    await _pumpHome(tester);

    // Scroll so the gallery section is pinned to the top of the viewport.
    final position =
        tester.state<ScrollableState>(find.byType(Scrollable).first).position;
    final galleryTop = tester.getTopLeft(find.byType(WorkGallerySection)).dy;
    position.jumpTo(position.pixels + galleryTop + 1);
    await tester.pump();
    // The title height is measured post-frame; the cards then animate to
    // their final size (AnimatedContainer).
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final title = tester.getRect(
      find.byWidgetPredicate(
        (w) => w is HomeSectionTitleWidget && w.index == 2,
      ),
    );
    final card = tester.getRect(
      find
          .ancestor(
            of: find.text('Minha Comanda Eletrônica, App Flutter'),
            matching: find.byType(AnimatedContainer),
          )
          .first,
    );
    final progress = tester.getRect(
      find.byWidgetPredicate(
        (w) => w.runtimeType.toString() == '_GalleryProgress',
      ),
    );

    const appBarBottom = 47.0 + kToolbarHeight;
    expect(title.top, greaterThanOrEqualTo(appBarBottom));
    expect(card.top, greaterThanOrEqualTo(title.bottom));
    expect(card.bottom, lessThanOrEqualTo(progress.top));
    expect(progress.bottom, lessThanOrEqualTo(844 - 34));
    expect(card.height, greaterThanOrEqualTo(844 * 0.5));
  });
}
