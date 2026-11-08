#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT"

git config core.hooksPath .hooks
chmod +x .hooks/* tool/run_compiled.sh 2>/dev/null || true

echo "Git hooks configured successfully (core.hooksPath = .hooks)."
