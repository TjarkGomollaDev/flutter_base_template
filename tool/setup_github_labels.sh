#!/usr/bin/env bash
set -euo pipefail

# Idempotently create or update the standard GitHub label set for the repository.
# Usage: ./tool/setup_github_labels.sh

if ! command -v gh &> /dev/null; then
  echo "Error: gh CLI is not installed or not in PATH." >&2
  exit 1
fi

labels=(
  # Types (7)
  "type: feat|0e8a16|A new feature"
  "type: fix|d73a4a|A bug fix"
  "type: refactor|fbca04|Code change that neither fixes a bug nor adds a feature"
  "type: docs|0075ca|Documentation only changes"
  "type: test|d4c5f9|Adding missing tests or correcting existing tests"
  "type: chore|fef2c0|Changes to build process, auxiliary tools, or libraries"
  "type: ci|5319e7|Changes to CI configuration files and scripts"

  # Layers (4)
  "layer: presentation|bfe5bf|1st layer: UI widgets, pages, themes"
  "layer: application|d4c5f9|2nd layer: BLoCs, cubits, state management"
  "layer: domain|bfd4f2|3rd layer: Entities, value objects, repository interfaces"
  "layer: infrastructure|fef2c0|4th layer: Repositories implementation, data sources, APIs"

  # Scopes (4)
  "scope: core|1d76db|Core utilities, base classes, routing, DI"
  "scope: l10n|bfdadc|Localization files and ARB definitions"
  "scope: ai-tooling|c2e0c6|AI harness configs, rules, hooks, scripts"
  "scope: deps|e99695|Dependencies update and pubspec management"

  # Sizes (3)
  "size: S|0e8a16|Small changes (<= 100 lines)"
  "size: M|fbca04|Medium changes (101-300 lines)"
  "size: L|d93f0b|Large changes (> 300 lines)"
)

echo "Setting up repository labels..."

for item in "${labels[@]}"; do
  IFS="|" read -r name color desc <<< "$item"
  echo "Syncing label: $name"
  gh label create "$name" --color "$color" --description "$desc" --force
done

echo "Successfully configured all 18 labels."
