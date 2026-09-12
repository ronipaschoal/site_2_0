import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/models/home_menu_model.dart';
import 'package:ronip/pages/home/cubit/home_cubit.dart';

void main() {
  group('HomeState', () {
    test('== compares by activeMenu', () {
      final a = HomeState(activeMenu: HomeSectionEnum.about);
      final b = HomeState(activeMenu: HomeSectionEnum.about);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('HomeCubit', () {
    test('starts with the home section active', () {
      final cubit = HomeCubit();

      expect(cubit.state.activeMenu, HomeSectionEnum.home);
      cubit.close();
    });

    test('activeMenu updates the active section', () {
      final cubit = HomeCubit();

      cubit.activeMenu(HomeSectionEnum.contact);

      expect(cubit.state.activeMenu, HomeSectionEnum.contact);
      cubit.close();
    });

    test('emits a new state for each distinct section', () async {
      final cubit = HomeCubit();
      final emitted = <HomeSectionEnum>[];
      final subscription = cubit.stream.listen(
        (state) => emitted.add(state.activeMenu),
      );

      cubit.activeMenu(HomeSectionEnum.about);
      await Future<void>.delayed(Duration.zero);
      cubit.activeMenu(HomeSectionEnum.programs);
      await Future<void>.delayed(Duration.zero);

      expect(emitted, [HomeSectionEnum.about, HomeSectionEnum.programs]);

      await subscription.cancel();
      await cubit.close();
    });
  });
}
