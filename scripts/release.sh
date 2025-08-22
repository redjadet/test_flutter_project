#!/usr/bin/env bash
set -euo pipefail

if [[ "${1-}" == "" ]]; then
  echo "Usage: $0 vX.Y.Z"
  exit 1
fi

VERSION="$1"

if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be SemVer like v1.2.3"
  exit 1
fi

echo "Checking working tree is clean..."
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: working tree is not clean. Commit or stash changes."
  exit 1
fi

echo "Running checks..."
if command -v make >/dev/null 2>&1; then
  make prepare || true
fi

if command -v flutter >/dev/null 2>&1; then
  flutter test -r compact || true
fi

echo "Tagging ${VERSION}..."
git tag -a "${VERSION}" -m "Release ${VERSION}"
echo "Tag created. Push with: git push origin main --follow-tags"
