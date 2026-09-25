import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronip/core/theme.dart';
import 'package:ronip/l10n/app_localizations.dart';

class RpCommand {
  final String label;
  final IconData icon;
  final VoidCallback run;

  /// Extra words matched by the search field but not shown (e.g. the
  /// English name of a Portuguese label).
  final String keywords;

  const RpCommand({
    required this.label,
    required this.icon,
    required this.run,
    this.keywords = '',
  });

  bool matches(String query) {
    if (query.isEmpty) return true;
    final haystack = '$label $keywords'.toLowerCase();
    return query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .every((term) => haystack.contains(term));
  }
}

/// A ⌘K / Ctrl+K command palette: a search field over [commands], driven by
/// the keyboard (↑/↓ to move, Enter to run, Esc to close).
class RpCommandPaletteWidget extends StatefulWidget {
  final List<RpCommand> commands;

  const RpCommandPaletteWidget({super.key, required this.commands});

  /// "⌘K" on Apple platforms, "Ctrl K" elsewhere — on web
  /// [defaultTargetPlatform] reflects the visitor's OS.
  static String get shortcutLabel => switch (defaultTargetPlatform) {
        TargetPlatform.macOS || TargetPlatform.iOS => '⌘K',
        _ => 'Ctrl K',
      };

  static bool _open = false;

  /// Shows the palette; the chosen command runs after the palette closes,
  /// so commands that open their own route/dialog stack cleanly. A second
  /// call while it's already open is ignored.
  static Future<void> show(
    BuildContext context,
    List<RpCommand> commands,
  ) async {
    if (_open) return;
    _open = true;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    try {
      final command = await showGeneralDialog<RpCommand>(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withValues(alpha: 0.45),
        transitionDuration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
        pageBuilder: (_, __, ___) => RpCommandPaletteWidget(commands: commands),
        transitionBuilder: (_, animation, __, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween(begin: 0.97, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      );
      command?.run();
    } finally {
      _open = false;
    }
  }

  @override
  State<RpCommandPaletteWidget> createState() => _RpCommandPaletteWidgetState();
}

class _RpCommandPaletteWidgetState extends State<RpCommandPaletteWidget> {
  final _controller = TextEditingController();
  var _selected = 0;

  List<RpCommand> get _filtered =>
      widget.commands.where((c) => c.matches(_controller.text.trim())).toList();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _run(RpCommand command) => Navigator.of(context).pop(command);

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final results = _filtered;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown && results.isNotEmpty) {
      setState(() => _selected = (_selected + 1) % results.length);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp && results.isNotEmpty) {
      setState(
        () => _selected = (_selected - 1 + results.length) % results.length,
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter && results.isNotEmpty) {
      _run(results[_selected.clamp(0, results.length - 1)]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;
    final l10n = AppLocalizations.of(context)!;
    final results = _filtered;
    final size = MediaQuery.sizeOf(context);

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: l10n.commandPaletteTooltip,
      child: Align(
        alignment: const Alignment(0.0, -0.45),
        child: Padding(
          padding: const EdgeInsets.all(RpTheme.spacingMedium),
          child: Material(
            color: colors.surfaceColor,
            elevation: 24.0,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: colors.hairlineColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 560.0,
                maxHeight: size.height * 0.6,
              ),
              child: Focus(
                onKeyEvent: _onKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: RpTheme.spacingMedium,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18.0,
                            color: colors.textColor,
                          ),
                          RpTheme.spacerSmall,
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              onChanged: (_) => setState(() => _selected = 0),
                              style: TextStyle(
                                color: colors.textHighlightColor,
                                fontSize: RpTheme.fontSizeRegular,
                              ),
                              decoration: InputDecoration(
                                hintText: l10n.commandPaletteHint,
                                hintStyle: TextStyle(color: colors.textColor),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                ),
                              ),
                            ),
                          ),
                          ExcludeSemantics(
                            child:
                                _KeyCap(label: 'Esc', color: colors.textColor),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1.0, color: colors.hairlineColor),
                    Flexible(
                      child: results.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(
                                RpTheme.spacingLarge,
                              ),
                              child: Text(
                                l10n.commandNoResults,
                                semanticsLabel: l10n.commandNoResults,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colors.textColor),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.all(RpTheme.spacingSmall),
                              itemCount: results.length,
                              itemBuilder: (context, i) => _CommandTile(
                                command: results[i],
                                selected: i == _selected,
                                onHover: () => setState(() => _selected = i),
                                onTap: () => _run(results[i]),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommandTile extends StatelessWidget {
  final RpCommand command;
  final bool selected;
  final VoidCallback onHover;
  final VoidCallback onTap;

  const _CommandTile({
    required this.command,
    required this.selected,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.rpColors;

    return Semantics(
      selected: selected,
      child: MouseRegion(
        onHover: (_) => onHover(),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            padding: const EdgeInsets.symmetric(
              horizontal: RpTheme.spacingMedium - 4.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.textHighlightColor.withValues(alpha: 0.06)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Icon(
                  command.icon,
                  size: 18.0,
                  color: selected ? RpTheme.brandColor : colors.textColor,
                ),
                RpTheme.spacerMedium,
                Expanded(
                  child: Text(
                    command.label,
                    style: TextStyle(
                      color: selected
                          ? colors.textHighlightColor
                          : colors.textColor,
                    ),
                  ),
                ),
                if (selected)
                  ExcludeSemantics(
                    child: _KeyCap(label: '↵', color: colors.textColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyCap extends StatelessWidget {
  final String label;
  final Color color;

  const _KeyCap({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: context.rpColors.hairlineColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: RpTheme.fontFamilyMono,
          fontSize: 11.0,
          color: color,
        ),
      ),
    );
  }
}

/// The nav entry point for the palette — also the only one on touch
/// devices, where there's no keyboard shortcut.
class RpCommandPaletteButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const RpCommandPaletteButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!.commandPaletteTooltip;

    return Semantics(
      button: true,
      label: '$label (${RpCommandPaletteWidget.shortcutLabel})',
      excludeSemantics: true,
      onTap: onPressed,
      child: Tooltip(
        message: label,
        child: TextButton(
          onPressed: onPressed,
          child: _KeyCap(
            label: RpCommandPaletteWidget.shortcutLabel,
            color: context.rpColors.textHighlightColor,
          ),
        ),
      ),
    );
  }
}
