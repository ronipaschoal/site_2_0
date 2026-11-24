/// The site's URL scheme for its two languages: Portuguese at the root
/// (`/`, `/cv`) and English under `/en` (`/en`, `/en/cv`), so each language
/// has its own indexable URL.
///
/// Plain Dart (no Flutter imports), so `tool/seo_content.dart` builds the
/// static pages' canonical and hreflang URLs from the same rules the app
/// routes with.
sealed class RpLocalePaths {
  static const String portuguese = 'pt';
  static const String english = 'en';

  /// Language codes in the order they're listed (sitemap, hreflang).
  static const List<String> languages = [portuguese, english];

  /// The hreflang value for each language code.
  static const Map<String, String> hreflang = {
    portuguese: 'pt-BR',
    english: 'en',
  };

  /// The language whose URL is also `x-default` (shown to anyone else).
  static const String defaultLanguage = portuguese;

  static const String _englishPrefix = '/en';

  /// The language [path] is served in.
  static String languageOf(String path) =>
      path == _englishPrefix || path.startsWith('$_englishPrefix/')
          ? english
          : portuguese;

  /// [path] without its language prefix: `/en/cv` → `/cv`, `/en` → `/`.
  static String basePath(String path) {
    if (languageOf(path) == portuguese) return path;
    final rest = path.substring(_englishPrefix.length);
    return rest.isEmpty ? '/' : rest;
  }

  /// [basePath] (a Portuguese path) in [language]: `/cv` → `/en/cv`,
  /// `/` → `/en`.
  static String localize(String basePath, String language) {
    if (language != english) return basePath;
    return basePath == '/' ? _englishPrefix : '$_englishPrefix$basePath';
  }

  /// [path] moved to [language], keeping the page: `/cv` → `/en/cv`.
  static String switchLanguage(String path, String language) =>
      localize(basePath(path), language);
}
