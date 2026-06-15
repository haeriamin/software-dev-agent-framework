# validate-bash-safety.ps1 (Copilot PreToolUse hook — terminal/run commands)
# Same guard as the Claude variant: blocks shell writes touching /standards/ or /exemplars/,
# and `git push` / `git merge` (human-only, Constitution Principle VI).
# Protocol: stdin JSON; reads tool_input.command (or command at top level); exit 1 = block.
$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $data = $raw | ConvertFrom-Json } catch { exit 0 }

$ti = $data
if ($null -ne $data.tool_input) { $ti = $data.tool_input }
$cmd = $ti.command
if ($null -eq $cmd -or "$cmd" -eq "") { exit 0 }
$c = "$cmd".Replace('\', '/')

if ($c -match '(^|[;&|]\s*)git\s+(push|merge)\b') {
    Write-Output "BLOCKED: 'git push' / 'git merge' are human-only actions (Constitution Principle VI)."
    Write-Output "Present the sdd/<slice> branch in your report; the human merges."
    exit 1
}

if ($c -match '(^|/|\s|["'']|=)(standards|exemplars)/') {
    $writeTokens = '(>|>>|\btee\b|\bcp\b|\bmv\b|\brm\b|\brmdir\b|\btouch\b|\bln\b|\bsed\s+-i\b|\bdd\b|\binstall\b|Set-Content|Add-Content|Out-File|Copy-Item|Move-Item|Remove-Item|New-Item)'
    if ($c -match $writeTokens) {
        Write-Output "BLOCKED: shell command combines an immutable path (/standards/ or /exemplars/) with a write operation (Constitution Principle I)."
        Write-Output "These directories are human-curated and READ ONLY to agents. Read without redirection, or stop and escalate."
        exit 1
    }
}
exit 0
