import 'package:flutter/material.dart';

/// Exposes [child] as a heading: an `<h1>`–`<h6>` on web, a header node on
/// Android and iOS (where screen readers navigate by headings but ignore
/// the level).
///
/// [label] replaces the child's semantics, so animated or decorated text
/// (scrambled frames, uppercase styling) is always read as the final title.
class A11yHeading extends StatelessWidget {
  /// 1–6, as in HTML.
  final int level;

  /// The heading text as it should be read.
  final String label;

  /// The visual heading.
  final Widget child;

  /// Creates a heading.
  const A11yHeading({
    super.key,
    required this.level,
    required this.label,
    required this.child,
  }) : assert(level >= 1 && level <= 6, 'Heading level must be 1–6');

  @override
  Widget build(BuildContext context) => Semantics(
    headingLevel: level,
    label: label,
    excludeSemantics: true,
    child: child,
  );
}

/// Shows [text] in uppercase but reads it in its natural case.
///
/// Screen readers may spell out all-caps words letter by letter, as if they
/// were acronyms ("A-B-O-U-T"), so the visual transform stays visual.
class A11yCapsText extends StatelessWidget {
  /// The text in its natural case.
  final String text;

  /// Overrides what's read aloud (defaults to [text]).
  final String? semanticsLabel;

  /// See [Text.style].
  final TextStyle? style;

  /// See [Text.textAlign].
  final TextAlign? textAlign;

  /// Creates uppercase text with a natural-case label.
  const A11yCapsText(
    this.text, {
    super.key,
    this.semanticsLabel,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    semanticsLabel: semanticsLabel ?? text,
    style: style,
    textAlign: textAlign,
  );
}

/// A [SelectableText] that is always named for screen readers.
///
/// Without a `semanticsLabel`, Flutter Web exposes a [SelectableText] as an
/// unlabelled text box ("edit text, blank"). On Android and iOS the label is
/// redundant but harmless.
class A11ySelectableText extends StatelessWidget {
  /// The visible text.
  final String text;

  /// Overrides what's read aloud (defaults to [text]).
  final String? semanticsLabel;

  /// When set, exposes the text as a heading of this level (see
  /// [A11yHeading]).
  final int? headingLevel;

  /// See [SelectableText.style].
  final TextStyle? style;

  /// See [SelectableText.textAlign].
  final TextAlign? textAlign;

  /// Creates a labelled selectable text.
  const A11ySelectableText(
    this.text, {
    super.key,
    this.semanticsLabel,
    this.headingLevel,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final label = semanticsLabel ?? text;
    final selectable = SelectableText(
      text,
      semanticsLabel: label,
      style: style,
      textAlign: textAlign,
    );
    final level = headingLevel;
    if (level == null) return selectable;
    return A11yHeading(level: level, label: label, child: selectable);
  }
}
