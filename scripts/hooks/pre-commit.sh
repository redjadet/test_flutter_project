#!/usr/bin/env bash
set -euo pipefail

echo "[pre-commit] Running prepare (get + format + analyze)..."

# Ensure we run from repo root (where this script resides under scripts/hooks)
HOOK_DIR=$(cd -- "$(dirname -- "$0")" && pwd -P)
REPO_ROOT=$(cd -- "$HOOK_DIR/../.." && pwd -P)
cd "$REPO_ROOT"

# Run combined prepare
bash scripts/dev.sh prepare

# Auto-fix ARB files (format/sort keys)
if command -v node >/dev/null 2>&1; then
  node scripts/fix_arb_node.js || true
else
  sh scripts/fix_arb.sh || true
fi

# If formatting changed files, abort so developer can review and restage
if ! git diff --quiet; then
  echo "[pre-commit] Formatting changed files. Please review, stage, and commit again." >&2
  exit 1
fi

echo "[pre-commit] OK"
