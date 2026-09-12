import 'package:flutter/material.dart';
import 'package:ronip/l10n/app_localizations.dart';
import 'package:ronip/core/theme.dart';

class ThemeButtonWidget extends StatelessWidget {
  final VoidCallback toggleTheme;

  const ThemeButtonWidget({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: toggleTheme,
      tooltip: isDark
          ? AppLocalizations.of(context)!.switchToLightMode
          : AppLocalizations.of(context)!.switchToDarkMode,
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: context.rpColors.textHighlightColor,
      ),
    );
  }
}
