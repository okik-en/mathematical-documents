#!/usr/bin/env pwsh
param()
Set-StrictMode -Version Latest

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $root

$public = Join-Path $root 'public'
if (-not (Test-Path $public)) {
  New-Item -ItemType Directory -Path $public | Out-Null
}

# Clean old index directory output so public/index.html is authoritative
$legacyIndexDir = Join-Path $public 'index'
if (Test-Path $legacyIndexDir) {
  Remove-Item -Recurse -Force $legacyIndexDir
}

Get-ChildItem -Path (Join-Path $root 'src') -Recurse -Filter *.typ | ForEach-Object {
  $file = $_.FullName
  $relative = [IO.Path]::GetRelativePath($root, $file)
  if ($relative.StartsWith('src' + [IO.Path]::DirectorySeparatorChar)) {
    $relative = $relative.Substring(4)
  }
  $outRelative = [IO.Path]::ChangeExtension($relative, '')
  if ($outRelative.EndsWith('.')) {
    $outRelative = $outRelative.Substring(0, $outRelative.Length - 1)
  }
  if ($relative -eq 'index.typ') {
    $outDir = $public
    $outPath = Join-Path $public 'index.html'
  } else {
    $outDir = Join-Path $public $outRelative
    $outPath = Join-Path $outDir 'index.html'
  }
  if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

  if ($relative -eq 'index.typ') {
    Write-Host "Compiling: $relative -> public/index.html"
    $cssPath = 'style.css'
  } else {
    Write-Host "Compiling: $relative -> public/$outRelative/index.html"
    $cssPath = '../style.css'
  }

  & typst compile --features html --format html --root $root --input css-path="$cssPath" $file $outPath
  if ($LASTEXITCODE -ne 0) {
    Write-Error "typst failed for $file (exit $LASTEXITCODE)"
    Pop-Location
    exit $LASTEXITCODE
  }
}

Pop-Location
