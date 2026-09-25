/// Personal details surfaced in the site chrome (hero status line, footer) —
/// kept in one place so they're easy to update without touching layout code.
sealed class RpProfile {
  /// Drives the hero's "open to work" status dot. Flip to false to show the
  /// neutral "currently working" line instead.
  static const bool openToWork = true;

  /// Career-length figure used by the hero and the About bento.
  static const String yearsOfExperience = '8+';

  /// Breakdown shown next to it in the About bento; the hybrid figure is
  /// also on the hero's meta line.
  static const String yearsHybridMobile = '5+';
  static const String yearsFlutter = '3+';

  /// Source code of this site, linked from its own gallery card and footer.
  static const String sourceUrl = 'https://github.com/ronipaschoal/site_2_0';

  /// Short commit hash injected at build time
  /// (`--dart-define=GIT_SHA=$(git rev-parse --short HEAD)`), so the footer
  /// can say exactly which build is live.
  static const String buildSha =
      String.fromEnvironment('GIT_SHA', defaultValue: 'dev');
}
