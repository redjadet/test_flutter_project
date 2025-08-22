#!/usr/bin/env bash
set -euo pipefail

MSG_FILE="$1"
MSG_FIRST_LINE="$(head -n1 "$MSG_FILE" | tr -d '\r')"

# Conventional Commits: type(scope?): subject
# Allowed types
TYPE_RE='build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test'

if [[ "$MSG_FIRST_LINE" =~ ^($TYPE_RE)(\([a-z0-9_\-\.]+\))?\:\s.+$ ]]; then
  exit 0
fi

cat <<'EOF'
Invalid commit message format.
Use: <type>(<scope>): <subject>

Examples:
  feat(dashboard): add KPI cards presenter
  fix(charts): correct tooltip position on tap
  refactor(settings): move logic to presenter

Allowed types: build,chore,ci,docs,feat,fix,perf,refactor,revert,style,test
EOF
echo "Got: $MSG_FIRST_LINE"
exit 1

