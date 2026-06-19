# validate-immutable-paths.ps1
# PreToolUse hook — blocks write operations targeting immutable directories.
# Tool call context arrives as JSON on stdin. Exit 1 with a message to block; exit 0 to allow.
$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$ti = $data
if ($null -ne $data.tool_input) { $ti = $data.tool_input }

$filePath = $null
foreach ($field in @("path", "file_path", "target", "destination")) {
    $val = $ti.$field
    if ($null -ne $val -and "$val" -ne "") { $filePath = "$val"; break }
}
if ($null -eq $filePath) { exit 0 }

$normalized = $filePath.Replace('\', '/').TrimStart('.', '/')
foreach ($prefix in @("standards/", "exemplars/")) {
    if ($normalized.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase) -or
        $normalized.ToLower().Contains("/$prefix")) {
        Write-Output "BLOCKED: Attempted write to immutable path: $filePath"
        Write-Output "The /standards/ and /exemplars/ directories are READ ONLY (Constitution Principle I)."
        Write-Output "Agents must never modify source material. Add new files via human curation only."
        exit 1
    }
}
exit 0
