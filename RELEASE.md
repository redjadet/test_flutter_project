# Release Guide

This project uses Semantic Versioning (SemVer): vMAJOR.MINOR.PATCH.

## Prerequisites
- Clean working tree: `git status` shows no changes
- All checks pass: `make prepare && make test`

## Version Bump
1. Decide version: `vX.Y.Z` (follow SemVer)
2. Update `pubspec.yaml` `version: X.Y.Z+build` (optional build number)
3. Update `CHANGELOG.md` (add a new section for `X.Y.Z`)
4. Update README/docs if needed

## Commit and Tag
- Stage changes: `git add pubspec.yaml CHANGELOG.md README.md`
- Commit: `git commit -m "chore(release): vX.Y.Z"`
- Create annotated tag: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
- Push: `git push origin main --follow-tags` (or `git push && git push --tags`)

## GitHub Release (optional)
- Create a new Release on GitHub from tag `vX.Y.Z`
- Title: `vX.Y.Z`
- Notes: paste the `CHANGELOG.md` section for `X.Y.Z`

## Build Artifacts
- Android APK: `flutter build apk --release`
- Android App Bundle: `flutter build appbundle --release`
- iOS: `flutter build ios --release`
- Web: `flutter build web --release`
- macOS: `flutter build macos --release`
- Windows: `flutter build windows --release`
- Linux: `flutter build linux --release`

## Post-Release
- Create next `-dev` section in `CHANGELOG.md` (optional)
- Start a new branch for the next work: `feature/...` or `fix/...`

Tips
- Keep releases small and frequent.
- Use Conventional Commits to generate changelogs consistently.
