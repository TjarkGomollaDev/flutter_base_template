# CRITICAL RULES — MUST FOLLOW

## Working in this Repo
- Clarify ambiguous requirements before implementing; never assume design, features, or new dependencies.
- Follow the existing patterns of the affected layer before introducing new ones.
- Ship code, tests, and docs together: update tests and the OKF bundle in the same change.

## Verification Commands
Hooks already format and convention-check every edited Dart file, so don't run these after each small edit.
Run the full set only before committing or pushing, at the end of a larger multi-file task, or when asked.
Exception: run `flutter gen-l10n` right after changing `.arb` files.

| Task | Command | Purpose |
| --- | --- | --- |
| **Install Dependencies** | `flutter pub get` | Installs Flutter and Dart packages |
| **Generate Localization** | `flutter gen-l10n` | Recompiles `.arb` files to Dart classes |
| **Format Code** | `dart format lib test tool` | Enforces standard Dart formatting |
| **Analyze Code** | `flutter analyze --fatal-infos` | Runs strict Dart analysis with zero warnings |
| **Check Conventions** | `sh tool/run_compiled.sh check_conventions` | Validates Clean Architecture, comment rules, and test conventions |
| **Run Tests** | `flutter test` | Executes all unit, BLoC, and headless app-flow tests |

## Mandatory Documentation Routing (Read Before Acting)
Read the relevant documentation before making decisions or editing code in that area:
- Architecture, 4-layer rules, BLoC, DI, routing, l10n & UI test keys: [guidelines/ARCHITECTURE.md](guidelines/ARCHITECTURE.md)
- Design handoff & Flutter theme token mapping: [design/README.md](design/README.md)
- Code comment rules, `///` restrictions & where knowledge belongs: [guidelines/CODE_COMMENTS.md](guidelines/CODE_COMMENTS.md)
- Testing philosophy, UI finders & test rules: [guidelines/TESTING.md](guidelines/TESTING.md)
- Branch, commit, PR naming (incl. Issue ID), labels & hooks: [guidelines/GIT_WORKFLOW.md](guidelines/GIT_WORKFLOW.md)
- Project knowledge bundle (OKF): [docs/index.md](docs/index.md) & [docs/meta/conventions.md](docs/meta/conventions.md) — read before changing domain/feature behavior and update in the same PR. Never clutter `README.md`, `AGENTS.md`, `design/README.md`, or `guidelines/*.md` with app-specific feature notes.
