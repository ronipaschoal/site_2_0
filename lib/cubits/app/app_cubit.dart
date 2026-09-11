import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({Brightness initialBrightness = Brightness.dark})
      : super(AppState(brightness: initialBrightness)) {
    RpTheme.brightness = initialBrightness;
  }

  static const _brightnessPrefKey = 'theme_brightness';

  void changeLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  /// Flips light/dark, applies it immediately (so [RpTheme]'s color getters
  /// reflect it as soon as this rebuild runs), and persists the choice so it
  /// sticks on the next visit.
  Future<void> toggleTheme() async {
    final next = state.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    RpTheme.brightness = next;
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
