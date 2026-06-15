# validate-immutable-paths.ps1 (Claude Code PreToolUse hook)
# Blocks write tools targeting /standards/ or /exemplars/ (Constitution Principle I).
# Claude Code protocol: stdin JSON {tool_name, tool_input}; exit 2 + stderr = block.
$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$ti = $data.tool_input
if ($null -eq $ti) { exit 0 }

$filePath = $null
foreach ($field in @("file_path", "path", "notebook_path")) {
    $val = $ti.$field
    if ($null -ne $val -and "$val" -ne "") { $filePath = "$val"; break }
}
if ($null -eq $filePath) { exit 0 }

$normalized = $filePath.Replace('\', '/')
foreach ($segment in @("/standards/", "/exemplars/")) {
    if ($normalized.ToLower().Contains($segment) -or
        $normalized.ToLower().StartsWith($segment.TrimStart('/'))) {
        [Console]::Error.WriteLine("BLOCKED: '$filePath' is inside an immutable directory (/standards/ or /exemplars/).")
        [Console]::Error.WriteLine("Constitution Principle I: these paths are human-curated and READ ONLY to agents.")
        [Console]::Error.WriteLine("Stop and escalate per .github/instructions/escalation-protocol.instructions.md.")
        exit 2
    }
}
exit 0
