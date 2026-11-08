## Summary
<!-- Concise description of changes (WHAT and WHY). -->

## Related Issue
Closes #

## Verification
Please ensure all verification steps pass before requesting review:

- [ ] `dart format --output=none --set-exit-if-changed lib test tool` passes with zero changes
- [ ] `flutter analyze --fatal-infos` passes with zero issues
- [ ] `dart run tool/check_conventions.dart` passes (Clean Architecture, Comment & Test conventions)
- [ ] `flutter test` passes
- [ ] UI changes follow Clean Architecture and use `context.colorPalette` / `context.shadowPalette` / `AppConstants` (no raw Color/Shadow values)
