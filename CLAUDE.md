# CRITICAL RULES - MUST FOLLOW

## RESPONSES
- Keep responses concise and to the point - unless the user asks otherwise

## PLANNING MODE
- Always ask clarifying questions
- Never assume design, tech stack or features
- Use deep-dive sub-agents to assist with research
- Use deep-dive sub-agents to review the different aspects of your plan before presenting to the user

## CHANGE / EDIT MODE
- Never implement features yourself when possible - use sub-agents!
- Identify changes from the plan that can be implemented in parallel, and use sub-agents to implement the features efficiently
- When using sub-agents to implement features, act as a coordinator only
- Use the best model for the task - premium models for complex tasks (like coding) and mid-tier models for simpler tasks, like documentation
- After completing features (large or small), always run commands like lint, type check and next build to check code quality

## Architecture & Entrypoints
- Always follow the architecture defined in @ARCHITECTURE.md.
- Main entrypoint: `lib/main.dart`.

## Verification & Commands
- **Install dependencies:** `flutter pub get`
- **Run tests:** `flutter test` (must pass after modifying UI)
- **Linting:** `flutter analyze`
- **Formatting:** `dart format lib test`

## Workflow Conventions
- Always run `flutter test` and `flutter analyze` before committing changes to ensure the build stays green.
- If the default UI structure in `lib/main.dart` is modified, verify and update `test/widget_test.dart` as it acts as a smoke test for the app launch.

## UI DESIGN
- Always follow the UI design system when creating or reviewing components or pages.
- Design System: @DESIGN.md
