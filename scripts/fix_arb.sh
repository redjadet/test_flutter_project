#!/bin/sh
set -eu

# POSIX shell wrapper to run scripts/fix_arb.dart.
# Tries system dart first, then Flutter-bundled dart.

# Resolve repo root
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
SCRIPT="$REPO_ROOT/scripts/fix_arb.dart"

# 1) System dart
if command -v dart >/dev/null 2>&1; then
  exec dart "$SCRIPT"
fi

# 2) Flutter-bundled dart
if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN=$(command -v flutter)
  FLUTTER_DIR=$(dirname "$FLUTTER_BIN")
  DART_BIN="$FLUTTER_DIR/cache/dart-sdk/bin/dart"
  if [ -x "$DART_BIN" ]; then
    exec "$DART_BIN" "$SCRIPT"
  fi
fi

echo "[fix_arb] Could not find 'dart'. Ensure Dart or Flutter SDK is installed and on PATH." >&2
exit 1
