# log-tool-use.ps1
# PostToolUse hook — appends a structured entry to wiki/log.md for file-writing tool calls.
# Never blocks (always exits 0).
$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$toolName = if ($null -ne $data.tool_name) { $data.tool_name } elseif ($null -ne $data.tool) { $data.tool } else { "unknown" }
$ti = $data
if ($null -ne $data.tool_input) { $ti = $data.tool_input }

$filePath = $null
foreach ($field in @("path", "file_path", "target", "destination")) {
    $val = $ti.$field
    if ($null -ne $val -and "$val" -ne "") { $filePath = "$val"; break }
}
if ($null -eq $filePath -or $filePath -like "*wiki/log.md*" -or $filePath -like "*wiki\log.md*") { exit 0 }

$log = Join-Path (Get-Location) "wiki\log.md"
if (-not (Test-Path $log)) { exit 0 }

$ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
Add-Content -Path $log -Value "| $ts | hook | $toolName | - | - | file written | $filePath |" -Encoding utf8
exit 0
