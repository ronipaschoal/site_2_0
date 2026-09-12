import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronip/cubits/app/app_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppState', () {
    test('copyWith keeps existing fields when none are passed', () {
      final state = AppState(brightness: Brightness.dark);
      final copy = state.copyWith();

      expect(copy.brightness, Brightness.dark);
      expect(copy.locale, isNull);
    });

    test('== compares by value', () {
      final a =
          AppState(brightness: Brightness.light, locale: const Locale('en'));
      final b =
          AppState(brightness: Brightness.light, locale: const Locale('en'));

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });

  group('AppCubit', () {
    test('starts with the given initial brightness', () {
      final cubit = AppCubit(initialBrightness: Brightness.light);

      expect(cubit.state.brightness, Brightness.light);
      cubit.close();
    });

    test('changeLocale updates only the locale', () {
      final cubit = AppCubit(initialBrightness: Brightness.dark);

      cubit.changeLocale(const Locale('en', 'US'));

      expect(cubit.state.locale, const Locale('en', 'US'));
      expect(cubit.state.brightness, Brightness.dark);
      cubit.close();
    });

    test('toggleTheme flips brightness and persists the choice', () async {
      final cubit = AppCubit(initialBrightness: Brightness.dark);

      await cubit.toggleTheme();
      expect(cubit.state.brightness, Brightness.light);

      await cubit.toggleTheme();
      expect(cubit.state.brightness, Brightness.dark);

      await cubit.close();
    });

    test('loadSavedBrightness returns null before any toggle', () async {
      expect(await AppCubit.loadSavedBrightness(), isNull);
    });

    test('loadSavedBrightness reflects the last toggleTheme call', () async {
      final cubit = AppCubit(initialBrightness: Brightness.dark);

      await cubit.toggleTheme();
      await cubit.close();

      expect(await AppCubit.loadSavedBrightness(), Brightness.light);
    });
  });
}
