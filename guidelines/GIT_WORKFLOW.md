# Git Workflow & Standards

This specification defines the Git branch, commit, pull request, and CI automation standards for all repositories created from this template. These rules are enforced locally via Git hooks and in CI via GitHub Actions.

## 1. Commit & PR Title Convention

All commits and Pull Request titles must follow the strict Conventional Commits standard:

```text
<type>(<optional-scope>)!: (#<issue-id> )?<lowercase-start imperative description>
```

- **Regex:** `^(feat|fix|refactor|docs|test|chore|ci)(\([a-z0-9_-]+\))?!?: (#[0-9]+ )?[a-z].*[^. ]$`
- **Issue ID Rule:** **When a corresponding GitHub Issue exists, include `#<issue-id> ` immediately after `: `** (e.g. `feat: #1 modernize base template`, `feat(auth): #12 add dark mode toggle`). When no issue exists, omit the issue prefix (e.g. `chore: bump dio dependency`).

### Allowed Types
| Type | Usage |
| --- | --- |
| `feat` | A new user-facing or architectural feature |
| `fix` | A bug fix |
| `refactor` | Code restructuring that neither fixes a bug nor adds a feature |
| `docs` | Documentation-only changes |
| `test` | Adding or updating tests without modifying production code |
| `chore` | Routine maintenance, dependency updates, or tool script changes |
| `ci` | Changes to CI workflows, PR automation, or Git hooks |

### Subject Rules
- Must begin with a lowercase letter immediately following `: ` or `:<space>#<issue-id><space>` (proper class/symbol names like `ThemeBloc` are permitted inside the message).
- Written in the imperative mood (*"add"*, not *"added"* or *"adds"*).
- Maximum **100 characters** total.
- **No trailing period** (`.`).
- Optional scope must be lowercase alphanumeric with hyphens or underscores (e.g. `feat(auth): ...`, `fix(theme): ...`).
- Optional breaking change indicator `!` before the colon (e.g. `feat(api)!: #8 migrate to rest v2`).

### Examples
- `feat: #1 modernize base template`
- `feat(auth): #12 add dark mode toggle`
- `fix: #42 await ThemeBloc persistence before emit`
- `refactor(routing): extract instance-scoped AppRouter`
- `chore: bump dio dependency`

## 2. Branch Naming Standard

All feature branches must follow this strict naming pattern:

```text
<type>/<issue-id>-<kebab-case-summary>   (when a GitHub Issue exists)
<type>/<kebab-case-summary>              (when no issue exists)
```

- **Regex:** `^(feat|fix|refactor|docs|test|chore|ci)/([0-9]+-)?[a-z0-9]+(-[a-z0-9]+)*$`
- **Examples:** `feat/1-update-base-template`, `fix/42-theme-race-condition`, `chore/upgrade-dio`
- **Direct commits to `main` (or `master`) are blocked** by the pre-commit hook and repository rules. Always work on a branch.

## 3. Automated Git Hooks (`.hooks/`)

This template includes zero-dependency POSIX Git hooks located in `.hooks/`.

### Installation
Run once after cloning or creating a new repository:
```bash
sh .hooks/setup.sh
```
This configures `core.hooksPath` to `.hooks` and sets executable permissions on all hook scripts.

### Hook Stages
1. **`pre-commit` (< 2s):**
   - Blocks direct commits to the `main` branch.
   - Runs `dart format` on staged `.dart` files and `tool/check_conventions.dart` (validating comments, testing rules, Clean Architecture layering, and Markdown divider hygiene) against staged `.dart` and `.md` files.
2. **`commit-msg` (< 50ms):**
   - Validates that the commit message conforms to the Conventional Commits regex.
   - Permits standard Git auto-generated messages (such as merge commits, cherry-picks, and `fixup!`).
3. **`pre-push`:**
   - Runs `flutter analyze --fatal-infos`.
   - Runs `flutter test --no-pub --reporter compact`.

> [!CAUTION]
> Never bypass Git hooks using `--no-verify` or `-n`. Bypassed commits will fail CI.

## 4. GitHub Actions & Pull Request Automation

### `CI` (`.github/workflows/ci.yml`)
Runs on every push to `main` and on pull requests targeting `main` with two jobs:
1. **`CI / Flutter`:**
   - `flutter pub get`
   - `flutter gen-l10n` (ensuring generated ARB files are up to date and match `git diff`)
   - `dart format --output=none --set-exit-if-changed lib test tool`
   - `flutter analyze --fatal-infos`
   - `dart run tool/check_conventions.dart` (comment, test, and architecture rules)
   - `flutter test --coverage`
2. **`CI / Docs`:**
   - Validates and lints the OKF knowledge bundle in `docs/` via `okf validate docs` and `okf lint docs --fail-on warn`.

### `PR / Check` (`.github/workflows/pr-check.yml`)
Runs on pull request events (`opened`, `edited`, `synchronize`, `reopened`) with minimal `contents: read` permissions:
- Validates branch name against the branch naming standard (including Dependabot branch format).
- Validates PR title length (max 100 characters) and Conventional Commits pattern (including optional `#<issue-id> ` prefix).

### `PR / Label` (`.github/workflows/pr-label.yml`)
Runs on pull request events (`opened`, `edited`, `synchronize`, `reopened`) with write permissions:
- Automatically assigns path and branch labels via `.github/labeler.yml` (including `guidelines/**` and `docs/**`).
- Computes and assigns PR size labels (`size: S|M|L`), excluding lockfiles and generated files.

### Label Taxonomy
New repositories created from this template can initialize all GitHub labels by running:
```bash
sh tool/setup_github_labels.sh
```

| Label Group | Labels | Description |
| --- | --- | --- |
| `type:*` | `type: feat`, `type: fix`, `type: refactor`, `type: docs`, `type: test`, `type: chore`, `type: ci` | Inferred from branch prefix / Dependabot config |
| `layer:*` | `layer: presentation`, `layer: application`, `layer: domain`, `layer: infrastructure` | Inferred from modified directory paths |
| `scope:*` | `scope: core`, `scope: l10n`, `scope: ai-tooling`, `scope: deps` | Inferred from changes in configuration, tooling, or translations |
| `size:*` | `size: S` (<= 100 lines), `size: M` (101–300 lines), `size: L` (> 300 lines) | Calculated from net line changes excluding lockfiles and generated code |
