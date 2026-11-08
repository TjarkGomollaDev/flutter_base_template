---
name: template-conventions
description: Imperative Clean Architecture, Comment, Test, and Multi-Harness conventions for Flutter Base Template.
keep-coding-instructions: true
---

# Flutter Base Template Conventions

Always follow these imperative conventions across all planning, coding, and review steps:

## 1. Clean Architecture & Layering
- **Layer 1 (Presentation - `lib/1st_layer_presentation/`):**
  - UI only (Widgets, Pages, Screens).
  - Never import `4th_layer_infrastructure` or `package:dio`.
  - Zero raw colors or shadows: never use `Color(...)`, `Colors.*`, `CupertinoColors.*`, or `BoxShadow(...)`.
  - Consume tokens exclusively via `context.colorPalette`, `context.shadowPalette`, `context.textTheme`, or `AppTheme`.
  - Call `context.colorPalette.*`, `context.shadowPalette.*`, `context.textTheme.*`, and `context.l10n.*` directly inline in `build()` without local alias variables (`final colorPalette = ...`, `final l10n = ...`, `final themeData = ...`).
  - Use `Key('<screen>_<element>')` on all interactive and testable widgets.
- **Layer 2 (Application - `lib/2nd_layer_application/`):**
  - BLoC/Cubit state management only.
  - Never import `1st_layer_presentation`, `4th_layer_infrastructure`, `package:dio`, or `package:flutter/{material,cupertino,widgets}.dart`.
  - Keep app-wide BLoCs under `application/` and feature BLoCs under `<feature>/`.
- **Layer 3 (Domain - `lib/3rd_layer_domain/`):**
  - 100% pure Dart.
  - Never import Flutter (`package:flutter/*`), Dio, GoRouter, SharedPreferences, GetIt, or layers 1, 2, 4.
  - Entities, value objects, domain failures, and repository interfaces only.
- **Layer 4 (Infrastructure - `lib/4th_layer_infrastructure/`):**
  - Data sources, repository implementations, and external platform adapters.
- **Core Network (`lib/core/network/`):**
  - Direct `Dio(` instantiation is only permitted inside `lib/core/network/`. All other code uses `ApiClient`.

## 2. Code Comments
- **Where knowledge belongs:** Local non-obvious WHY -> short code comment; cross-file flow, architectural decision, or learning -> OKF concept in `docs/` (`docs/meta/conventions.md`); what changed -> commit/PR; else -> nowhere.
- **WHY-only:** Explain only non-obvious invariants, platform/SDK quirks, or workarounds. Never rephrase code or document what code does.
- **No decorative banners:** Decorative banners are forbidden everywhere except unified `// #### <UPPERCASE SECTION> ####` headers in root `lib/app_*.dart` files.
- **No prose em-dashes:** Never use `—` or ` -- ` in comments (CLI flags like `--dart-define` are allowed).
- **Doc comment (///) whitelist:** `///` is permitted exclusively in `lib/3rd_layer_domain/`, `lib/core/`, and `lib/1st_layer_presentation/core_widgets/`. Everywhere else, use `//`.
- **Length limits:** Max 2 lines for `//` prose blocks; max 4 lines for `///` blocks.
- **Sentence style:** Every comment paragraph must be in English, start with a capital letter (A-Z), and end with `.`, `?`, `:`, or a URL.
- **Tags & ignores:** Only `TODO:`, `WORKAROUND:`, `SECURITY:`, and `PERF:` tags are permitted. Every `// ignore:` and `// ignore_for_file:` must have a preceding WHY comment. Escape hatches require `// convention-ignore: <rule> <reason>`.

## 3. Testing
- **Test real decisions:** Only test branching, state transitions, validation, and navigation. Do not test trivial getters, props, or constants.
- **Stable UI finders:** Address widgets via `Key('<screen>_<element>')`, unique icons, or `Semantics`. Never find widgets by layout type (`Padding`, `Container`, `SizedBox`, `Column`, `Row`, `Center`).
- **No real waits:** Never use `Future.delayed` or `sleep` in tests unless inside `runAsync`/`fakeAsync` or exempted with `// convention-ignore: no_real_waits <reason>`.
- **Test naming:** Single line description `<= 100` characters, no embedded newlines.
- **Assertions:** Every test must contain meaningful assertions (`expect`, `expectLater`, `verify`). Trivial assertions like `isNotNull` or untyped `isA()` alone are forbidden.

## 4. Git Workflow
- Branches: `^(feat|fix|refactor|docs|test|chore|ci)/([0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*$` (include `<issue-id>-` when a GitHub Issue exists).
- Commits & PRs: `^(feat|fix|refactor|docs|test|chore|ci)(\([a-z0-9_-]+\))?!?: (#[0-9]+ )?[a-z].*[^. ]$` (include `#<issue-id> ` when a GitHub Issue exists, max 100 chars).
- Never commit directly to `main` or `master`. Never use `--no-verify`.
- `README.md`, `AGENTS.md`, `design/README.md`, and `guidelines/*.md` are static template files and must never be cluttered with app feature notes.

## 5. Documentation & Markdown Hygiene
- Standalone horizontal rule dividers (`---`, `***`, `___`) are strictly forbidden across all Markdown files. Structure content cleanly using Markdown headings (`#`, `##`, `###`). The only permitted `---` lines are YAML frontmatter delimiters at the top of concept files.
