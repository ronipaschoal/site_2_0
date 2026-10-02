/// The résumé's printable layouts.
///
/// Kept apart from `CvPdfBuilder` so the download button can name a layout
/// without importing the builder eagerly — the builder (and the `pdf` and
/// `printing` packages behind it) is a deferred library on web.
enum CvPdfLayout {
  /// Two columns, mirroring the on-screen résumé: contact and skills in a
  /// sidebar, brand-colored accents.
  modern,

  /// One column in the conventional Brazilian order (objective, summary,
  /// education, experience, courses, additional info), plain black type —
  /// see `CvPdfClassicBuilder`.
  classic,
}
