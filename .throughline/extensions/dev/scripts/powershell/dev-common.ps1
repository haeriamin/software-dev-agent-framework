# dev-common.ps1 — helpers for /dev.* commands (dot-source this file).
. (Join-Path $PSScriptRoot "..\..\..\..\scripts\powershell\common.ps1")

function Get-TargetEntry([Parameter(Mandatory = $true)][string]$TargetId) {
    # Minimal flat-YAML reader for targets/<id>.yml (id, path, vcs, status, commands...).
    $root = Get-RepoRoot
    $file = Join-Path $root "targets\$TargetId.yml"
    if (-not (Test-Path $file)) { throw "Target '$TargetId' not registered (missing $file)." }
    $entry = @{}
    foreach ($line in Get-Content $file) {
        if ($line -match '^\s*#' -or $line -notmatch '^([a-z_]+):\s*(.*)$') { continue }
        $entry[$Matches[1]] = $Matches[2].Trim().Trim('"')
    }
    if (-not $entry.ContainsKey("path") -or -not (Test-Path $entry["path"])) {
        throw "Target '$TargetId' path is missing or unreachable: $($entry['path'])"
    }
    return $entry
}

function Assert-WritablePath([Parameter(Mandatory = $true)][string]$Path) {
    # Defense-in-depth mirror of the immutable-paths hook (Principle I).
    $root = Get-RepoRoot
    $full = [System.IO.Path]::GetFullPath($Path)
    foreach ($immutable in @("standards", "exemplars")) {
        $prefix = [System.IO.Path]::GetFullPath((Join-Path $root $immutable))
        if ($full.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "BLOCKED: '$Path' is inside immutable directory /$immutable/ (Constitution Principle I)."
        }
    }
}

function Get-SliceBranch([Parameter(Mandatory = $true)][string]$SliceId) {
    return "sdd/$SliceId"
}

function Add-LogEntry {
    # Append a structured record to wiki/log.md (Principle VII).
    param(
        [Parameter(Mandatory = $true)][string]$Agent,
        [Parameter(Mandatory = $true)][string]$Command,
        [string]$Target = "-",
        [string]$Verdict = "-",
        [Parameter(Mandatory = $true)][string]$Summary,
        [string]$Artifacts = "-"
    )
    $root = Get-RepoRoot
    $ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $line = "| $ts | $Agent | $Command | $Target | $Verdict | $Summary | $Artifacts |"
    Add-Content -Path (Join-Path $root "wiki\log.md") -Value $line -Encoding utf8
}
