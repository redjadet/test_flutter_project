# complex_ui_openai

Flutter dashboard UI demo with Riverpod and fl_chart.

## Dev Scripts

- Bash: `bash scripts/dev.sh <command>`
- PowerShell: `pwsh -File scripts/dev.ps1 <command>`

Commands:
- `get`: flutter pub get
- `analyze`: flutter analyze
- `format`: dart format . (fallback to flutter format)
- `prepare`: get + format + analyze
- `test [path]`: flutter test -r compact (optionally pass a file/dir)
- `clean`: flutter clean
- `doctor`: flutter doctor -v

## Makefile Targets

- `make get` — install dependencies
- `make analyze` — static analysis
- `make format` — format codebase
- `make prepare` — get + format + analyze
- `make test` — run tests (use `make test FILE=path` for a subset)
- `make test-integration` — run `integration_test/`
- `make clean` — clean build artifacts
- `make doctor` — show Flutter doctor
- `make ci` — get + analyze + test

## CI

GitHub Actions workflow is provided at `.github/workflows/flutter_ci.yml` to run get/analyze/test on push and PRs.

## Git Hooks

Install a pre-commit hook that runs `prepare` before each commit:

- macOS/Linux (Git Bash):
  - `make hook-install`
  - To remove: `make hook-uninstall`

- Windows options:
  - If you use Git Bash: `make hook-install`
  - PowerShell hook file is also available at `scripts/hooks/pre-commit.ps1`.
    You can create `.git/hooks/pre-commit` that calls it, e.g.:
    - `pwsh -File scripts/hooks/pre-commit.ps1`

Note: The hook aborts the commit if formatting changes files, so you can review and re-stage.
