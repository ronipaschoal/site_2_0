import 'dart:ui' show SemanticsHitTestBehavior;

import 'package:flutter/material.dart';
import 'package:ronip/core/theme.dart';

/// A custom-drawn link/button that behaves like a native one: reachable
/// with Tab, activated with Enter/Space, shows a visible focus ring, and is
/// announced to screen readers with the right role — a link (rendered as a
/// real `<a href>` on web when [url] is given) or a button.
///
/// [builder] receives `highlighted` — true while hovered *or*
/// keyboard-focused — so hover styling doubles as the focus state.
class RpTappableWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Widget Function(BuildContext context, bool highlighted) builder;

  /// External destination; makes this a link rather than a button.
  final String? url;

  /// Accessible name; defaults to the text the child already exposes.
  final String? semanticsLabel;

  final BorderRadius borderRadius;

  /// Called when keyboard focus enters/leaves — e.g. so a horizontally
  /// scrubbed gallery can bring the focused card into view.
  final ValueChanged<bool>? onFocusChange;

  /// Draw the focus ring on this widget. Off when another widget renders
  /// the focused state instead (e.g. the gallery's semantic proxies).
  final bool showFocusRing;

  /// Lets real mouse clicks pass through this widget's accessibility DOM
  /// element on web. Flutter Web gives interactive semantics nodes
  /// `pointer-events: all`, so an invisible tappable layered over other
  /// content would otherwise swallow clicks meant for what's underneath.
  /// Keyboard and screen reader activation are unaffected.
  final bool passThroughPointer;

  const RpTappableWidget({
    super.key,
    required this.onTap,
    required this.builder,
    this.url,
    this.semanticsLabel,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onFocusChange,
    this.showFocusRing = true,
    this.passThroughPointer = false,
  });

  @override
  State<RpTappableWidget> createState() => _RpTappableWidgetState();
}

class _RpTappableWidgetState extends State<RpTappableWidget> {
  bool _hovering = false;
  bool _focused = false;
  DateTime? _lastTap;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// A single activation can arrive through two paths on web — e.g. Enter
  /// on a focused semantic `<a>` reaches both Flutter's key handling and
  /// the element's click — so collapse repeats into one tap.
  void _tap() {
    final now = DateTime.now();
    final last = _lastTap;
    if (last != null &&
        now.difference(last) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastTap = now;
    widget.onTap();
  }

  late final _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) => _tap(),
    ),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: (_) => _tap(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final url = widget.url;

    return Semantics(
      link: url != null,
      button: url == null,
      linkUrl: url == null ? null : Uri.tryParse(url),
      label: widget.semanticsLabel,
      onTap: _tap,
      // Re-exposed here because excludeSemantics hides the inner Focus
      // widget's own focus semantics: without them, focus moved by a screen
      // reader or the browser (DOM focus on the semantic element) never
      // reaches Flutter's focus system — no focus ring, no onFocusChange.
      focusable: true,
      focused: _focusNode.hasPrimaryFocus,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: widget.semanticsLabel != null,
      hitTestBehavior: widget.passThroughPointer
          ? SemanticsHitTestBehavior.transparent
          : null,
      child: MergeSemantics(
        child: FocusableActionDetector(
          focusNode: _focusNode,
          actions: _actions,
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (value) => setState(() => _hovering = value),
          onShowFocusHighlight: (value) => setState(() => _focused = value),
          onFocusChange: widget.onFocusChange,
          child: GestureDetector(
            onTap: _tap,
            // The Semantics above already exposes the tap; this one would
            // only add a duplicate action.
            excludeFromSemantics: true,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                border: _focused && widget.showFocusRing
                    ? Border.all(
                        color: context.rpColors.accentTextColor,
                        width: 2.0,
                      )
                    : null,
              ),
              child: widget.builder(context, _hovering || _focused),
            ),
          ),
        ),
      ),
    );
  }
}
