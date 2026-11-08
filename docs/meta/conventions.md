---
type: Convention
title: Documentation Conventions
description: How we decide what earns a concept, choose its type and path, and maintain the OKF knowledge bundle.
status: stable
tags: [meta, conventions, documentation]
generated: { by: "human:tjark", at: 2026-11-08T00:00:00Z }
---

# Overview

`docs/` is the repository's Open Knowledge Format (OKF v0.2) knowledge bundle, starting at [Application Overview](../overview.md). Standing template rules live outside this bundle in `guidelines/` (`ARCHITECTURE.md`, `CODE_COMMENTS.md`, `TESTING.md`, `GIT_WORKFLOW.md`).

# The Three Gates

Before creating or expanding a concept in `docs/`, a topic must pass all three gates:

1. **Gate 0 — Truth in Code:** Is the behavior actually present in the repository? Never document planned, hypothetical, or unmerged designs as existing behavior.
2. **Gate 1 — Cost of Rediscovery:** Does understanding this require tracing multiple files, layers, or external contracts rather than reading a single class or signature? If one glance at the code answers the question, do not document it.
3. **Gate 2 — Stability Across PRs:** Will this knowledge remain true across routine refactors? Ephemeral implementation details do not earn a concept.

## Never Documented

* Mirrored directory trees, file inventories, or line-by-line code walkthroughs.
* Git history, PR changelogs, or author attribution (these belong in Git commits and PR descriptions).
* Standard Flutter, Dart, `flutter_bloc`, `go_router`, or `get_it` documentation.
* Unverified guesses or aspirational roadmaps.

# Closed Type Vocabulary

Every concept file in `docs/` must declare one `type:` from this closed vocabulary in its YAML frontmatter:

| Type | Purpose | Lifecycle |
| --- | --- | --- |
| `Overview` | High-level map of the application or a major domain | Living (updated in place) |
| `Feature` | User-facing capability spanning presentation, BLoC, and domain layers | Living (updated in place) |
| `Domain Entity` | Core business model, invariants, and domain rules | Living (updated in place) |
| `Integration` | External API, SDK, storage engine, or platform bridge contract | Living (updated in place) |
| `Convention` | Project-wide engineering or documentation rule | Living (updated in place) |
| `Runbook` | Operational procedure, release checklist, or troubleshooting guide | Living (updated in place) |
| `Decision` | Architectural Decision Record (why approach X was chosen over Y) | Append-only (superseded, never rewritten) |
| `Learning` | Non-obvious platform/package trap, root cause, and lasting takeaway | Append-only (superseded, never rewritten) |

# What Gets Documented, When

| Trigger in a PR | Required Action in the Same PR |
| --- | --- |
| New user-facing feature or cross-layer workflow | Create or update a `Feature` concept and link it in `docs/index.md` and `docs/overview.md` |
| New core business model or invariant | Create or update a `Domain Entity` concept |
| New external service, API contract, or platform plugin | Create or update an `Integration` concept |
| Non-trivial architectural trade-off between alternatives | Create an append-only `Decision` concept |
| Non-obvious bug, platform quirk, or package trap discovered | Create an append-only `Learning` concept |
| Existing documented behavior changes | Update the affected living concept(s) and append a `docs/log.md` entry |
| None of the above | Write nothing. State `'No bundle changes: <reason>'` in the PR body. |

# Placement, Naming & Protecting Static Docs

* **Protect Static Template Guardrails:** `README.md`, `AGENTS.md` (`CLAUDE.md`, `GEMINI.md`), `design/README.md`, and `guidelines/*.md` are **static template guardrails** and must **never** be cluttered with feature notes, domain docs, or ADRs. All project-specific knowledge belongs here in `docs/`.
* **Domain Directories Only:** Directories under `docs/` represent domains (e.g. `docs/auth/`, `docs/checkout/`), never concept types (`decisions/`, `features/`).
* **Filenames:** Lowercase `kebab-case.md`.
* **Indexing & Linking:** Every concept must be listed in `docs/index.md` and linked to/from at least one related concept using relative Markdown links (e.g. `[Application Overview](../overview.md)`).
* **Sources & Footnotes:** Only add `sources:` entries in frontmatter when explicitly cited in prose with `[^id]` footnotes.

# log.md Format

`docs/log.md` records bundle changes in newest-first order under `## YYYY-MM-DD` headings:

```markdown
## YYYY-MM-DD
* **Creation|Update|Fix**: [Concept Title](relative/path.md) — concise one-line summary of the knowledge change.
```

Never add a `docs/log.md` entry if no concept file in `docs/` changed.
