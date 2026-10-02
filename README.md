# Roni Paschoal — Personal Website

Personal website and portfolio built with Flutter, live at [ronipaschoal.com.br](https://ronipaschoal.com.br/) — presenting a bio, a project gallery, contact info, and an interactive on-screen résumé with PDF export, deployed automatically via CI/CD.

🟢 Live in production

Unlike a study lab, this project runs in production and is maintained and updated continuously as new content and improvements come in.

## 📱 About the project

The site is a single-page personal portfolio (`/`) plus a dedicated résumé page (`/cv`), both available in Portuguese and English.

Currently, the project includes:

- **Home** (single scrollable page, section-based navigation)
  - Ambient background drawn by a fragment shader (drifting brand glow, scroll-parallaxed dot grid, cursor spotlight, grain)
  - Hero with an "open to work" status, positioning headline, career figures and a logo-to-watermark scroll transition
  - Philosophy quote band whose words light up as it scrolls through the viewport
  - About section: lead statement, bento grid of quick facts (experience, stacks, tools, "Now"), and a career timeline built from the résumé data
  - Programs gallery that pins to the viewport and scrubs sideways with scroll
  - Contact section with a large mailto CTA, copy-to-clipboard email, and a footer with a hand-written signature and the live build hash
  - Command palette (⌘K / Ctrl+K) to jump to sections, open the résumé, copy the email, switch theme/language
  - Scroll progress bar; section titles decode in from scrambled characters
  - Side menu (Drawer) on small screens
  - Locale switcher (PT-BR / EN-US)
  - Light/dark theme toggle, defaulting to the system/browser preference and remembered across visits
  - Page chrome (app bar, scrollbar, background) spans the window; content is capped to a 1200px column
- **Résumé** (`/cv`)
  - On-screen résumé: contact, skills, languages, age, experience, projects, certifications, education
  - PDF download in two layouts, both built from the same content as the on-screen version: **modern** (two columns, like the page) and **classic** (one column in the conventional Brazilian order — objective, summary, education, experience grouped by company with one bullet per achievement, courses, additional info — in plain black type)
  - Also reachable as a dismissible overlay dialog from the home menu, without leaving the page
- **SEO** — real path URLs (`/cv`) instead of hash URLs, meta tags, a sitemap, and the résumé injected as hidden plain HTML into `index.html` at build time for crawlers and link previews that don't run Flutter

New sections and improvements are added as the site evolves.

## 🖼️ Screenshots

TODO: add screenshots of Home and the Résumé page (light/dark, PT/EN).

## 🏗️ Architecture

This is a static content site with no backend, so there's no data layer to abstract behind repositories — unlike a project such as [rppay](https://github.com/ronipaschoal/rppay), an MVVM+repository stack would be more structure than the content actually needs here.

Instead, the structure favors separation by page/route (`home/`, `cv/`), with a handful of cross-cutting layers (`models/`, `core/`, `widgets/`) shared across pages, and Cubit/BLoC reserved for the few pieces of state that actually change at runtime — the current locale, the light/dark theme, and the currently active menu section — rather than for content, which is static and lives directly in the code.

Some principles are still applied where they make sense for this shape of app:

- **Single Responsibility** — sections/widgets only build UI, cubits only hold a small piece of state, model classes only structure data.
- **Locale-aware content, not locale-aware UI copy** — fixed UI strings (buttons, section titles) go through ARB-based `AppLocalizations`; per-record content (résumé entries, work items) carries one value per language code directly on the model instead, matching the shape a real content source (CMS/database) would return per locale.
- **Shared page composition** — page transitions, breakpoint checks, and link handling live once in `core/`, not duplicated per page.
- **Theme via `ThemeExtension`, not global state** — light/dark colors are read through `Theme.of(context)` (`context.rpColors`), so a theme change propagates only to the widgets that actually read it, the same way any other Flutter theme change does.

### State management

State management is handled using:

- BLoC
- Cubit

Two small Cubits exist today:

- `AppCubit` — the app-wide current locale and light/dark theme (persisted via `shared_preferences`, defaulting to the system/browser brightness on first visit).
- `HomeCubit` — which menu/section is currently active, used to highlight the nav item in sync with scrolling.

Everything else on the page is either stateless or owned by a local `ScrollController`/`AnimationController`, since most of the UI here is driven by scroll position rather than by data that changes over time.

## 📂 Project structure

```
lib/
├── app/                                       # 🧭 App-level routing
│   ├── routes.dart                            # App's route table (GoRouter)
│   └── routes_helper.dart                     # Shared page-transition builder
│
├── core/                                      # 🎨 Cross-cutting design system + utilities
│   ├── analytics/                             # Google Analytics 4 (web only, opt-in via --dart-define)
│   ├── theme.dart                             # RpColors (ThemeExtension), text styles, spacing, content width
│   ├── profile.dart                           # Personal figures/flags (years, open-to-work, source URL, build hash)
│   ├── hyperlink_helper.dart                  # Opens external links / mailto
│   └── media_query_helper.dart                # Small-screen/breakpoint extension on BuildContext
│
├── cubits/
│   └── app/
│       ├── app_cubit.dart                     # App-wide state (locale, theme)
│       └── app_state.dart                     # App state
│
├── l10n/                                      # 🌐 Fixed UI copy (ARB), generated AppLocalizations
│
├── models/                                    # 📦 Shared, page-agnostic data models
│   ├── cv_item_model.dart                     # Résumé entry models (experience, education, ...)
│   ├── home_menu_model.dart                   # Home navigation menu items/sections
│   ├── locale_model.dart                      # Supported locales
│   ├── localized_map.dart                     # Shared per-language-map fallback resolution
│   └── work_item_model.dart                   # Work-gallery project entries
│
├── pages/                                     # 📄 App pages, one folder per route
│   │
│   ├── home/                                  # 🏠 Home ("/") — single page, section-based
│   │   ├── cubit/
│   │   │   ├── home_cubit.dart                # Active section tracking
│   │   │   └── home_state.dart                # Home state
│   │   │
│   │   ├── sections/
│   │   │   ├── home_section.dart              # Hero
│   │   │   ├── about_section.dart             # About me
│   │   │   ├── work_gallery_section.dart      # "Programs" / project gallery
│   │   │   └── contact_section.dart           # Contact
│   │   │
│   │   ├── widgets/                           # Menu, drawer, section title/shell, ...
│   │   ├── home_route.dart                    # GoRoute registration
│   │   └── home_screen.dart                   # Page scaffold
│   │
│   └── cv/                                    # 📄 Résumé ("/cv")
│       ├── cv_data.dart                       # Résumé content (shared by screen, PDF and SEO HTML)
│       ├── cv_content_widget.dart             # On-screen résumé layout
│       ├── cv_dialog_widget.dart              # Résumé opened as an overlay dialog
│       ├── cv_pdf_builder.dart                # Builds/shares the résumé PDF (modern layout + layout switch)
│       ├── cv_pdf_classic_builder.dart        # Classic single-column PDF layout
│       ├── cv_pdf_layout.dart                 # The PDF layout enum (kept apart from the deferred builder)
│       ├── cv_download_button.dart            # Download menu offering both layouts; loads the PDF builder on demand
│       ├── cv_route.dart                      # GoRoute registration
│       └── cv_screen.dart                     # Full-page résumé screen
│
├── widgets/                                   # 🧩 Shared, reusable widgets
│   ├── ambient_background_widget.dart         # Paints shaders/ambient.frag behind the page
│   ├── command_palette_widget.dart            # ⌘K / Ctrl+K command palette
│   ├── signature_widget.dart                  # Hand-written name "written" on reveal
│   ├── rp_app_bar.dart                        # Site-standard AppBar chrome (optionally column-aligned)
│   ├── scroll_progress_mixin.dart             # Shared "0..1 progress from a ScrollController" logic
│   ├── scroll_reveal_mixin.dart               # Shared "reveal once scrolled into view" logic
│   └── ...                                    # Logo, banner, decode text, locale/theme buttons, ...
│
└── main.dart                                  # 🎬 Application entry point

packages/
└── a11y_kit/                                  # ♿ Reusable accessibility kit (web, Android, iOS) — see its README

shaders/
└── ambient.frag                               # Fragment shader for the ambient background

assets/fonts/
├── *.ttf                                      # Bundled fonts — generated subsets, don't edit
└── source/                                    # Full original fonts (not bundled)

tool/
├── seo_content.dart                           # Injects the résumé as plain HTML into the built index.html
└── subset_fonts.py                            # Regenerates the font subsets from assets/fonts/source/

test/
├── a11y/                                      # Screen reader / keyboard / contrast checks
├── cubits/                                    # AppCubit/HomeCubit + their states
├── models/                                    # Résumé/work-item localization fallback logic
├── pages/                                     # Page-scoped widget tests (incl. notched-phone layout, PDF builders)
├── widgets/                                   # Shared-widget tests
└── helpers/                                   # pump_app.dart — shared MaterialApp test harness
```

### Layer organization

- `app/` — routing setup (GoRouter) and the shared page-transition builder.
- `core/` — the shared design system (`RpColors`/`RpTheme`) plus small stateless utilities used across pages (links, breakpoints).
- `cubits/app/` — app-wide state that isn't tied to a single page (the active locale and light/dark theme).
- `l10n/` — fixed UI copy, generated by `flutter gen-l10n` from the ARB files.
- `models/` — plain data classes shared across pages. Per-record content carries one value per locale on the model itself, rather than going through ARB.
- `pages/<page>/` — one folder per route, holding only what that page needs: its own `cubit/` (if it has runtime state), `sections/`/`widgets/`, its GoRoute registration, and its screen.
- `widgets/` — reusable widgets shared across every page (reveal-on-scroll, decode text, scroll progress, logo transition, the site's `AppBar`).

This organization favors keeping each page self-contained while sharing only what genuinely cuts across pages, without imposing a data-layer abstraction the app doesn't need.

## 🛠️ Technologies

| Technology | Usage |
| --- | --- |
| Flutter | Main framework |
| Dart | Language |
| go_router | Declarative routing |
| flutter_bloc / Cubit | State management |
| flutter_localizations / intl | Internationalization (PT-BR / EN-US) |
| flutter_svg | SVG icon rendering |
| url_launcher | Opening external links / mailto |
| pdf / printing | Résumé PDF export and direct download |
| shared_preferences | Persisting the light/dark theme preference across visits |
| web (package:web) | Browser APIs for the web-only bits (analytics, a11y link guard) |
| Google Analytics 4 | Page views and résumé downloads, web build only |
| WebAssembly (skwasm) | Production web renderer, with the JS build as automatic fallback |
| a11y_kit (local package) | Accessible links/buttons, headings, reduce motion, announcements, Flutter Web semantics fixes |
| Fragment shaders (`FragmentProgram`) | Ambient page background |
| Space Grotesk · Inter · IBM Plex Mono · Inkburrow | Headings · body · labels · signature (Space Grotesk under OFL, `assets/fonts/SpaceGrotesk-OFL.txt`), bundled as Latin subsets via `fontTools` |
| Claude Code | Development support with AI |
| Dart/Flutter MCP | Claude Code plugin (`dart-flutter`) providing analysis, hot reload/restart, LSP, and runtime error inspection tools |

Flutter: 3.44.0

## 🤖 Artificial Intelligence

Artificial Intelligence is part of this project's development process.

Claude Code was used as a support tool during development — for implementation, refactoring, and exploring alternatives — while decisions about architecture, content, and design stayed with me.

TODO: document notable examples of AI usage and decisions made during development.

## 🚀 Getting started

### Prerequisites

- Flutter installed (this project is pinned to 3.44.0 via `.fvmrc`/FVM)
- Dart SDK compatible with the Flutter version used
- Chrome (or another target device), since this is primarily a web project

### Running the project

Clone the repository:

```
git clone https://github.com/ronipaschoal/ronip.git
```

Go to the directory:

```
cd ronip
```

Install dependencies:

```
flutter pub get
```

Run the app:

```
flutter run -d chrome
```

`flutter gen-l10n` runs automatically on `pub get`/build thanks to `generate: true` in `pubspec.yaml` — no separate step is normally needed after editing the ARB files under `lib/l10n/`.

### Fonts

The bundled fonts are subsets covering Latin, common punctuation, arrows, box drawing and every non-ASCII character found in `lib/`. If new copy adds characters outside that set, regenerate them from the originals in `assets/fonts/source/`:

```
pip install fonttools
python3 tool/subset_fonts.py
```

### Dart/Flutter MCP (optional, for Claude Code)

This project can be assisted by the Dart/Flutter MCP server via the `dart-flutter` Claude Code plugin, which provides tools for analysis, hot reload/restart, LSP, pub, and runtime error inspection. It is installed at the user scope (not committed to this repo). To install it:

```
claude plugin install dart-flutter@dart-flutter
```

Check it's connected with:

```
claude mcp list
```

## 🧪 Tests

Unit tests cover the pieces of logic that don't require a running widget tree:

- `test/models/` — per-language content fallback (`LocalizedMap.resolve` and the résumé/work-item models built on it, e.g. `CvExperienceItem.roleFor`), plus the supported-locale mapping (`LocaleEnum`).
- `test/cubits/` — `AppCubit` (locale/theme changes, persisting and reloading the light/dark preference via a mocked `SharedPreferences`) and `HomeCubit` (active-section tracking), including their `AppState`/`HomeState` value equality.

Widget tests pump real widgets through `WidgetTester`, via the shared `test/helpers/pump_app.dart` harness (the app's theme + localizations, so anything reading `context.rpColors` or `AppLocalizations.of(context)` behaves as it does at runtime):

- `test/widgets/` — `ThemeButtonWidget`/`LocaleButtonWidget` (icon/label reflects the current theme/locale, tapping fires the callback with the right value), `RpAppBar` (menu color; with `maxContentWidth`, spans the window while aligning its content to the column), `RpScrollProgressWidget` (bar width tracks scroll position), `RpRevealOnScrollWidget` (child stays hidden until scrolled near the viewport, then fades in), `RpCommandPaletteWidget` (search filtering, arrow-key selection, Enter runs the command).
- `test/pages/` — `HomeMenuButtonWidget` (label recolors once `HomeCubit` marks its section active), `AboutSection` (bento tiles in a row share one height), `ContactSection` (copy email hits the clipboard and confirms), `HomeScreen` on a simulated notched phone (hero scroll cue inside the visible area; pinned gallery cards fill the band between title and progress), and the PDF export (roles grouped by employer for the classic layout, descriptions split into bullets, a PDF built in each language).
- `test/a11y/` — section titles as `<h2>` headings, decode text jumping to its final state when reduce motion is switched on mid-visit, the gallery's projects all exposed as links (including cards scrubbed off-screen), and the résumé (an `<h1>`, links, and `expectMeetsA11yGuidelines` from `a11y_kit`: labels, contrast, 48/44px tap targets, no unlabelled text fields).

The accessibility primitives themselves (`A11yTappable`, headings, announcements, the web link guard, …) are tested inside `packages/a11y_kit/` — `flutter test` there, plus `flutter test --platform chrome test/link_guard_web_test.dart` for the DOM guard.

Run the suite with:

```
flutter test
```

A single file or test:

```
flutter test test/widgets/reveal_on_scroll_widget_test.dart
flutter test --plain-name 'reveals its child only once scrolled'
```

Integration tests aren't in place yet — see the roadmap below.

## 🔄 CI/CD

A GitHub Actions workflow (`.github/workflows/main.yaml`) runs on every push/PR to `main` (and on manual runs):

1. **Check** — `flutter analyze`, then the app's tests and `packages/a11y_kit`'s tests; any failure stops the pipeline.
2. **Build** — `flutter build web --release --wasm`, passing `GIT_SHA` (the hash shown in the site footer) and `GA_MEASUREMENT_ID` via `--dart-define`. Browsers with WasmGC get the WebAssembly build; the rest fall back to the JS build shipped alongside it.
3. **SEO** — `dart run tool/seo_content.dart` writes the résumé as hidden plain HTML into the built `index.html`.
4. **Deploy** — on a push to `main` or a manual run (never on a pull request), the build (including `web/.htaccess`, which serves `index.html` for path URLs and sets the `.wasm` MIME type) is synced via FTP to the production host.

## ♿ Accessibility

The accessibility building blocks live in a local package, [`packages/a11y_kit`](packages/a11y_kit/), built to be reused across Flutter projects on web, Android and iOS. The site uses it like this:

- **Semantics always on (web)** — `A11y.ensureInitialized()`, so screen readers don't land on an empty page behind Flutter's hidden "Enable accessibility" button; it also stops semantic `<a href>` links from navigating the tab away on top of opening a new one.
- **Language** — `A11yLocale.appBuilder` gives the semantics tree the app's locale (`pt`/`en`), not the device/browser's, so voices match the copy; Portuguese-only résumé entries are tagged `pt` even in English.
- **Structure** — one `<h1>`, `<h2>` per section, `<h3>` for sub-sections/companies (`A11yHeading`); the résumé's columns are read whole (`A11yReadingGroup`); decorative glyphs (`[01]`, `/`, `“`, `↗`) are excluded; content hidden until scrolled into view stays in the tree; uppercase labels are read in natural case (`A11yCapsText`).
- **Links and keyboard** — custom links/buttons go through `A11yTappable` (Tab-focusable, Enter/Space, visible focus ring, real `<a href>` on web); small icon links get a 48×48 target.
- **Gallery** — its cards get translated off-screen, so keyboard/screen-reader users go through always-present semantic proxies (`A11yPointerPassThrough` lets clicks reach the cards underneath); focusing one scrubs the gallery to that card.
- **Announcements** — "Copied" is spoken on web/iOS (`A11yAnnouncer`) and through a live region on Android, which deprecated announcements.
- **Contrast** — `RpColors.accentTextColor` is the brand hue tuned to WCAG AA for small text and focus rings (wired in as `A11yTheme.focusColor`); the raw brand color is kept for large type and decoration.
- **Motion** — every animation honors the platform's reduce-motion setting through `context.reduceMotion`, and reacts if it's switched on while the page is open.

## 🌐 API and data

The project runs entirely client-side, with no backend or external API (apart from the optional Google Analytics tag on the web build). Personal and résumé content lives directly in the codebase (model classes and page-level data files like `cv_data.dart`), rather than being fetched from a remote source.

## 💡 Technical decisions

TODO: document the main architectural and technical decisions made during development.

Some points that may be documented in the future:

- Why content stays in code instead of a CMS/API for a personal site this size
- Locale strategy: ARB for fixed UI copy vs. per-record locale maps for content
- The scroll-driven animation approach (reveal-on-scroll, decode text, logo transition, pinned gallery)
- The fragment-shader background and its reduced-motion fallback
- Sharing résumé content between the on-screen view and the PDF export
- The CI/CD deploy pipeline (GitHub Actions + FTP)
- Web load-size choices: deferred PDF code, WebP images, subset fonts, the Wasm build

## 🗺️ Roadmap

- [ ] Add screenshots to this README
- [x] Add unit tests
- [x] Add widget tests
- [ ] Add integration tests
- [ ] Document architectural decisions
- [ ] Document AI usage
- [ ] Add new sections/content as the portfolio evolves
- [ ] Improve test coverage

## 📚 Study goal

Beyond being a live, production personal site, this project is also where I explore, in practice:

- Application development with Flutter for the web
- State management with BLoC/Cubit
- Internationalization (PT-BR / EN-US)
- Light/dark theming with a persisted user preference
- Scroll-driven animation and custom widget composition
- Shared content between an on-screen view and a generated PDF
- CI/CD for a Flutter web app (GitHub Actions)
- Use of Artificial Intelligence in software development

## 📌 Status

Live in production 🟢

Maintained and updated continuously as new content, sections, and improvements are added.

## 👨‍💻 Author

**Roni Paschoal**

Software Developer with experience building applications using Flutter and other software development technologies.

[GitHub](https://github.com/ronipaschoal)

[LinkedIn](https://www.linkedin.com/in/roni-paschoal/)
