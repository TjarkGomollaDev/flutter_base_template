---
paths:
  - "**/*.dart"
---

# Dart Code Conventions

When editing or creating any Dart file in this repository:

1. **Architecture & Imports:**
   - `lib/3rd_layer_domain/`: 100% pure Dart. Never import Flutter, Dio, GoRouter, SharedPreferences, GetIt, or presentation/application/infrastructure layers.
   - `lib/2nd_layer_application/`: Never import presentation, infrastructure, Dio, or `package:flutter/{material,cupertino,widgets}.dart`.
   - `lib/1st_layer_presentation/`: Never import infrastructure or Dio. Never use raw `Color(...)`, `Colors.*`, `CupertinoColors.*`, or `BoxShadow(...)`. Use `context.colorPalette`, `context.shadowPalette`, `context.textTheme`, or `AppTheme`. Call `context.colorPalette.*`, `context.shadowPalette.*`, `context.textTheme.*`, and `context.l10n.*` directly inline in `build()` without local alias variables (`final colorPalette = ...`, `final l10n = ...`, `final themeData = ...`). Use `Key('<screen>_<element>')` for testable UI.
   - Outside `lib/core/network/`, never instantiate `Dio(` directly; use `ApiClient`.

2. **Comments:**
   - Where knowledge belongs: local non-obvious WHY -> short code comment; cross-file flow, architectural decision, or learning -> OKF concept in `docs/` (`docs/meta/conventions.md`); what changed -> commit/PR; else -> nowhere.
   - Only document WHY, never WHAT.
   - Decorative banners are forbidden everywhere except unified `// #### <UPPERCASE SECTION> ####` headers in root `lib/app_*.dart` files.
   - Ban prose em-dashes (`—` and ` -- `).
   - `///` doc comments are ONLY allowed in `lib/3rd_layer_domain/`, `lib/core/`, and `lib/1st_layer_presentation/core_widgets/`. Everywhere else use `//`.
   - Max 2 lines for `//` blocks; max 4 lines for `///` blocks.
   - English, capitalized first letter (A-Z), trailing punctuation (`.`, `?`, `:`, `)`, `]`, or URL).
   - Allowed tags: `TODO:`, `WORKAROUND:`, `SECURITY:`, `PERF:`.
   - Document all `// ignore:` lines with a preceding WHY comment. Escape hatches require `// convention-ignore: <rule> <reason>`.

3. **Tests (`test/**/*_test.dart`):**
   - Test real logic and decisions only.
   - Single-line test description `<= 100` characters, no newlines.
   - No layout finders (`find.byType(Padding|Container|SizedBox|Column|Row|Center|...)`).
   - No unmanaged real waits (`Future.delayed`, `sleep`).
   - Must have non-trivial assertions (`expect`, `expectLater`, `verify`). Trivial matchers (`isNotNull`, `returnsNormally`, untyped `isA()`) alone are forbidden.
