# Flutter Base Template

A modern, production-grade Flutter template designed for **Clean Architecture** and **AI-assisted development**.

This template provides a zero-friction, highly automated starting point for turning ideas into clean, tested apps with AI coding assistants without sacrificing architectural discipline or code quality.

## Highlights

- **Strict 4-Layer Clean Architecture:** Hard separation between Presentation, Application (BLoC), Domain (pure Dart entities & interfaces), and Infrastructure (DTO models, datasources, API client).
- **Multi-Harness AI Guardrails:** Built-in rules, conventions, and automated hooks enforce architecture, code hygiene, and testing standards on every change.
- **Official Dart MCP Server Support:** Configured out of the box for deep semantic code intelligence and auto-navigation via Dart's Model Context Protocol server.
- **Fast Headless App-Flow Testing:** Full app and tab navigation flows run in under 3 seconds in the host Dart VM using in-memory dependencies — zero simulator required for CI or local smoke testing.
- **Zero-Dependency Git Hooks & GitHub Actions CI:** Automated branch naming, conventional commit checks, staged code formatting, Clean Architecture import validation, OKF knowledge bundle linting, and PR auto-labeling.

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
# With a corresponding GitHub Issue
git switch -c feat/1-my-app-idea

# Without a GitHub Issue
git switch -c feat/my-app-idea
```

### 3. Add Your Design & Start Planning
1. Place your design files, exports, or specifications into `design/` (see [design/README.md](design/README.md)).
2. Open your AI coding assistant and start planning:
   ```text
   Inspect design/ and implement the initial app screens according to our architecture and theme mapping contract.
   ```
