import 'dart:ui' show SemanticsHitTestBehavior;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

/// A custom-drawn link or button that behaves like a native one: reachable
/// with Tab (and Switch Access / Full Keyboard Access on mobile), activated
/// with Enter or Space, shows a visible focus ring, and is announced with the
/// right role — a link when [url] is given (a real `<a href>` on web), a
/// button otherwise.
///
/// [builder] receives `highlighted` — true while hovered *or*
/// keyboard-focused — so hover styling doubles as the focus state.
class A11yTappable extends StatefulWidget {
  /// Runs on tap, keyboard activation or a screen reader's "activate".
  final VoidCallback onTap;

  /// Builds the visuals; `highlighted` is true while hovered or focused.
  final Widget Function(BuildContext context, bool highlighted) builder;

  /// External destination; makes this a link rather than a button.
  final String? url;

  /// Accessible name. When set, it replaces whatever the child exposes
  /// (e.g. "LinkedIn" instead of the visible "LINKEDIN ↗"); when null, the
  /// child's own text is merged into this node.
  final String? semanticsLabel;

  /// Shape of the focus ring.
  final BorderRadius borderRadius;

  /// Called when keyboard focus enters or leaves — e.g. so a horizontally
  /// scrubbed gallery can bring the focused item into view.
  final ValueChanged<bool>? onFocusChange;

  /// Draw the focus ring on this widget. Off when another widget renders
  /// the focused state instead.
  final bool showFocusRing;

  /// Overrides [A11yTheme.focusColor] for this widget.
  final Color? focusColor;

  /// Grows the hit area to at least this size, centered on the visuals —
  /// for small icons that must still reach 48×48 (Android) or 44×44 (iOS,
  /// WCAG 2.5.8). Null leaves the size to [builder].
  final Size? minTapTargetSize;

  /// Lets real mouse clicks pass through this widget's accessibility DOM
  /// element on web. Flutter Web gives interactive semantics nodes
  /// `pointer-events: all`, so an invisible tappable layered over other
  /// content would otherwise swallow clicks meant for what's underneath.
  /// Keyboard and screen reader activation are unaffected. No effect on
  /// Android and iOS.
  final bool passThroughPointer;

  /// Repeated activations within this window collapse into one.
  ///
  /// On web a single Enter on a focused semantic `<a>` reaches both
  /// Flutter's key handling and the element's click, so the default there
  /// is 500ms. On Android and iOS there's no such duplicate, so the default
  /// is zero and rapid taps all go through.
  final Duration? activationDebounce;

  /// Creates an accessible tappable.
  const A11yTappable({
    super.key,
    required this.onTap,
    required this.builder,
    this.url,
    this.semanticsLabel,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onFocusChange,
    this.showFocusRing = true,
    this.focusColor,
    this.minTapTargetSize,
    this.passThroughPointer = false,
    this.activationDebounce,
  });

  /// The debounce used when [activationDebounce] is null.
  static const Duration webActivationDebounce = Duration(milliseconds: 500);

  @override
  State<A11yTappable> createState() => _A11yTappableState();
}

class _A11yTappableState extends State<A11yTappable> {
  bool _hovering = false;
  bool _focused = false;
  DateTime? _lastTap;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Duration get _debounce =>
      widget.activationDebounce ??
      (kIsWeb ? A11yTappable.webActivationDebounce : Duration.zero);

  void _tap() {
    final debounce = _debounce;
    if (debounce > Duration.zero) {
      final now = DateTime.now();
      final last = _lastTap;
      if (last != null && now.difference(last) < debounce) return;
      _lastTap = now;
    }
    widget.onTap();
  }

  late final _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => _tap()),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: (_) => _tap(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final url = widget.url;
    final theme = A11yTheme.of(context);
    final minSize = widget.minTapTargetSize;

    Widget visuals = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        border: _focused && widget.showFocusRing
            ? Border.all(
                color: widget.focusColor ?? theme.resolveFocusColor(context),
                width: theme.focusWidth,
              )
            : null,
      ),
      child: widget.builder(context, _hovering || _focused),
    );
    if (minSize != null) {
      visuals = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize.width,
          minHeight: minSize.height,
        ),
        child: Center(widthFactor: 1.0, heightFactor: 1.0, child: visuals),
      );
    }

    // Merged from the outside, so without a semanticsLabel the child's text
    // becomes this node's name (one "Open résumé, button" stop, rather than
    // an unnamed button wrapping a separate text node).
    return MergeSemantics(
      child: Semantics(
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
        child: FocusableActionDetector(
          focusNode: _focusNode,
          actions: _actions,
          mouseCursor: SystemMouseCursors.click,
          onShowHoverHighlight: (value) => setState(() => _hovering = value),
          onShowFocusHighlight: (value) => setState(() => _focused = value),
          onFocusChange: widget.onFocusChange,
          child: GestureDetector(
            onTap: _tap,
            // The padding added by minTapTargetSize is empty space; it
            // must still catch taps.
            behavior: minSize == null ? null : HitTestBehavior.opaque,
            // The Semantics above already exposes the tap; this one would
            // only add a duplicate action.
            excludeFromSemantics: true,
            child: visuals,
          ),
        ),
      ),
    );
  }
}
