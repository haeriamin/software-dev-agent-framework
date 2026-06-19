# create-new-feature.ps1 — create specs/NNN-<short-name>/ from the spec template.
# Usage: .\create-new-feature.ps1 -ShortName "jwt-auth" [-Template "spec-template.md"]
# Outputs JSON: { FEATURE_DIR, SPEC_FILE, FEATURE_NUM }
param(
    [Parameter(Mandatory = $true)][string]$ShortName,
    [string]$Template = "spec-template.md"
)
$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

$root = Get-RepoRoot
if ($ShortName -notmatch '^[a-z0-9][a-z0-9-]*$') {
    throw "ShortName must be kebab-case (got '$ShortName')."
}

$num = Get-NextFeatureNumber
$featureDir = Join-Path $root "specs\$num-$ShortName"
New-Item -ItemType Directory -Force $featureDir | Out-Null
New-Item -ItemType Directory -Force (Join-Path $featureDir "checklists") | Out-Null

$templatePath = Join-Path $root ".throughline\templates\$Template"
if (-not (Test-Path $templatePath)) { throw "Template not found: $templatePath" }
$specFile = Join-Path $featureDir "spec.md"
Copy-Item $templatePath $specFile

$relDir = "specs/$num-$ShortName"
@{ feature_directory = $relDir } | ConvertTo-Json | Set-Content (Join-Path $root ".throughline\feature.json") -Encoding utf8

Write-JsonOutput @{ FEATURE_DIR = $relDir; SPEC_FILE = "$relDir/spec.md"; FEATURE_NUM = $num }
