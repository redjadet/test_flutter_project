#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Flutter helper script

Usage:
  bash scripts/dev.sh <command> [args]

Commands:
  get           Run 'flutter pub get'
  analyze       Run 'flutter analyze'
  format        Run 'dart format .' (entire repo)
  prepare       Run get + format + analyze
  test [path]   Run 'flutter test -r compact' (optionally at path)
  clean         Run 'flutter clean'
  doctor        Run 'flutter doctor -v'

Examples:
  bash scripts/dev.sh get
  bash scripts/dev.sh analyze
  bash scripts/dev.sh prepare
  bash scripts/dev.sh test test/pie_data_test.dart
USAGE
}

need_flutter() {
  if ! command -v flutter >/dev/null 2>&1; then
    echo "Error: Flutter SDK not found in PATH." >&2
    echo "Please install Flutter and ensure 'flutter' is available." >&2
    exit 127
  fi
}

cmd=${1:-help}
shift || true

case "$cmd" in
  get)
    need_flutter
    flutter pub get
    ;;
  analyze)
    need_flutter
    flutter analyze
    ;;
  prepare)
    need_flutter
    flutter pub get
    if command -v dart >/dev/null 2>&1; then
      dart format .
    else
      echo "Info: 'dart' not found, trying 'flutter format'" >&2
      flutter format .
    fi
    flutter analyze
    ;;
  format)
    if command -v dart >/dev/null 2>&1; then
      dart format .
    else
      echo "Info: 'dart' not found, trying 'flutter format'" >&2
      flutter format .
    fi
    ;;
  test)
    need_flutter
    if [ $# -gt 0 ]; then
      flutter test -r compact "$@"
    else
      flutter test -r compact
    fi
    ;;
  clean)
    need_flutter
    flutter clean
    ;;
  doctor)
    need_flutter
    flutter doctor -v
    ;;
  help|--help|-h)
    usage
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
