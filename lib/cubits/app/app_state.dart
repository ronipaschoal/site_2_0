part of 'app_cubit.dart';

class AppState {
  final Locale locale;
  final Brightness brightness;

  /// Defaults to Portuguese rather than following the browser: the URL
  /// picks the language (`/` is Portuguese, `/en` English), so search
  /// engines (which usually crawl as en-US) index each URL in the same
  /// language as its `lang`, meta tags and static content.
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
