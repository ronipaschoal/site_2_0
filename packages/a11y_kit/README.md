# a11y_kit

Accessible building blocks for Flutter on **web, Android and iOS**: custom
links and buttons that behave like native ones, headings, reduce-motion
helpers, status announcements that work on every platform, and fixes for the
rough edges of Flutter Web's accessibility DOM.

Nothing here replaces Flutter's own `Semantics` API. Each widget packages a
pattern that is easy to get subtly wrong, with the reason documented next to
the code.

> Status: `0.1.0`, used in production on
> [ronipaschoal.com.br](https://ronipaschoal.com.br/). Behavior was verified
> through widget tests and a Chrome test of the link guard. Screen reader
> behavior on real devices (TalkBack, VoiceOver, NVDA) still needs to be
> checked by hand.

## Setup

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  A11y.ensureInitialized(); // web only; a no-op on Android and iOS
  runApp(const MyApp());
}

MaterialApp(
  builder: A11yLocale.appBuilder, // screen readers speak the app's language
  theme: ThemeData(
    extensions: const [A11yTheme(focusColor: Color(0xFFB8290C))],
  ),
  // ...
);
```

## What's in it

| API | Problem it solves | Web | Android | iOS |
|---|---|:-:|:-:|:-:|
| `A11y.ensureInitialized()` | Flutter Web builds no accessibility DOM until a hidden "Enable accessibility" button is pressed, so screen readers find an empty page. Semantic `<a href>` links also navigate the tab away in addition to running `onTap`. | ✅ | – | – |
| `A11yLocale` / `A11yLocale.appBuilder` | The app's locale isn't propagated to semantics, so voices follow the device language. Only the language code is used, because the web engine writes `Locale.toString()` (`pt_BR`) into `lang`, and that isn't valid BCP 47. | ✅ | ✅ | ✅¹ |
| `A11yTappable` | A custom-drawn link or button with the right role, a real `<a href>` on web, Tab plus Enter/Space, a visible focus ring, and an optional `minTapTargetSize` for 48/44px targets. | ✅ | ✅ | ✅ |
| `A11yHeading` | `<h1>`–`<h6>` on web and header nodes on mobile. Its label replaces animated or decorated text. | ✅ | ✅² | ✅² |
| `A11yCapsText` | Uppercase styling makes screen readers spell words out ("A-B-O-U-T"). The text is read in its natural case instead. | ✅ | ✅ | ✅ |
| `A11ySelectableText` | Flutter Web exposes an unlabelled `SelectableText` as a blank "edit text" box. | ✅ | = | = |
| `A11yReadingGroup` | Side-by-side columns get read interleaved, line by line. | ✅ | ✅ | ✅ |
| `A11yPointerPassThrough` | Lets clicks through to the content underneath while keeping semantics and focus (`IgnorePointer` blocks both). | ✅ | ✅ | ✅ |
| `A11yAnnouncer` + `A11yLiveRegion` | Status messages ("Copied"). Web and iOS get an announcement. Android deprecated announcements, so a live region covers it there. | ✅ | ✅ | ✅ |
| `context.reduceMotion`, `motionDuration()`, `A11yMotion` | Reads "Reduce motion" reactively. `platformDispatcher` read in `initState` is a snapshot that ignores later changes. | ✅ | ✅ | ✅ |
| `context.boldText`, `context.highContrast` | Bold Text and Increase Contrast, for custom-painted UI. | – | ✅ | ✅ |

✅ helps · = harmless, redundant · – not applicable

¹ Support for switching voices per node depends on the platform's
accessibility bridge. Check it on a device.
² Mobile screen readers navigate by headings but ignore the level.

### Platform notes

- **Activation debounce.** On web, one Enter on a focused semantic `<a>`
  reaches both Flutter's key handling and the element's click, so
  `A11yTappable` collapses repeats within 500ms. On Android and iOS the
  default is zero, so fast taps all go through. Set it with
  `activationDebounce`.
- **Live regions on web.** The engine announces a live region's label as
  soon as the node appears. That's why `A11yLiveRegion` is enabled only on
  Android by default.
- **Link guard.** It matches `flt-semantics-host a[href]`, which is
  engine-internal markup. `test/link_guard_web_test.dart` covers the guard;
  run it on every Flutter upgrade:
  `flutter test --platform chrome test/link_guard_web_test.dart`.

## Testing

```dart
import 'package:a11y_kit/testing.dart';

testWidgets('screen is accessible', (tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(const MyScreen());
  await tester.pumpAndSettle();
  await expectMeetsA11yGuidelines(tester);
  handle.dispose();
});
```

`expectMeetsA11yGuidelines` runs Flutter's labeled-target and text-contrast
guidelines, plus 48×48 (Android) and 44×44 (iOS) tap targets, and fails on
unnamed text fields. The tap target checks use `A11yTapTargetGuideline`,
which skips selectable text. The stock guideline reports every
`SelectableText` as an undersized button because of its long-press selection
action. Like the stock guideline, it also skips links (WCAG 2.5.8's inline
exception), so size small standalone links with `minTapTargetSize`.

## Development

```sh
flutter test                                              # VM tests
flutter test --platform chrome test/link_guard_web_test.dart  # web DOM guard
```

## License

MIT
