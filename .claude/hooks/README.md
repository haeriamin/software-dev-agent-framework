# Claude Code Hooks

Four hooks enforce the constitution at the tool-call boundary:

| Hook | Event | Behavior |
|------|-------|----------|
| `validate-immutable-paths` | PreToolUse (Write/Edit/MultiEdit/NotebookEdit) | **Blocks** writes to `/standards/` and `/exemplars/` (exit 2 + stderr per Claude Code protocol) |
| `validate-bash-safety` | PreToolUse (Bash) | **Blocks** shell writes touching `/standards/` or `/exemplars/`, and `git push` / `git merge` (human-only, Principle VI). Conservative: an immutable path + any write token in one command is blocked even if the write targets elsewhere — re-form the command |
| `log-tool-use` | PostToolUse | Appends file writes to `wiki/log.md` (Principle VII); never blocks. Shell-mediated file changes are NOT auto-logged — runbooks require the acting agent to append its own entry |
| `check-code-quality` | PostToolUse | Warns on conflict markers, debug statements, unannotated TODOs; never blocks |

**Honest scope note**: hooks raise the cost of violation; they are not a sandbox. A
sufficiently creative command could still evade string matching — the Reviewer's
source-grounded verification and the human-only merge are the backstops.

## Platform setup (Windows / macOS / Linux)

No single hook command works on every OS — Windows runs `py`/`powershell`, macOS/Linux run
`python3`, and `bash` isn't on the Windows PATH outside Git Bash. So the per-OS wiring is
generated once, into the gitignored `.claude/settings.local.json`, by a setup step:

```bash
# Windows
py tools\setup-hooks.py
# macOS / Linux
python3 tools/setup-hooks.py
```

It picks `powershell -File …​.ps1` on Windows and `bash …​.sh` on macOS/Linux, and also rebuilds
`.codex/hooks.json` for Codex. Both script variants are kept in sync (`.ps1` parses JSON with
`ConvertFrom-Json`; `.sh` resolves `python3`/`python`/`py`). Re-run it after switching OS.

The committed `.claude/settings.json` carries **no** OS-specific commands — only the cross-platform
`permissions.deny` guard on `/standards/` and `/exemplars/`, which is always on even before setup.

Defense in depth: that declarative deny backs up the file-write hook, and `/dev:*` runbooks
instruct agents to respect the boundary in their own logic. Hooks raise the cost of violation;
the Reviewer's source-grounded check and the human-only merge are the real backstops.
