/// A résumé job entry. `role` and `description` carry one value per
/// language code (e.g. `{'pt': ..., 'en': ...}`), matching the shape a real
/// content source (CMS/database) would return per locale — this data is
/// per-record content, not fixed UI copy, so it stays out of the app's
/// ARB-based `AppLocalizations`.
///
/// Deliberately Flutter-free (plain `String` language codes, not `Locale`)
/// so this model — and anything built only from it, like the PDF export —
/// stays usable outside a running Flutter engine.
class CvExperienceItem {
  final String company;
  final String period;
  final Map<String, String> role;
  final Map<String, String> description;

  const CvExperienceItem({
    required this.company,
    required this.period,
    required this.role,
    required this.description,
  });

  static const _fallbackLanguageCode = 'pt';

  String roleFor(String languageCode) => _localize(role, languageCode);

  String descriptionFor(String languageCode) =>
      _localize(description, languageCode);

  String _localize(Map<String, String> values, String languageCode) =>
      values[languageCode] ??
      values[_fallbackLanguageCode] ??
      values.values.first;
}

/// A personal/study project entry. `description` carries one value per
/// language code, same shape as [CvExperienceItem.description]; `tech` is a
/// plain stack list (proper nouns, not localized).
class CvProjectItem {
  final String title;
  final List<String> tech;
  final Map<String, String> description;
  final String url;

  const CvProjectItem({
    required this.title,
    required this.tech,
    required this.description,
    required this.url,
  });

  static const _fallbackLanguageCode = 'pt';

  String descriptionFor(String languageCode) =>
      description[languageCode] ??
      description[_fallbackLanguageCode] ??
      description.values.first;
}

/// A course/certificate entry. Titles and issuers are proper names handed
/// out in Portuguese regardless of site language, so — unlike experience
/// entries — they aren't localized.
class CvCertificationItem {
  final String title;
  final String issuer;
  final String date;

  const CvCertificationItem({
    required this.title,
    required this.issuer,
    required this.date,
  });
}

/// A school/degree entry.
class CvEducationItem {
  final String institution;
  final String course;
  final String period;

  const CvEducationItem({
    required this.institution,
    required this.course,
    required this.period,
  });
}

/// A spoken language entry. `language` and `level` carry one value per
/// language code, same shape as [CvExperienceItem.role]/`description`.
class CvLanguageItem {
  final Map<String, String> language;
  final Map<String, String> level;

  const CvLanguageItem({
    required this.language,
    required this.level,
  });

  static const _fallbackLanguageCode = 'pt';

  String languageFor(String languageCode) => _localize(language, languageCode);

  String levelFor(String languageCode) => _localize(level, languageCode);

  String _localize(Map<String, String> values, String languageCode) =>
      values[languageCode] ??
      values[_fallbackLanguageCode] ??
      values.values.first;
}

/// What a [CvContactItem] links to — lets each renderer (on-screen icon,
/// PDF export) pick its own presentation without the data itself knowing
/// about icons or fonts.
enum CvContactType { email, linkedin, github, website }

/// A contact entry (email, social profile, personal site).
class CvContactItem {
  final CvContactType type;
  final String text;
  final String url;

  const CvContactItem({
    required this.type,
    required this.text,
    required this.url,
  });
}
