import 'package:flutter/widgets.dart';

/// A work-gallery entry. `title` and `description` carry one value per
/// language code (e.g. `{'pt': ..., 'en': ...}`), matching the shape a real
/// content source (CMS/database) would return per locale — this data is
/// per-record content, not fixed UI copy, so it stays out of the app's
/// ARB-based `AppLocalizations`.
class WorkItem {
  final String tag;
  final String image;
  final String url;
  final String? urlApple;
  final Map<String, String> title;
  final Map<String, String> description;

  const WorkItem({
    required this.tag,
    required this.image,
    required this.url,
    this.urlApple,
    required this.title,
    required this.description,
  });

  static const _fallbackLanguageCode = 'pt';

  String titleFor(Locale locale) => _localize(title, locale);

  String descriptionFor(Locale locale) => _localize(description, locale);

  String _localize(Map<String, String> values, Locale locale) =>
      values[locale.languageCode] ??
      values[_fallbackLanguageCode] ??
      values.values.first;
}
