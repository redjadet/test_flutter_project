Param()
$ErrorActionPreference = 'Stop'

function Invoke-Dart($DartPath, $ScriptPath) {
  if (Test-Path $DartPath) {
    & $DartPath $ScriptPath
    return $true
  }
  return $false
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Script = Join-Path $RepoRoot 'scripts/fix_arb.dart'

# 1) Try system dart
try {
  $dart = Get-Command dart -ErrorAction Stop
  & $dart.Source $Script
  exit 0
} catch {}

# 2) Try Flutter-bundled dart
try {
  $flutter = Get-Command flutter -ErrorAction Stop
  $flutterBin = Split-Path -Parent $flutter.Source
  $dartBin = Join-Path $flutterBin 'cache/dart-sdk/bin/dart.exe'
  if (-not (Test-Path $dartBin)) {
    # Non-Windows path fallback
    $dartBin = Join-Path $flutterBin 'cache/dart-sdk/bin/dart'
  }
  if (Invoke-Dart $dartBin $Script) { exit 0 }
} catch {}

Write-Error "[fix_arb] Could not find 'dart'. Ensure Dart or Flutter SDK is installed and on PATH."
exit 1

