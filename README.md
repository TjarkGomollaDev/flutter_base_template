# Flutter Base Template

A modern, production-grade Flutter template designed for **Clean Architecture** and **AI-assisted development** (Flutter 3.44+ / Dart 3.12+).

This template provides a zero-friction, highly automated starting point for turning ideas into clean, tested apps with AI coding assistants (Claude Code, OpenCode, Gemini CLI, Antigravity) without sacrificing architectural discipline or code quality.

---

## Highlights

- **Strict 4-Layer Clean Architecture:** Hard separation between Presentation, Application (BLoC), Domain (pure Dart entities & interfaces), and Infrastructure (DTO models, datasources, API client).
- **Multi-Harness AI Guardrails:** Built-in rules, output styles, and hooks for **Claude Code**, **OpenCode**, **Gemini CLI**, and **Antigravity** enforce architecture and conventions on every tool call.
- **Official Dart MCP Server Support:** Configured out of the box for deep semantic code intelligence and auto-navigation via Dart's Model Context Protocol server.
- **Fast Headless App-Flow Testing:** Full app and tab navigation flows run in under 3 seconds in the host Dart VM using in-memory dependencies — zero simulator required for CI or local smoke testing.
- **Zero-Dependency Git Hooks & GitHub Actions CI:** Automated branch naming, conventional commit checks, staged code formatting, Clean Architecture import validation, and PR auto-labeling.

---

## Quickstart for a New Project

### 1. Initialize Your Repository
Clone or create a new repository from this template, install dependencies, and activate the Git hooks:

```bash
# Install Flutter dependencies
flutter pub get

# Activate Git hooks (pre-commit, commit-msg, pre-push)
sh .hooks/setup.sh

# (Optional) Initialize GitHub label taxonomy on your new repository
sh tool/setup_github_labels.sh
```

### 2. Create a Feature Branch
Direct commits to `main` are blocked. Switch to a feature branch following the branch convention:

```bash
git switch -c feat/my-app-idea
```

### 3. Add Your Design & Start Planning
1. Paste your **Claude Design** artifact link, Figma URL, or design specifications into [design/README.md](design/README.md).
2. Open your AI coding assistant (e.g. Claude Code, Antigravity, OpenCode, or Gemini CLI) and start planning:
   ```text
   /plan Read design/README.md and implement the initial app screens according to our architecture and theme mapping contract.
   ```

---

## Key Commands

| Task | Command | Purpose |
| --- | --- | --- |
| **Install Dependencies** | `flutter pub get` | Installs Flutter and Dart packages |
| **Generate Localization** | `flutter gen-l10n` | Recompiles `.arb` files to Dart classes |
| **Format Code** | `dart format lib test tool` | Enforces standard Dart formatting |
| **Analyze Code** | `flutter analyze --fatal-infos` | Runs strict Dart analysis with zero warnings |
| **Check Conventions** | `sh tool/run_compiled.sh check_conventions` | Validates Clean Architecture, comment rules, and test conventions |
| **Run Tests** | `flutter test` | Executes all unit, BLoC, and headless app-flow tests |

---

## Documentation Index

Explore the comprehensive guides in `docs/` and `design/`:

- [docs/architecture.md](docs/architecture.md): 4-Layer Clean Architecture boundaries, BLoC state orchestration, Dependency Injection (`GetIt`), routing (`GoRouter`), API client networking, and localization.
- [design/README.md](design/README.md): Design handoff slot and mandatory 3-step Flutter theme mapping contract (extract tokens → build core widgets → assemble screens).
- [docs/code-comments.md](docs/code-comments.md): Strict comment guidelines (WHY-only comments, zero banner/section labels, explicit `///` restrictions, and ignore justifications).
- [docs/testing.md](docs/testing.md): Testing philosophy (pinning real decisions, stable key-based finders, and fast headless host-VM flow tests).
- [docs/git-workflow.md](docs/git-workflow.md): Branch and commit naming rules, Git hooks (`.hooks/`), GitHub Actions CI (`ci.yml`), and PR automation (`pr-automation.yml`).
