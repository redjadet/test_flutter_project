# Contributing

Thanks for contributing! This project follows MVP architecture with SOLID and Clean Code principles. Please read this guide before opening a PR.

## Branching Strategy

- Default branch: `main` (always releasable)
- Feature branches: `feature/<scope>-<short-desc>`
- Bugfix branches: `fix/<scope>-<short-desc>`
- Release branches (optional): `release/<version>`
- Hotfix branches: `hotfix/<scope>-<short-desc>`

Examples: `feature/dashboard-grid`, `fix/chart-y-axis`, `hotfix/build-ios`.

## Commit Messages (Conventional Commits)

Format: `<type>(<scope>): <summary>`

Types:
- `feat`: new user-facing feature
- `fix`: bug fix
- `refactor`: internal refactor (no features/bugs)
- `docs`: docs only changes
- `test`: tests only changes
- `chore`: tooling, CI, build, deps

Examples:
- `feat(dashboard): add KPI cards presenter`
- `fix(charts): correct tooltip position on tap`
- `refactor(settings): move logic to presenter`

Use the imperative mood, keep under ~72 chars when possible. Reference issues in the body: `Closes #123`.

## Architecture & Code Style

- MVP: View (Widgets) delegate to Presenter; no business logic in Widgets.
- Presenters: pure Dart, testable, depend on interfaces, injected via `provider`/`flutter_bloc`.
- Models/State: Bloc/Cubit or Provider-based managers under `state/` or `data/`.
- Follow SOLID and Clean Code: small components, meaningful names, explicit dependencies.
- File naming: `snake_case.dart`; Types `UpperCamelCase`; members `lowerCamelCase`.

## Tests

- Add or update tests for new/changed behavior.
- Unit tests for Presenters (mock repos/notifiers).
- Widget tests for views (delegation to presenter and rendering states).
- Run: `make test` or `flutter test -r compact`.

## PR Guidelines

- Keep PRs focused and small; include screenshots/GIFs for UI changes.
- Ensure CI passes: `make prepare && make test` locally before pushing.
- Describe test steps and link related issues.
- Avoid unrelated refactors; call them out if necessary.

## Tooling

- Install pre-commit hook: `make hook-install` (runs format/analyze before commit).
- Format: `dart format .`; Lints: `flutter analyze`.

## Versioning

- Semantic Versioning (SemVer) for releases; tag as `vX.Y.Z`.

## Security

- Do not commit secrets or signing files. Keep `build/` ignored.

