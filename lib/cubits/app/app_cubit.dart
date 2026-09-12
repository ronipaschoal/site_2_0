import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({Brightness initialBrightness = Brightness.dark})
      : super(AppState(brightness: initialBrightness));

  static const _brightnessPrefKey = 'theme_brightness';

  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  /// Flips light/dark and persists the choice so it sticks on the next
  /// visit. [MyApp] rebuilds `MaterialApp.router`'s `theme` from the new
  /// state, and every widget reading colors via `context.rpColors` picks it
  /// up through the normal `Theme.of(context)` dependency mechanism.
  Future<void> toggleTheme() async {
    final next = state.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    emit(state.copyWith(brightness: next));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_brightnessPrefKey, next.name);
  }

  /// The brightness saved by a previous visit's [toggleTheme] call, or null
  /// when the visitor hasn't overridden the system/browser default yet.
  static Future<Brightness?> loadSavedBrightness() async {
    final prefs = await SharedPreferences.getInstance();
    return switch (prefs.getString(_brightnessPrefKey)) {
      'light' => Brightness.light,
      'dark' => Brightness.dark,
      _ => null,
    };
  }
}
