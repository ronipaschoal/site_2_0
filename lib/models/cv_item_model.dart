import 'package:ronip/models/localized_map.dart';

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

  String roleFor(String languageCode) => role.resolve(languageCode);

  String descriptionFor(String languageCode) =>
      description.resolve(languageCode);

  static const _ptMonths = 'jan fev mar abr mai jun jul ago set out nov dez';
  static const _enMonths = 'jan feb mar apr may jun jul aug sep oct nov dec';

  /// Months covered by [period] (`'Mmm/yyyy - Mmm/yyyy'`), counting both
  /// the start and end months — so `'Jul/2025 - Jun/2026'` is 12 months,
  /// matching how LinkedIn reports tenure. Null when [period] isn't in that
  /// shape, so a free-form period simply renders without a duration.
  int? get durationInMonths {
    final bounds = period.split('-').map(_parseMonth).toList();
    if (bounds.length != 2 || bounds.contains(null)) return null;

    final months = bounds[1]! - bounds[0]! + 1;
    return months > 0 ? months : null;
  }

  static int? _parseMonth(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 2) return null;

    final name = parts[0].toLowerCase();
    var index = _ptMonths.split(' ').indexOf(name);
    if (index < 0) index = _enMonths.split(' ').indexOf(name);
    final year = int.tryParse(parts[1]);
    if (index < 0 || year == null) return null;

    return year * 12 + index;
  }

  /// [durationInMonths] as readable text, e.g. `'2 anos e 3 meses'` /
  /// `'2 yrs 3 mos'`. Null when the duration can't be computed.
  String? durationFor(String languageCode) {
    final total = durationInMonths;
    if (total == null) return null;

    final years = total ~/ 12;
    final months = total % 12;
    final isPt = languageCode != 'en';

    final parts = [
      if (years > 0)
        isPt
            ? '$years ${years == 1 ? 'ano' : 'anos'}'
            : '$years ${years == 1 ? 'yr' : 'yrs'}',
      if (months > 0)
        isPt
            ? '$months ${months == 1 ? 'mês' : 'meses'}'
            : '$months ${months == 1 ? 'mo' : 'mos'}',
    ];

    return parts.join(isPt ? ' e ' : ' ');
  }

  /// [period] followed by its duration, e.g.
  /// `'Jul/2025 - Jun/2026 · 1 ano'`.
  String periodWithDurationFor(String languageCode) {
    final duration = durationFor(languageCode);
    return duration == null ? period : '$period · $duration';
  }
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

  String descriptionFor(String languageCode) =>
      description.resolve(languageCode);
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

  String languageFor(String languageCode) => language.resolve(languageCode);

  String levelFor(String languageCode) => level.resolve(languageCode);
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
