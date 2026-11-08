---
type: Overview
title: Application Overview
description: High-level overview of the application, its entry points, and how project knowledge is organized.
status: stable
tags: [overview, architecture]
generated: { by: "human:tjark", at: 2026-11-08T00:00:00Z }
---

# Overview

This application is built on a 4-layer Clean Architecture template (`1st_layer_presentation`, `2nd_layer_application`, `3rd_layer_domain`, `4th_layer_infrastructure`) wired at the root via `lib/app_*.dart` and `lib/main.dart`.

Standing engineering rules (architecture boundaries, code comments, testing, and Git workflow) live outside this bundle in `guidelines/`. Durable project knowledge (features, domain entities, external integrations, architectural decisions, and learnings) lives in this bundle (`docs/`) and follows [Documentation Conventions](meta/conventions.md).
