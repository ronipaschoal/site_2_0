/// Test helpers for a11y_kit users: run Flutter's accessibility guidelines
/// and a few checks they don't cover, in one call.
library;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// [androidTapTargetGuideline] (48×48), minus read-only selectable text.
const AccessibilityGuideline
a11yAndroidTapTargetGuideline = A11yTapTargetGuideline(
  size: Size(48.0, 48.0),
  link: 'https://support.google.com/accessibility/android/answer/7101858?hl=en',
);

/// [iOSTapTargetGuideline] (44×44), minus read-only selectable text.
const AccessibilityGuideline a11yIOSTapTargetGuideline = A11yTapTargetGuideline(
  size: Size(44.0, 44.0),
  link:
      'https://developer.apple.com/design/human-interface-guidelines/accessibility#Buttons-and-controls',
);

/// Flutter's minimum tap target guideline, except that it skips selectable
/// text. [SelectableText] exposes a long-press action for text selection
/// (and, on web, a read-only text field), so the stock guideline reports
/// every paragraph of selectable copy as an undersized button.
///
/// Skipped: read-only text fields, and nodes whose only action is long
/// press without being a button. A custom long-press-only control should
/// mark itself as a button to stay covered.
///
/// Like the stock guideline, it skips links (WCAG 2.5.8's inline-link
/// exception): give small standalone links a size yourself, e.g. with
/// [A11yTappable.minTapTargetSize].
// ignore: invalid_use_of_visible_for_testing_member
class A11yTapTargetGuideline extends MinimumTapTargetGuideline {
  /// Creates the guideline for a minimum [size].
  const A11yTapTargetGuideline({required super.size, required super.link});

  @override
  bool shouldSkipNode(SemanticsNode node) {
    final data = node.getSemanticsData();
    final flags = data.flagsCollection;
    if (flags.isTextField && flags.isReadOnly) return true;
    final selectionOnly =
        data.hasAction(SemanticsAction.longPress) &&
        !data.hasAction(SemanticsAction.tap) &&
        !flags.isButton;
    if (selectionOnly) return true;
    return super.shouldSkipNode(node);
  }
}

/// Checks the current screen against Flutter's accessibility guidelines:
///
/// - [labeled]: every tappable node has a label;
/// - [textContrast]: text reaches WCAG AA (4.5:1, or 3:1 for large text);
/// - [androidTapTargets]: tappable nodes are at least 48×48;
/// - [iOSTapTargets]: tappable nodes are at least 44×44 (both via
///   [A11yTapTargetGuideline], which ignores selectable text);
/// - [namedTextFields]: no text field (including [SelectableText]) is
///   unnamed — on web those are read as blank "edit text" boxes.
///
/// Semantics must be enabled (`tester.ensureSemantics()`), and animations
/// settled, so contrast is measured on the final frame.
Future<void> expectMeetsA11yGuidelines(
  WidgetTester tester, {
  bool labeled = true,
  bool textContrast = true,
  bool androidTapTargets = true,
  bool iOSTapTargets = true,
  bool namedTextFields = true,
}) async {
  if (labeled) {
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  }
  if (textContrast) {
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }
  if (androidTapTargets) {
    await expectLater(tester, meetsGuideline(a11yAndroidTapTargetGuideline));
  }
  if (iOSTapTargets) {
    await expectLater(tester, meetsGuideline(a11yIOSTapTargetGuideline));
  }
  if (namedTextFields) {
    expect(unnamedTextFields(tester), isEmpty);
  }
}

/// Text-field nodes in the reading order with no label.
List<SemanticsData> unnamedTextFields(WidgetTester tester) => tester.semantics
    .simulatedAccessibilityTraversal()
    .map((node) => node.getSemanticsData())
    .where((d) => d.flagsCollection.isTextField && d.label.isEmpty)
    .toList();
