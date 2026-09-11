import 'package:flutter/material.dart';
import 'package:ronip/model/locale_model.dart';
import 'package:ronip/ui/theme.dart';

class LocaleButtonWidget extends StatelessWidget {
  final ValueChanged<Locale> changeLocale;

  const LocaleButtonWidget({
    super.key,
    required this.changeLocale,
  });

  @override
  Widget build(BuildContext context) {
    if (Localizations.localeOf(context) == LocaleEnum.pt.locale) {
      return TextButton(
        onPressed: () => changeLocale(LocaleEnum.en.locale),
        child: Text(
          LocaleEnum.en.text,
          style: TextStyle(color: RpTheme.textHighlightColor),
        ),
      );
    }
    return TextButton(
      onPressed: () => changeLocale(LocaleEnum.pt.locale),
      child: Text(
        LocaleEnum.pt.text,
        style: TextStyle(color: RpTheme.textHighlightColor),
      ),
    );
  }
}
