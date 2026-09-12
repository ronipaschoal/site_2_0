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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          other.locale == locale &&
          other.brightness == brightness;

  @override
  int get hashCode => Object.hash(locale, brightness);
}
