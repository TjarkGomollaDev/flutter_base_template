# CRITICAL RULES — MUST FOLLOW

## Responses
- Keep responses concise and to the point unless asked otherwise.

## Planning Mode
- Always ask clarifying questions before designing or implementing.
- Never assume design, tech stack, or features without explicit confirmation.
- Use deep-dive sub-agents to assist with research and explore trade-offs.
- Use deep-dive sub-agents to review all aspects of your plan before presenting to the user.

## Change / Edit Mode
- Never implement features yourself when possible — use sub-agents!
- Identify changes from the plan that can be implemented in parallel, and delegate to sub-agents with disjoint file scopes.
- When using sub-agents to implement features, act as a coordinator only.
- Select model tier matching task complexity: premium models for complex coding, mid-tier models for simpler tasks or documentation.
- After completing features (large or small), always run all verification commands to ensure code quality and build health before finishing.

## Verification Commands
- **Install dependencies:** `flutter pub get`
- **Generate localization:** `flutter gen-l10n`
- **Format code:** `dart format lib test tool`
- **Analyze code:** `flutter analyze --fatal-infos`
- **Check conventions (comments, tests, Clean Architecture):** `sh tool/run_compiled.sh check_conventions`
- **Run tests:** `flutter test`

## Mandatory Documentation Routing (Read Before Acting)
Read the relevant documentation before making decisions or editing code in that area:
- Architecture, 4-layer rules, BLoC, DI, routing, l10n & UI test keys: [docs/architecture.md](docs/architecture.md)
- Design handoff (Claude Design) & Flutter theme token mapping: [design/README.md](design/README.md)
- Code comment rules & `///` restrictions: [docs/code-comments.md](docs/code-comments.md)
- Testing philosophy, UI finders & test rules: [docs/testing.md](docs/testing.md)
- Branch, commit, PR naming, labels & hooks: [docs/git-workflow.md](docs/git-workflow.md)
