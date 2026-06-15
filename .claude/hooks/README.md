# Claude Code Hooks

Three hooks enforce the constitution at the tool-call boundary:

| Hook | Event | Behavior |
|------|-------|----------|
| `validate-immutable-paths` | PreToolUse (Write/Edit/MultiEdit/NotebookEdit) | **Blocks** writes to `/standards/` and `/exemplars/` (exit 2 + stderr per Claude Code protocol) |
| `validate-bash-safety` | PreToolUse (Bash) | **Blocks** shell writes touching `/standards/` or `/exemplars/`, and `git push` / `git merge` (human-only, Principle VI). Conservative: an immutable path + any write token in one command is blocked even if the write targets elsewhere — re-form the command |
| `log-tool-use` | PostToolUse | Appends file writes to `wiki/log.md` (Principle VII); never blocks. Shell-mediated file changes are NOT auto-logged — runbooks require the acting agent to append its own entry |
| `check-code-quality` | PostToolUse | Warns on conflict markers, debug statements, unannotated TODOs; never blocks |

**Honest scope note**: hooks raise the cost of violation; they are not a sandbox. A
sufficiently creative command could still evade string matching — the Reviewer's
source-grounded verification and the human-only merge are the backstops.

## Platform switch

`.claude/settings.json` ships wired to the **PowerShell** variants (Windows). On macOS/Linux,
swap each command for the `.sh` sibling, e.g.:

```json
"command": "bash .claude/hooks/validate-immutable-paths.sh"
```

and `chmod +x .claude/hooks/*.sh`. The `.sh` variants require `python3` on PATH for JSON parsing.

Defense in depth: the same paths are also denied via `permissions.deny` in settings.json,
and `/dev:*` runbooks instruct agents to respect the boundary in their own logic.
