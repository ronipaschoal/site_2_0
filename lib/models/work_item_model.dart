import 'package:flutter/widgets.dart';
import 'package:ronip/models/localized_map.dart';

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

  String titleFor(Locale locale) => title.resolve(locale.languageCode);

  String descriptionFor(Locale locale) =>
      description.resolve(locale.languageCode);
}
