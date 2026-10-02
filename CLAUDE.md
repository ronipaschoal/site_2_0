# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal portfolio site (Flutter web, also builds for Android/iOS), live at ronipaschoal.com.br. Flutter is pinned to **3.44.0** (`.fvmrc`, and the same version in CI).

## Commands

```bash
flutter pub get                 # also regenerates AppLocalizations (generate: true)
flutter run -d chrome
flutter analyze                 # CI runs this; must be clean (infos included)
flutter test                    # app tests
flutter test test/widgets/reveal_on_scroll_widget_test.dart          # single file
flutter test --plain-name 'reveals its child only once scrolled'     # single test by name

# Local package — CI runs its tests too
(cd packages/a11y_kit && flutter test)
(cd packages/a11y_kit && flutter test --platform chrome test/link_guard_web_test.dart)  # DOM link guard, needs Chrome

# Production build, as CI does it (Wasm/skwasm with the JS build as fallback)
flutter build web --release --wasm --dart-define=GIT_SHA=<sha> --dart-define=GA_MEASUREMENT_ID=<id>
dart run tool/seo_content.dart build/web/index.html   # must run after every web build

# After adding UI text with characters outside Latin/common punctuation/arrows
pip install fonttools && python3 tool/subset_fonts.py
```

CI (`.github/workflows/main.yaml`) runs analyze → tests → a11y_kit tests → wasm build → SEO injection, then deploys `build/web` over FTP on every push to `main`. A push to `main` goes to production.

## Architecture

There's no backend, so there's no repository/data layer. Content is static Dart, organized by route.

- **Routing**: `lib/app/routes.dart` combines one `GoRoute` per page folder (`pages/<page>/<page>_route.dart`): `/` and `/cv`. The app uses path URLs (`usePathUrlStrategy`), and `web/.htaccess` rewrites unknown paths to `index.html`. That file also sets the `.wasm`/`.mjs` MIME types. Any new route must also be added to `web/sitemap.xml`.
- **State**: there are only two Cubits. `AppCubit` (`lib/cubits/app/`) holds the locale and brightness, and persists brightness with `shared_preferences`. `main()` loads the saved brightness *before* `runApp` so the first frame already uses the right theme. `HomeCubit` holds the active nav section and is driven by `HomeScreen._onScroll`. Everything else is local `ScrollController`/`AnimationController` state.
- **Theme**: read colors with `context.rpColors` (a `ThemeExtension` in `lib/core/theme.dart`), never through globals. `RpTheme.brandColor` is only for large text and decoration. Small text and focus rings use `accentTextColor`, which is tuned for WCAG AA.
- **Localization has two separate mechanisms**:
  - Fixed UI copy goes in ARB files (`lib/l10n/app_pt.arb` is the template) and is read through `AppLocalizations`.
  - Per-record content (résumé entries, gallery works) carries a `{'pt': …, 'en': …}` map directly on the model and is resolved with `LocalizedMap` (`lib/models/localized_map.dart`), which has fallback rules.
- **Résumé content has one source of truth**: `lib/pages/cv/cv_data.dart`. Four consumers read it:
  - the on-screen résumé (`cv_content_widget.dart`);
  - the two PDF layouts (`cv_pdf_builder.dart` for modern, `cv_pdf_classic_builder.dart` for classic);
  - the home "About" timeline;
  - `tool/seo_content.dart`, which writes it as hidden HTML into the `<!-- seo-content -->` slot of `web/index.html` for crawlers.

  Change content only in `cv_data.dart`.
- **PDF code is a deferred library**: `cv_download_button.dart` imports `cv_pdf_builder.dart` as `deferred` so `pdf`/`printing` stay out of `main.dart.js`. Never import `cv_pdf_builder.dart` eagerly from app code. Types the UI needs, like `CvPdfLayout`, live in separate non-deferred files (`cv_pdf_layout.dart`).
- **Scroll-driven home page**: `HomeScreen` owns a single `ScrollController` and passes it down. The two shared mixins (`ScrollRevealMixin` for one-shot reveals and `ScrollProgressMixin` for 0..1 progress) work by listening to that controller. `WorkGallerySection` pins itself and scrubs sideways based on scroll offset. Its static subtrees are built outside the per-frame `AnimatedBuilder`, so keep them that way. Its visual cards are wrapped in `ExcludeSemantics`/`ExcludeFocus`, and keyboard and screen-reader users go through invisible proxy links instead.
- **Ambient background**: `shaders/ambient.frag` is painted by `RpAmbientBackgroundWidget`. A ticker drives a `ChangeNotifier` that is used as the painter's `repaint`, so frames repaint without rebuilding widgets. Repaints are throttled to about 30 fps while idle. Shader uniforms are set in order in `_AmbientPainter.paint`, so the order must match the `uniform` declarations in the `.frag` file.
- **Analytics**: `lib/core/analytics/` uses a conditional import (`analytics_stub.dart` / `analytics_web.dart`). It's a no-op unless `GA_MEASUREMENT_ID` is passed with `--dart-define`.

## Accessibility (`packages/a11y_kit`)

Accessibility primitives live in the local `a11y_kit` package, with its own README and tests. The decision log is in `a11y.md`, written in Portuguese. Conventions used across the app:

- Use `A11yTappable` for custom links and buttons; on web it produces a real `<a href>`, plus focus ring and Enter/Space. Headings use `A11yHeading` or `A11ySelectableText(headingLevel:)`: one `<h1>` per page, `<h2>` per section.
- Gate every animation on `context.reduceMotion` / `context.motionDuration(...)`. Read them in `didChangeDependencies`, not `initState`, so toggling the setting mid-visit still applies.
- Content that's hidden until it's scrolled into view must stay in the semantics tree (`alwaysIncludeSemantics: true`).
- Decorative glyphs (`[01]`, `↗`, `“`, progress bars) are wrapped in `ExcludeSemantics`.
- `A11y.ensureInitialized()` in `main()` keeps web semantics always on and blocks the default navigation of semantic `<a>` links.

## Assets

- Gallery images are WebP (`assets/images/photos/`).
- The fonts in `assets/fonts/*.ttf` are **generated subsets**. Edit or replace the originals in `assets/fonts/source/` (not bundled), then rerun `tool/subset_fonts.py`; never edit the subsets directly. The script pins Inter's `opsz` axis because the app only varies `wght`.

## Tests

Widget tests use `test/helpers/pump_app.dart`, which wraps the widget in the app's theme and localizations so `context.rpColors` and `AppLocalizations.of(context)` work. Accessibility checks use `expectMeetsA11yGuidelines` from `package:a11y_kit/testing.dart`.

## Lints

The project uses `flutter_lints` 6 plus these rules: `require_trailing_commas`, `prefer_single_quotes`, `always_declare_return_types`, and the `prefer_const_*` rules.
