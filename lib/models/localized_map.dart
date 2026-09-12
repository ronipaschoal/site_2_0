/// Shared shape for per-record, per-language content (see
/// `CvExperienceItem`, `CvProjectItem`, `CvLanguageItem`, `WorkItem`) — a
/// map from a language code to that record's text in that language.
extension LocalizedMap on Map<String, String> {
  static const _fallbackLanguageCode = 'pt';

  /// The value for [languageCode], falling back to Portuguese and then to
  /// whatever value exists, so a record missing a translation still renders
  /// something rather than throwing.
  String resolve(String languageCode) =>
      this[languageCode] ?? this[_fallbackLanguageCode] ?? values.first;
}
