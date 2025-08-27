# test_flutter_project

Flutter dashboard UI demo with fl_chart.

## Flavors

This project defines three flavors for environment-specific builds:

- dev: development builds
- test: QA/testing builds
- prod: production builds (formerly named "release")

Entrypoints (auto-selected per flavor):

- dev → `lib/main_dev.dart`
- test → `lib/main_test.dart`
- prod → `lib/main_prod.dart`

CLI examples:

- Android: `flutter run --flavor dev` | `--flavor test` | `--flavor prod`
- iOS: `flutter run --flavor dev` | `--flavor test` | `--flavor prod`
  - No need to pass `-t`; iOS configs set `FLUTTER_TARGET` automatically.

Makefile shortcuts:

- Run: `make run-dev`, `make run-test`, `make run-prod`
- APK: `make apk-dev`, `make apk-test`, `make apk-prod`

Naming and icons:

- Android app label per flavor:
  - dev: `ComplexUI-Dev`
  - test: `ComplexUI-Test`
  - prod: `ComplexUI`
- Android icons per flavor via manifest placeholders; default aliases point to the base icon until you add files named:
  - dev: `ic_launcher_dev`/`ic_launcher_dev_round`
  - test: `ic_launcher_test`/`ic_launcher_test_round`
- iOS app name per flavor is driven by `APP_DISPLAY_NAME`:
  - dev: `ComplexUI-Dev`, test: `ComplexUI-Test`, prod: `ComplexUI`

Signing & bundle IDs:

- Android `applicationId`: `com.ilkersevim.complex_ui` (+ suffixes for dev/test)
- iOS bundle IDs: `com.ilkersevim.complexui` (+ `.dev` / `.test`)
- Android signing per flavor via optional properties files under `android/keystore/`:
  - `dev.properties`, `test.properties`, `release.properties` (used for prod)
  - Keys: `storeFile`, `storePassword`, `keyAlias`, `keyPassword`
- iOS signing: set your Team ID in the project or Xcode; per-flavor configs are created and mapped to schemes.

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

Flavor helpers:

- `make run-dev` — flutter run --flavor dev
- `make run-test` — flutter run --flavor test
- `make run-prod` — flutter run --flavor prod
- `make apk-dev|apk-test|apk-prod` — build Android APKs per flavor

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

Note: The hook is non-blocking. It auto-applies formatting and ARB fixes, stages the changes, and continues the commit.

Conventional Commits enforcement (optional):

- Install both hooks (pre-commit + commit-msg): `make hook-install-all`
- Commit messages must follow `<type>(<scope>): <subject>`.

## Repo Setup

Initialize local Git and make the first commit:

- `git init && git branch -M main`
- `git config user.name "Your Name"`
- `git config user.email "you@example.com"`
- `git add .`
- `git commit -m "chore(repo): initial Git setup"`

Recommended Git configuration:

- macOS/Linux line endings: `git config core.autocrlf input`
- Windows line endings: `git config core.autocrlf true`
- Safe CRLF warnings: `git config core.safecrlf warn`
- Prefer merge (default): `git config pull.rebase false`

Notes:

- `.gitignore` and `.gitattributes` are included to ignore Flutter build artifacts and enforce consistent line endings. Adjust as needed.
- Consider Git LFS for large binary assets (images, fonts, archives): https://git-lfs.github.com/

## Branch Protection (Recommended)

Protect `main` to keep it always releasable:

- Require PRs: enable “Require a pull request before merging”.
- Require status checks: `Flutter CI / build-test` must pass.
- Require PR title convention: keep `Semantic PR Title` check passing.
- Require code review: at least 1 approving review; dismiss stale approvals on new commits.
- Enforce for admins: enable to apply rules to admins too.
- Restrict who can push: allow only maintainers/bots if desired.

GitHub path: `Settings → Branches → Branch protection rules → New rule → Branch name pattern: main`.

CLI alternative:

- Ensure `gh` CLI is installed and authenticated (`gh auth login`).
- From repo root: `OWNER=<owner> REPO=<repo> make protect-main`
- Or customize checks: `CONTEXTS="Flutter CI / build-test,Semantic PR Title" OWNER=<owner> REPO=<repo> bash scripts/protect_main_branch.sh`
