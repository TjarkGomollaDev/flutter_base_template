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
Run all verification commands listed in [README.md](README.md#key-commands) (`flutter pub get`, `flutter gen-l10n`, `dart format lib test tool`, `flutter analyze --fatal-infos`, `sh tool/run_compiled.sh check_conventions`, `flutter test`) before finishing.

## Mandatory Documentation Routing (Read Before Acting)
Read the relevant documentation before making decisions or editing code in that area:
- Architecture, 4-layer rules, BLoC, DI, routing, l10n & UI test keys: [guidelines/ARCHITECTURE.md](guidelines/ARCHITECTURE.md)
- Design handoff & Flutter theme token mapping: [design/README.md](design/README.md)
- Code comment rules, `///` restrictions & where knowledge belongs: [guidelines/CODE_COMMENTS.md](guidelines/CODE_COMMENTS.md)
- Testing philosophy, UI finders & test rules: [guidelines/TESTING.md](guidelines/TESTING.md)
- Branch, commit, PR naming (incl. Issue ID), labels & hooks: [guidelines/GIT_WORKFLOW.md](guidelines/GIT_WORKFLOW.md)
- Project knowledge bundle (OKF): [docs/index.md](docs/index.md) & [docs/meta/conventions.md](docs/meta/conventions.md) — read before changing domain/feature behavior and update in the same PR. Never clutter `README.md`, `AGENTS.md`, `design/README.md`, or `guidelines/*.md` with app-specific feature notes.
