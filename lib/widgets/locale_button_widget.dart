import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/models/locale_model.dart';
import 'package:ronip/core/theme.dart';

class LocaleButtonWidget extends StatelessWidget {
  final ValueChanged<Locale> changeLocale;

  const LocaleButtonWidget({
    super.key,
    required this.changeLocale,
  });

  @override
  Widget build(BuildContext context) {
    final next = Localizations.localeOf(context) == LocaleEnum.pt.locale
        ? LocaleEnum.en
        : LocaleEnum.pt;

    return TextButton(
      onPressed: () => changeLocale(next.locale),
      child: Text(
        next.text,
        // "EN"/"PT" alone is ambiguous when read aloud.
        semanticsLabel: AppLocalizations.of(context)!.commandChangeLanguage,
        style: TextStyle(color: context.rpColors.textHighlightColor),
      ),
    );
  }
}
