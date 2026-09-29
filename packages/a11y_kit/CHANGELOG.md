## 0.1.0

- Initial release, extracted from [ronipaschoal.com.br](https://ronipaschoal.com.br/).
- `A11y.ensureInitialized`: always-on semantics and a semantic-link guard on web.
- `A11yTappable`: accessible custom link/button (roles, `linkUrl`, keyboard,
  focus ring, `minTapTargetSize`, web click pass-through, web-only activation
  debounce).
- `A11yHeading`, `A11yCapsText`, `A11ySelectableText`.
- `A11yReadingGroup`, `A11yLocale` (+ `appBuilder`), `A11yPointerPassThrough`.
- `A11yAnnouncer` + `A11yLiveRegion` (announcements on web/iOS, live regions on
  Android).
- `context.reduceMotion` / `motionDuration`, `A11yMotion`, `context.boldText`,
  `context.highContrast`.
- `A11yTheme` for focus ring color/width.
- `package:a11y_kit/testing.dart`: `expectMeetsA11yGuidelines`,
  `unnamedTextFields`, and tap target guidelines that ignore selectable text.
