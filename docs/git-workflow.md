# Git Workflow & Standards

This specification defines the Git branch, commit, pull request, and CI automation standards for all repositories created from this template. These rules are enforced locally via Git hooks and in CI via GitHub Actions.

---

## 1. Commit & PR Title Convention

All commits and Pull Request titles must follow the strict Conventional Commits standard:

```text
<type>(<optional-scope>)!: <lowercase-start imperative description>
```

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
- Must begin with a lowercase letter immediately following `: ` (proper class/symbol names like `ThemeBloc` are permitted inside the message).
- Written in the imperative mood (*"add"*, not *"added"* or *"adds"*).
- Maximum **100 characters** total.
- **No trailing period** (`.`).
- Optional scope must be lowercase alphanumeric with hyphens or underscores (e.g. `feat(auth): ...`, `fix(theme): ...`).
- Optional breaking change indicator `!` before the colon (e.g. `feat(api)!: migrate to rest v2`).

### Examples
- `feat(theme): add dark mode toggle button`
- `fix: await ThemeBloc persistence before emit`
- `refactor(routing): extract instance-scoped AppRouter`
- `docs: update Clean Architecture layering guide`
- `ci: add PR title verification step`

---

## 2. Branch Naming Standard

All feature branches must follow this strict naming pattern:

```text
<type>/<kebab-case-summary>
```

- Regex: `^(feat|fix|refactor|docs|test|chore|ci)/[a-z0-9]+(-[a-z0-9]+)*$`
- Examples: `feat/user-onboarding`, `fix/theme-race-condition`, `chore/upgrade-dio`
- **Direct commits to `main` (or `master`) are blocked** by the pre-commit hook and repository rules. Always work on a branch.

---

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
   - Runs `dart format` on staged `.dart` files.
   - Runs `tool/check_conventions.dart` (validating comments, testing rules, and Clean Architecture layering) against the staged snapshot.
2. **`commit-msg` (< 50ms):**
   - Validates that the commit message conforms to the Conventional Commits regex.
   - Permits standard Git auto-generated messages (such as merge commits, cherry-picks, and `fixup!`).
3. **`pre-push`:**
   - Runs `flutter analyze --fatal-infos`.
   - Runs `flutter test --no-pub --reporter compact`.

> [!CAUTION]
> Never bypass Git hooks using `--no-verify` or `-n`. Bypassed commits will fail CI.

---

## 4. GitHub Actions & Pull Request Automation

### Continuous Integration (`.github/workflows/ci.yml`)
Runs on every push to `main` and on pull requests targeting `main`. Utilizes cached dependencies and verifies:
1. `flutter pub get`
2. `flutter gen-l10n` (ensuring generated ARB files are up to date and match `git diff`)
3. `dart format --output=none --set-exit-if-changed lib test tool`
4. `flutter analyze --fatal-infos`
5. `dart run tool/check_conventions.dart` (comment, test, and architecture rules)
6. `flutter test --coverage`

### PR Automation (`.github/workflows/pr-automation.yml`)
Runs with zero-checkout isolation on pull request events:
- Validates the PR branch name and PR title against Conventional Commits.
- Automatically assigns GitHub labels based on changed files and PR size.

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
