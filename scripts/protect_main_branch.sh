#!/usr/bin/env bash
set -euo pipefail

# Applies branch protection to `main` using GitHub CLI.
# Usage:
#   OWNER=ilkersevim REPO=complex_ui_openai bash scripts/protect_main_branch.sh
# Optional: override contexts (comma-separated)
#   CONTEXTS="Flutter CI / build-test,Semantic PR Title" bash scripts/protect_main_branch.sh

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' is required"; exit 1; }
}

require_cmd gh

# Try to infer OWNER/REPO from git remote if not set
if [[ -z "${OWNER:-}" || -z "${REPO:-}" ]]; then
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    origin_url=$(git remote get-url origin 2>/dev/null || echo "")
    # Support both SSH and HTTPS remotes
    if [[ "$origin_url" =~ github.com[:/](.+)/(.+)(\.git)?$ ]]; then
      OWNER=${OWNER:-"${BASH_REMATCH[1]}"}
      REPO_RAW=${REPO:-"${BASH_REMATCH[2]}"}
      REPO=${REPO_RAW%.git}
    fi
  fi
fi

if [[ -z "${OWNER:-}" || -z "${REPO:-}" ]]; then
  echo "Usage: OWNER=<owner> REPO=<repo> bash $0"
  exit 1
fi

# Default required status checks (can be overridden)
DEFAULT_CONTEXTS=("Flutter CI / build-test" "Semantic PR Title")

IFS=',' read -r -a USER_CONTEXTS <<< "${CONTEXTS:-}"
CONTEXT_ARRAY=()
if [[ -n "${CONTEXTS:-}" ]]; then
  for c in "${USER_CONTEXTS[@]}"; do
    c_trim=$(echo "$c" | sed 's/^ *//;s/ *$//')
    [[ -n "$c_trim" ]] && CONTEXT_ARRAY+=("$c_trim")
  done
else
  CONTEXT_ARRAY=("${DEFAULT_CONTEXTS[@]}")
fi

# Build JSON array for contexts
contexts_json=$(printf '"%s",' "${CONTEXT_ARRAY[@]}" | sed 's/,$//')

echo "Applying branch protection to ${OWNER}/${REPO}@main"
echo "Required checks: ${CONTEXT_ARRAY[*]}"

gh api -X PUT -H "Accept: application/vnd.github+json" \
  "repos/${OWNER}/${REPO}/branches/main/protection" \
  --input - <<JSON
{
  "required_status_checks": {
    "strict": true,
    "contexts": [ ${contexts_json} ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null
}
JSON

echo "Branch protection applied. Review in Settings → Branches."

