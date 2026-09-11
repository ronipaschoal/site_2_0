part of 'app_cubit.dart';

class AppState {
  final Locale? locale;
  final Brightness brightness;

  AppState({this.locale, this.brightness = Brightness.dark});

  AppState copyWith({Locale? locale, Brightness? brightness}) {
    return AppState(
      locale: locale ?? this.locale,
      brightness: brightness ?? this.brightness,
    );
  }
}
