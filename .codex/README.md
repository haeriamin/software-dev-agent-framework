# Codex CLI runtime adapter

The **third runtime** for the framework, peer to `.claude/` (Claude Code) and `.github/` (Copilot).
Per ARCHITECTURE.md §14 ("one brain, N adapters"), the canonical content — runbooks
(`.specify/extensions/dev/commands/*.md`), `.github/instructions/*`, `standards/`, `specs/`,
`wiki/` — is runtime-neutral and reused **unchanged**. This folder is only the thin Codex adapter.

## What's implemented (complete)
| Piece | Location | Notes |
|---|---|---|
| 8 personas | `.codex/agents/*.toml` | `developer_instructions` = the shared persona body; `tools`→`sandbox_mode` |
| 21 commands | `.codex/prompts/*.md` | `/dev.*` + `/speckit.*`; generated from the canonical Claude command bodies |
| Global rules | `../AGENTS.md` | peer to `CLAUDE.md` / `.github/copilot-instructions.md` (same non-negotiables) |
| Hooks | `.codex/hooks.json` | read-only `/standards/`+`/exemplars/` guard, git push/merge guard, `wiki/log.md` logger, quality lint — reuses the shipped scripts |
| Config | `.codex/config.toml` | project-doc + fallback to `CLAUDE.md`; pointers |
| Spike | `.codex/VERIFICATION.md` | the one runtime behaviour to confirm before trusting it |

## Install & use
Codex CLI isn't bundled here. On a machine with it:
```bash
codex --version
export OPENAI_API_KEY="$(grep -E '^OPENAI_API_KEY=' ~/.sdd_keys.env | cut -d= -f2-)"   # or: codex login
cd <this repo>
# personas + hooks + AGENTS.md load from the repo's .codex/ layer (run `/hooks` once to trust them).
# Codex reads custom prompts from ~/.codex/prompts (global), so expose the slash commands by copying:
cp .codex/prompts/*.md ~/.codex/prompts/        # (or symlink). New session to pick them up.
codex
```
Then drive it exactly like the other runtimes: `/dev.feature <target> "<desc>"`, `/dev.analyze`,
`/speckit.specify`, etc. (Codex uses the `/dev.x` dot form; Claude Code uses `/dev:x`.)

## Mapping (framework concept → Codex)
| Framework | Claude Code | Copilot | Codex |
|---|---|---|---|
| Persona | `.claude/agents/<p>.md` | `.github/agents/<p>.agent.md` | `.codex/agents/<p>.toml` (`developer_instructions`) |
| Per-tool perms | `tools: Read, Write, …` | `tools: [read/readFile, …]` | `sandbox_mode` (`read-only` / `workspace-write`) — coarser; read/write discipline stays in the persona text |
| Global rules | `CLAUDE.md` | `.github/copilot-instructions.md` | `AGENTS.md` |
| Command | `.claude/commands/**/<cmd>.md` | `.github/agents/<cmd>.agent.md` + prompt | `.codex/prompts/<ns>.<cmd>.md` |
| Hooks | `.claude/settings.local.json` (wired by `tools/setup-hooks.{ps1,sh}`) | `.github/hooks/hooks.json` (per-OS `windows` override) | `.codex/hooks.json` (rebuilt by `tools/setup-hooks.{ps1,sh}`; same scripts, Codex tool-name matchers) |
| Agent-to-agent | subagents | `handoffs:` frontmatter | explicit spawn (no declarative graph — stated in prose) |

`sandbox_mode` by persona: all default to `workspace-write` because each writes *some* artifact
(reports, wiki, target code); the read-only-over-source discipline (analyst, auditor, reviewer,
architect) is enforced by the persona text, exactly as the other two runtimes enforce it via prose
despite holding a broad write tool.

## Three things to verify / wire before trusting it (see VERIFICATION.md)
1. **Autonomous, isolated sub-agent spawning** — the Orchestrator must spawn each persona (esp. an
   independent Reviewer) without per-step human invocation. Codex spawns "only when you explicitly
   ask," and openai/codex#15250 flagged subagent invocation from tool-backed sessions as maturing.
   If it doesn't hold: fall back to an external `codex exec` shim, or a sequential single-agent mode
   (which loses the independent-Reviewer constitutional gate — flag as degraded).
2. **Hook payload for `apply_patch`** — Codex sends the same stdin-JSON + exit-2 protocol as Claude
   Code, but routes edits through `apply_patch` (a patch diff) rather than `Write{file_path}`. Confirm
   `validate-immutable-paths` reads the patch target; if not, add a few lines to parse the `apply_patch`
   input shape. The `Bash` guard and the loggers are unaffected.
3. **Skills exposure** — the personas reference framework skills by name (`test-scaffolder`,
   `compliance-checker`, `standards-retrieval`, etc.) that live in `.github/skills/` ≡ `.claude/skills/`.
   Codex agents register skills via the `skills.config` field (or a skills dir); wire each persona's
   skills there, or confirm Codex can load the shared `SKILL.md` files, so the Reviewer/Analyst keep
   their tooling. Until then those skill calls are no-ops on Codex.

## Status
All adapter files are authored and consistent with the other two runtimes. The open work is the
three items above (a ~1-day spike), after which this is a fully supported third runtime.
