part of 'app_cubit.dart';

class AppState {
  final Locale locale;
  final Brightness brightness;

  /// Always starts in Portuguese rather than following the browser, so
  /// search engines (which usually crawl as en-US) index the same language
  /// as the page's `lang`, meta tags and static content. English stays one
  /// tap away on the language button.
  AppState({
    Locale? locale,
    this.brightness = Brightness.dark,
  }) : locale = locale ?? LocaleEnum.pt.locale;

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
