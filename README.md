# Roni Paschoal — Personal Website

Personal website and portfolio built with Flutter, live at [ronipaschoal.com.br](https://ronipaschoal.com.br/) — presenting a bio, a project gallery, contact info, and an interactive on-screen résumé with PDF export, deployed automatically via CI/CD.

🟢 Live in production

Unlike a study lab, this project runs in production and is maintained and updated continuously as new content and improvements come in.

## 📱 About the project

The site is a single-page personal portfolio (`/`) plus a dedicated résumé page (`/cv`), both available in Portuguese and English.

Currently, the project includes:

- **Home** (single scrollable page, section-based navigation)
  - Hero section with a scramble/decode-in text animation and a logo-to-watermark scroll transition
  - About section
  - Programs / project gallery
  - Contact section
  - Scroll progress bar
  - Side menu (Drawer) on small screens
  - Locale switcher (PT-BR / EN-US)
- **Résumé** (`/cv`)
  - On-screen résumé: contact, skills, languages, experience, projects, certifications, education
  - PDF export/print, built from the same content as the on-screen version
  - Also reachable as a dismissible overlay dialog from the home menu, without leaving the page

New sections and improvements are added as the site evolves.

## 🖼️ Screenshots

TODO: add screenshots of Home and the Résumé page (light/dark, PT/EN).

## 🏗️ Architecture

This is a static content site with no backend, so there's no data layer to abstract behind repositories — unlike a project such as [rppay](https://github.com/ronipaschoal/rppay), an MVVM+repository stack would be more structure than the content actually needs here.

Instead, the structure favors separation by page/route (`home/`, `cv/`), with a handful of cross-cutting layers (`model/`, `helpers/`, `ui/`) shared across pages, and Cubit/BLoC reserved for the few pieces of state that actually change at runtime — the current locale and the currently active menu section — rather than for content, which is static and lives directly in the code.

Some principles are still applied where they make sense for this shape of app:

- **Single Responsibility** — sections/widgets only build UI, cubits only hold a small piece of state, model classes only structure data.
- **Locale-aware content, not locale-aware UI copy** — fixed UI strings (buttons, section titles) go through ARB-based `AppLocalizations`; per-record content (résumé entries, work items) carries one value per language code directly on the model instead, matching the shape a real content source (CMS/database) would return per locale.
- **Shared page composition** — page transitions, breakpoint checks, and link handling live once in `helpers/`, not duplicated per page.

### State management

State management is handled using:

- BLoC
- Cubit

Two small, page-scoped Cubits exist today:

- `AppCubit` — the app-wide current locale.
- `HomeCubit` — which menu/section is currently active, used to highlight the nav item in sync with scrolling.

Everything else on the page is either stateless or owned by a local `ScrollController`/`AnimationController`, since most of the UI here is driven by scroll position rather than by data that changes over time.

## 📂 Project structure

```
lib/
├── config/                                    # 🧭 Routing configuration
│   ├── navigate.dart                          # Thin GoRouter push/pop helpers
│   └── routes.dart                            # App's route table (GoRouter)
│
├── cubits/
│   └── app/
│       ├── app_cubit.dart                     # App-wide state (current locale)
│       └── app_state.dart                     # App state
│
├── helpers/
│   ├── hyperlink_helper.dart                  # Opens external links / mailto
│   ├── media_query_helper.dart                # Small-screen/breakpoint helpers
│   └── routes_helper.dart                     # Shared page-transition builder
│
├── l10n/                                      # 🌐 Fixed UI copy (ARB), generated AppLocalizations
│
├── model/                                     # 📦 Shared, page-agnostic data models
│   ├── cv_item_model.dart                     # Résumé entry models (experience, education, ...)
│   ├── home_menu_model.dart                   # Home navigation menu items/sections
│   ├── locale_model.dart                      # Supported locales
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
│       ├── cv_data.dart                       # Résumé content (shared by screen + PDF)
│       ├── cv_content_widget.dart             # On-screen résumé layout
│       ├── cv_dialog_widget.dart              # Résumé opened as an overlay dialog
│       ├── cv_pdf_builder.dart                # Builds/prints the résumé as a PDF
│       ├── cv_route.dart                      # GoRoute registration
│       └── cv_screen.dart                     # Full-page résumé screen
│
├── ui/                                        # 🎨 Shared design system
│   ├── theme.dart                             # Colors, text styles, spacing
│   └── widgets/                               # Scroll-driven animations, logo, banner, ...
│
└── main.dart                                  # 🎬 Application entry point
```

### Layer organization

- `config/` — routing setup (GoRouter) and navigation helpers.
- `cubits/app/` — app-wide state that isn't tied to a single page (currently just the active locale).
- `helpers/` — small stateless utilities shared across pages (links, breakpoints, page transitions).
- `l10n/` — fixed UI copy, generated by `flutter gen-l10n` from the ARB files.
- `model/` — plain data classes shared across pages. Per-record content carries one value per locale on the model itself, rather than going through ARB.
- `pages/<page>/` — one folder per route, holding only what that page needs: its own `cubit/` (if it has runtime state), `sections/`/`widgets/`, its GoRoute registration, and its screen.
- `ui/` — the shared design system: theme plus reusable scroll-driven animated widgets (reveal-on-scroll, decode text, scroll progress, logo transition) used across every page.

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
| pdf / printing | Résumé PDF export and print dialog |
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

TODO: add unit tests, widget tests, and/or integration tests.

## 🔄 CI/CD

A GitHub Actions workflow (`.github/workflows/main.yaml`) builds and deploys the site on every push/PR to `main`:

1. **Build** — `flutter build web --release`, uploaded as a build artifact.
2. **Deploy** — on push to `main`, the artifact is synced via FTP to the production host.

## 🌐 API and data

The project runs entirely client-side, with no backend or external API. Personal and résumé content lives directly in the codebase (model classes and page-level data files like `cv_data.dart`), rather than being fetched from a remote source.

## 💡 Technical decisions

TODO: document the main architectural and technical decisions made during development.

Some points that may be documented in the future:

- Why content stays in code instead of a CMS/API for a personal site this size
- Locale strategy: ARB for fixed UI copy vs. per-record locale maps for content
- The scroll-driven animation approach (reveal-on-scroll, decode text, logo transition)
- Sharing résumé content between the on-screen view and the PDF export
- The CI/CD deploy pipeline (GitHub Actions + FTP)

## 🗺️ Roadmap

- [ ] Add screenshots to this README
- [ ] Add unit tests
- [ ] Add widget tests
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
