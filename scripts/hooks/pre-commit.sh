#!/usr/bin/env bash
set -euo pipefail

echo "[pre-commit] Running prepare (get + format + analyze)..."

# Ensure we run from repo root (where this script resides under scripts/hooks)
HOOK_DIR=$(cd -- "$(dirname -- "$0")" && pwd -P)
REPO_ROOT=$(cd -- "$HOOK_DIR/../.." && pwd -P)
cd "$REPO_ROOT"

# Run combined prepare
bash scripts/dev.sh prepare || true

# Auto-fix ARB files (format/sort keys)
if command -v node >/dev/null 2>&1; then
  node scripts/fix_arb_node.js || true
else
  sh scripts/fix_arb.sh || true
fi

# If changes exist, auto-stage and continue (non-blocking)
if ! git diff --quiet; then
  echo "[pre-commit] Applied fixes. Auto-staging changes and continuing..."
  git add -A
fi

echo "[pre-commit] OK (non-blocking)"
