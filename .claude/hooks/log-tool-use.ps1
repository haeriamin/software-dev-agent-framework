# log-tool-use.ps1 (Claude Code PostToolUse hook)
# Appends a structured entry to wiki/log.md for file-writing tool calls (Principle VII).
# Never blocks (always exits 0).
$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$toolName = if ($null -ne $data.tool_name) { $data.tool_name } else { "unknown" }
$ti = $data.tool_input
if ($null -eq $ti) { exit 0 }

$filePath = $null
foreach ($field in @("file_path", "path", "notebook_path")) {
    $val = $ti.$field
    if ($null -ne $val -and "$val" -ne "") { $filePath = "$val"; break }
}
if ($null -eq $filePath) { exit 0 }
if ($filePath -like "*wiki/log.md*" -or $filePath -like "*wiki\log.md*") { exit 0 }

# cwd field from Claude Code points at the project dir; fall back to current location.
$root = if ($null -ne $data.cwd) { $data.cwd } else { (Get-Location).Path }
$log = Join-Path $root "wiki\log.md"
if (-not (Test-Path $log)) { exit 0 }

$ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
Add-Content -Path $log -Value "| $ts | hook | $toolName | - | - | file written | $filePath |" -Encoding utf8
exit 0
