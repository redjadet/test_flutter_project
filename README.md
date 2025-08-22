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
