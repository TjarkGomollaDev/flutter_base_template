#!/bin/sh
set -e

# Ensure standard PATH includes Homebrew and standard binary locations.
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TOOL="$1"
if [ -z "$TOOL" ]; then
  echo "Usage: sh tool/run_compiled.sh <tool_name> [args...]" >&2
  exit 1
fi
shift

# Locate direct Dart SDK binary from Flutter root if available (bypasses update_engine_version lock), otherwise fallback to dart.
DART_CMD="dart"
FLUTTER_PATH="$(command -v flutter 2>/dev/null || true)"
if [ -n "$FLUTTER_PATH" ]; then
  TARGET="$FLUTTER_PATH"
  while [ -L "$TARGET" ]; do
    DIR="$(cd -P "$(dirname "$TARGET")" && pwd)"
    TARGET="$(readlink "$TARGET")"
    case "$TARGET" in
      /*) ;;
      *) TARGET="$DIR/$TARGET" ;;
    esac
  done
  FLUTTER_DIR="$(cd -P "$(dirname "$TARGET")" && pwd)"
  CANDIDATE="$FLUTTER_DIR/cache/dart-sdk/bin/dart"
  if [ -x "$CANDIDATE" ]; then
    DART_CMD="$CANDIDATE"
  fi
fi

if ! command -v "$DART_CMD" >/dev/null 2>&1 && [ ! -x "$DART_CMD" ]; then
  echo "Error: Dart SDK not found in PATH." >&2
  exit 1
fi

BIN_DIR="$ROOT/.dart_tool/hooks_bin"
BIN="$BIN_DIR/$TOOL"
SDK_VERSION_FILE="$BIN_DIR/.sdk_version"

mkdir -p "$BIN_DIR"

CURRENT_SDK="$("$DART_CMD" --version 2>&1 || true)"
CACHED_SDK=""
if [ -f "$SDK_VERSION_FILE" ]; then
  CACHED_SDK="$(cat "$SDK_VERSION_FILE" 2>/dev/null || true)"
fi

NEED_COMPILE=0
if [ ! -f "$BIN" ]; then
  NEED_COMPILE=1
elif [ "$CURRENT_SDK" != "$CACHED_SDK" ]; then
  NEED_COMPILE=1
elif [ -n "$(find "$ROOT/tool" -name '*.dart' -newer "$BIN" -print -quit 2>/dev/null || true)" ]; then
  NEED_COMPILE=1
fi

if [ "$NEED_COMPILE" -eq 1 ]; then
  TMP_BIN="$BIN.tmp.$$"
  trap 'rm -f "$TMP_BIN" 2>/dev/null' EXIT INT TERM

  # Compile to temporary binary redirecting all compiler output to stderr.
  if "$DART_CMD" --suppress-analytics compile exe "$ROOT/tool/$TOOL.dart" -o "$TMP_BIN" >&2 2>&1; then
    :
  else
    "$DART_CMD" compile exe "$ROOT/tool/$TOOL.dart" -o "$TMP_BIN" >&2
  fi

  mv -f "$TMP_BIN" "$BIN"
  printf "%s\n" "$CURRENT_SDK" > "$SDK_VERSION_FILE"
  trap - EXIT INT TERM
fi

exec "$BIN" "$@"
