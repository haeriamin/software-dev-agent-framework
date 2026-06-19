# common.ps1 — shared helpers for Throughline lifecycle scripts (dot-source this file).

function Get-RepoRoot {
    $dir = Get-Location
    while ($dir) {
        if (Test-Path (Join-Path $dir ".throughline\memory\constitution.md")) { return $dir.ToString() }
        $parent = Split-Path $dir -Parent
        if ($parent -eq $dir.ToString()) { break }
        $dir = $parent
    }
    throw "Not inside the framework (no .throughline/memory/constitution.md found upward from $(Get-Location))."
}

function Get-FeatureDirectory {
    # Resolution order: .throughline/feature.json → highest-numbered specs/NNN-* dir.
    $root = Get-RepoRoot
    $featureJson = Join-Path $root ".throughline\feature.json"
    if (Test-Path $featureJson) {
        $data = Get-Content $featureJson -Raw | ConvertFrom-Json
        if ($data.feature_directory) {
            $p = Join-Path $root $data.feature_directory
            if (Test-Path $p) { return $p }
        }
    }
    $specs = Join-Path $root "specs"
    $latest = Get-ChildItem $specs -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d{3}-' } | Sort-Object Name | Select-Object -Last 1
    if ($null -eq $latest) { throw "No feature directory found. Run /throughline first." }
    return $latest.FullName
}

function Get-NextFeatureNumber {
    $root = Get-RepoRoot
    $specs = Join-Path $root "specs"
    $max = 0
    Get-ChildItem $specs -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -match '^(\d{3})-') { $n = [int]$Matches[1]; if ($n -gt $max) { $max = $n } }
    }
    return "{0:D3}" -f ($max + 1)
}

function Write-JsonOutput([hashtable]$Data) {
    $Data | ConvertTo-Json -Compress | Write-Output
}
