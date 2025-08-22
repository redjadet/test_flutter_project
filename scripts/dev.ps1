param(
  [Parameter(Position=0)]
  [string]$Command = 'help',
  [Parameter(ValueFromRemainingArguments=$true)]
  [string[]]$Args
)

function Usage {
@'
Flutter helper script (PowerShell)

Usage:
  pwsh -File scripts/dev.ps1 <command> [args]

Commands:
  get           Run "flutter pub get"
  analyze       Run "flutter analyze"
  format        Run "dart format ." (entire repo)
  prepare       Run get + format + analyze
  test [path]   Run "flutter test -r compact" (optionally at path)
  clean         Run "flutter clean"
  doctor        Run "flutter doctor -v"

Examples:
  pwsh -File scripts/dev.ps1 get
  pwsh -File scripts/dev.ps1 analyze
  pwsh -File scripts/dev.ps1 test test\pie_data_test.dart
'@
}

function Need-Flutter {
  if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter SDK not found in PATH. Install Flutter and ensure 'flutter' is available."
    exit 127
  }
}

switch ($Command) {
  'get' {
    Need-Flutter
    flutter pub get
  }
  'analyze' {
    Need-Flutter
    flutter analyze
  }
  'prepare' {
    Need-Flutter
    flutter pub get
    if (Get-Command dart -ErrorAction SilentlyContinue) {
      dart format .
    } else {
      Write-Host "Info: 'dart' not found, trying 'flutter format'"
      flutter format .
    }
    flutter analyze
  }
  'format' {
    if (Get-Command dart -ErrorAction SilentlyContinue) {
      dart format .
    } else {
      Write-Host "Info: 'dart' not found, trying 'flutter format'"
      flutter format .
    }
  }
  'test' {
    Need-Flutter
    if ($Args -and $Args.Length -gt 0) {
      flutter test -r compact @Args
    } else {
      flutter test -r compact
    }
  }
  'clean' {
    Need-Flutter
    flutter clean
  }
  'doctor' {
    Need-Flutter
    flutter doctor -v
  }
  'help' { Usage }
  default {
    Write-Error "Unknown command: $Command"
    Usage
    exit 2
  }
}
