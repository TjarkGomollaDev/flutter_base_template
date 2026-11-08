# Testing Philosophy & Conventions

This specification outlines the testing strategy for the repository. Tests are fast, headless, and focused on verifying genuine application decisions rather than redundant boilerplate. Conformance is verified by `tool/src/test_checker.dart`.

## 1. Core Principle: Pin Real Decisions Only

Write tests for code that makes decisions:
- Branching logic (`if`, `switch`, guard clauses).
- BLoC state transitions and side-effect sequencing.
- Error handling, catch clauses, and exception mapping.
- Input validation, parsing edge cases, and business computations.
- Navigation transitions between routes.

### Do NOT test:
- Trivial getters, setters, or default constructors.
- `Equatable` `props` lists or `copyWith` methods.
- Simple compile-time constants or static values.
- Plain DTOs without custom deserialization logic.
- Pure dependency injection registration boilerplate.

## 2. Lowest Sufficient Layer

Keep tests as close to the logic as possible to guarantee rapid feedback and maintainability:

| Test Type | Scope | Execution |
| --- | --- | --- |
| **Unit Tests** | Domain entities, repositories, utilities, data parsers | Headless Dart VM (< 50ms) |
| **BLoC Tests** | Event dispatch, sequential state emission, persistence side-effects | Headless Dart VM (< 100ms) |
| **App-Flow Tests** | Complete user journeys, tab navigation, screen transitions | Headless host-VM `flutter_test` via `pump_app.dart` (< 3s total) |

### Headless App Flows over Simulator Testing
Instead of slow integration tests requiring simulators (`flutter drive`), critical UI journeys run inside `test/app_flow_test.dart` using `test/support/pump_app.dart`. This boots the full widget tree with `InMemorySharedPreferencesAsync`, resets dependency injection cleanly between tests, and executes in under 3 seconds on any developer machine or Linux CI runner.

## 3. Stable UI Finders

When finding widgets in `flutter_test`, choose finders in this strict priority order:

1. **Explicit Keys (`find.byKey`):**
   - Screen roots: `Key('<screen>_page')` (e.g. `find.byKey(const Key('home_page'))`)
   - Interactive controls: `Key('<screen>_<element>')` (e.g. `find.byKey(const Key('nav_tab_page_2'))`)
2. **Accessibility Semantics (`find.bySemanticsLabel`):**
   - For controls configured with descriptive `Semantics(label: ...)`.
3. **Unique Icons (`find.byIcon`):**
   - For standalone action buttons with unambiguous iconography.

### Forbidden Finders
- **Never find by layout primitives:** Finding by `Padding`, `Container`, `SizedBox`, `Column`, `Row`, `Center`, or `Align` is strictly prohibited. Layouts change often without altering functionality.
- **Avoid finding by localized copy when a key fits:** Localized strings (`context.l10n`) change across languages and copy revisions, leading to brittle tests.

## 4. Test Hygiene Rules

The automated checker (`test_checker.dart`) enforces these mechanical rules:

- **Single Behavior per Test:** Each test should verify one coherent behavior or state transition.
- **Concise Single-Line Descriptions:** Test description strings must be a single line and at most **100 characters** in length.
- **Meaningful Assertions:**
  - Every test must contain at least one real assertion (`expect`, `expectLater`, or `verify`).
  - Trivial matchers (`isNotNull`, `returnsNormally`, untyped `isA<dynamic>()`) are not sufficient on their own to prove behavior.
- **Deterministic Execution:**
  - **No loops or conditional logic:** Do not place `for`, `while`, or `if` statements inside test bodies. Tests must follow a linear arrange-act-assert structure.
  - **No real wall-clock delays:** Never call `sleep()` or un-mocked `Future.delayed()`. Use fake async or pump methods (`tester.pump()`, `tester.pumpAndSettle()`).
- **Shared Helpers & Fakes:**
  - Place shared testing utilities, fake datasources, and mock setup routines under `test/support/`.

## 5. Convention Escape Hatch

If an exceptional situation genuinely requires deviating from a rule (e.g. testing an intentional thrown error that uses `returnsNormally` or a vendor edge-case), you may add an ignore comment directly above the offending test line:

```dart
// convention-ignore: trivial_assertion Needed to verify vendor library callback initialization without throwing.
expect(() => client.init(), returnsNormally);
```
