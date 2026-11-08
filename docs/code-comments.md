# Code Comment Conventions

This specification defines the comment standards enforced across the repository. The rules are verified deterministically by `tool/src/comment_checker.dart` and checked in Git hooks and CI pipelines.

---

## 1. Core Rule: Non-Obvious "WHY" Only

- **Explain the WHY, never the WHAT:** Write a comment only when code needs context that cannot be expressed through clear variable, method, or class names. Explain platform quirks, non-obvious invariants, upstream bugs, workarounds, or why a standard alternative was deliberately rejected.
- **Do not restate identifiers:** Comments like `// Gets the items.` or `// Initializes the database.` are noise that drifts over time. Delete them.
- **No Git history in comments:** Never reference previous implementations, git commits, ticket IDs, or phrases such as *"previously this was"*, *"legacy fix"*, or *"author: name"*.

---

## 2. Zero Decorative Banners & Section Labels

- **Banned banner patterns:** Never use visual separators such as `// #### ... ####`, `// ===`, `// ---`, or `/* ****** */`.
- **Banned section labels:** Single-word labels or structural markers (e.g. `// theme`, `// getters`, `// properties`, `// dependencies`, `// lifecycle`) are strictly forbidden. Use file organization and code grouping instead.

---

## 3. Strict Rules for `///` Doc Comments

- **Default is NO `///` doc comments.**
- **Path Whitelist:** `///` doc comments are strictly prohibited outside the following three directories:
  1. `lib/3rd_layer_domain/`
  2. `lib/core/`
  3. `lib/1st_layer_presentation/core_widgets/`
- **Inside Whitelisted Paths:** Even inside these three directories, `///` is permitted only when communicating a non-obvious contract that cannot be inferred from type signatures:
  - Numerical units (e.g. milliseconds, pixels, degrees).
  - Specific string or date formats (e.g. ISO-8601 UTC).
  - `null` semantics (what a `null` return value represents).
  - Specific exceptions thrown and under what conditions.
  - Required preconditions or invocation order constraints.

---

## 4. Length, Grammar, and Formatting

- **Language:** English only.
- **Voice:** Present tense, direct and factual.
- **Line limits:**
  - `//` comment blocks: Maximum **2 prose lines** (aim for 1 concise sentence).
  - `///` doc comment blocks: Maximum **4 lines** (1 summary sentence, 1 blank doc line, max 2 contract lines).
- **Capitalization and punctuation:** Every comment block or paragraph must begin with an uppercase letter and terminate with a period `.` (unless the line ends with a URL or backtick code token).
- **No prose em-dashes:** Do not use `—` or ` -- ` as sentence punctuation. Standard CLI flags like `--dart-define` remain allowed.

---

## 5. Allowed Tags

Only four comment prefix tags are permitted in the codebase:
- `// TODO:` for pending follow-ups with a clear actionable description.
- `// WORKAROUND:` for temporary fixes around upstream library or platform bugs.
- `// SECURITY:` for critical security considerations or sanitize requirements.
- `// PERF:` for non-obvious performance optimizations.

All other custom tags (e.g. `// NOTE:`, `// Test anchor:`, `// HACK:`, `// FIXME:`) are rejected by the checker.

---

## 6. No Commented-Out Code & Mandatory Ignore Justifications

- **No commented-out code:** Do not commit commented-out code blocks or snippets. Rely on Git history for dead code.
- **Justified linter ignores:** Every `// ignore:` or `// ignore_for_file:` directive requires a 1–2 line explanation directly above it detailing why the lint cannot or should not be satisfied.
- **Bundle lints:** Bundle multiple ignores on a single line (e.g. `// ignore: avoid_catches_without_on_clauses, empty_catches`).

---

## Examples

### Example 1: Non-obvious invariant vs Restating the code

**Bad:**
```dart
// Sets the theme mode.
void setThemeMode(ThemeMode mode) {
  _themeMode = mode;
}
```

**Good:**
```dart
// Persisting before emit prevents UI flicker if local storage writes stall.
await _storage.saveThemeMode(mode);
emit(ThemeState(mode: mode));
```

### Example 2: Permitted doc comment vs Redundant doc comment

**Bad:**
```dart
/// The api client instance.
final ApiClient apiClient;
```

**Good (`lib/core/`):**
```dart
/// Executes an authenticated GET request.
///
/// Throws [ApiException] when the response status code falls outside 200..299.
Future<Response<T>> get<T>(String path);
```

### Example 3: Linter ignore justification

**Bad:**
```dart
// ignore_for_file: constant_identifier_names
const String APP_TITLE = 'Template';
```

**Good:**
```dart
// SCREAMING_SNAKE_CASE is required across design tokens to distinguish tokens from local variables.
// ignore_for_file: constant_identifier_names
const String APP_TITLE = 'Template';
```

### Example 4: Decorative banner removal

**Bad:**
```dart
// ##########################################################################
// Repositories
// ##########################################################################
```

**Good:**
Organize related registrations together with whitespace; no comment headers required.
