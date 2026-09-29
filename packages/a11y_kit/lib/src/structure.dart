import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Keeps [child]'s semantics together as one block in the reading order.
///
/// Screen readers order nodes by position, so two side-by-side columns
/// would otherwise be read interleaved, line by line. Wrap each column to
/// have it read whole, one after the other.
class A11yReadingGroup extends StatelessWidget {
  /// The content to keep together.
  final Widget child;

  /// Creates a reading-order group.
  const A11yReadingGroup({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      Semantics(container: true, explicitChildNodes: true, child: child);
}

/// Tags [child]'s semantics with [locale], so screen readers switch to a
/// matching voice for it (e.g. Portuguese content inside an English page).
///
/// Only the language code is used: the web engine writes
/// `Locale.toString()` into the `lang` attribute, and "pt_BR" isn't a valid
/// BCP 47 tag, while "pt" is.
class A11yLocale extends StatelessWidget {
  /// The language [child] is written in.
  final Locale locale;

  /// The content in that language.
  final Widget child;

  /// Creates a language scope.
  const A11yLocale({super.key, required this.locale, required this.child});

  /// A [WidgetsApp.builder] that tags the whole app with its current locale.
  ///
  /// The app-level locale isn't propagated to the semantics tree, so without
  /// this screen readers pick their voice from the device or browser
  /// language — e.g. reading Portuguese copy with an English voice.
  static Widget appBuilder(BuildContext context, Widget? child) => A11yLocale(
    locale: Localizations.localeOf(context),
    child: child ?? const SizedBox.shrink(),
  );

  @override
  Widget build(BuildContext context) =>
      Semantics(localeForSubtree: Locale(locale.languageCode), child: child);
}

/// Lets pointer events fall through to whatever is underneath while keeping
/// [child]'s semantics and focus intact — unlike [IgnorePointer], which
/// also blocks semantic actions such as a screen reader's "activate".
///
/// Useful for invisible, focusable proxies layered over visual content.
class A11yPointerPassThrough extends SingleChildRenderObjectWidget {
  /// Creates a pointer pass-through.
  const A11yPointerPassThrough({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPointerPassThrough();
}

class _RenderPointerPassThrough extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}
