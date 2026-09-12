import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens external links (`https://`, `mailto:`) in the platform's browser
/// tab/mail client. There's nothing mail-specific about launching a
/// `mailto:` URI — `launchUrl` handles both the same way — so a single
/// method covers every link kind on the site.
sealed class HyperlinkHelper {
  static Future<void> open(String link) async {
    final url = Uri.parse(link);
    final launched = await launchUrl(url);
    if (!launched) {
      debugPrint('HyperlinkHelper: could not launch $url');
    }
  }
}
