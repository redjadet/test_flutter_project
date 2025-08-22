Param()

Write-Host "[pre-commit] Running prepare (get + format + analyze)..."

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..")
Set-Location $RepoRoot

pwsh -File scripts/dev.ps1 prepare
if ($LASTEXITCODE -ne 0) {
  Write-Error "[pre-commit] prepare failed"
  exit 1
}

# If formatting changed files, abort so developer can review and restage
git diff --quiet
if ($LASTEXITCODE -ne 0) {
  Write-Error "[pre-commit] Formatting changed files. Please review, stage, and commit again."
  exit 1
}

Write-Host "[pre-commit] OK"

