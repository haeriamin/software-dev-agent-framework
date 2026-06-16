# Software Development Agent Framework — Codex CLI instructions

Standalone, spec-driven, multi-agent development platform. **The constitution at
`.specify/memory/constitution.md` is supreme law**; these rules are operational refinements.
This is the Codex adapter's global-rules file — peer to `CLAUDE.md` (Claude Code) and
`.github/copilot-instructions.md` (Copilot); the rules are identical. Personas live at
`.codex/agents/*.toml`; slash commands use the `/dev.analyze` form.

## Non-Negotiables

1. **No product code in this repo.** Code lives at external paths registered in `targets/<id>.yml`
   (register via `/dev.target`). Never operate on an unregistered path.
2. **`/standards/` and `/exemplars/` are READ ONLY** (hook-enforced). Human curation only.
3. **Bootstrap before touching target code** (Principle II): read `wiki/index.md` →
   `wiki/standards-summary.md` → `wiki/pattern-library.md` → `wiki/exception-registry.md` →
   `targets/<id>.yml`. Never rely on model-trained convention knowledge — use the
   `standards-retrieval` skill. *Within an active slice, work from the slice's analysis + plan
   (bootstrap economy); the Reviewer still re-reads `/standards/` source.*
4. **Cite or don't ship** (Principle III): every change cites its spec requirement
   (`specs/NNN-*/spec.md §FR-X`) + standard clause (`standards/<file>.md §<RULE-ID>`) + exemplar
   basis when one exists.
5. **Reversible only** (Principle VI): work on branch `sdd/<slice>` (git targets) or back up
   originals first. NEVER merge, push, or commit to a target's default branch without explicit
   human instruction.
6. **Annotate, never silently skip** (Principle IV): unresolved work gets a `DEV-STATUS` block +
   exception-registry entry.
7. **Log everything** (Principle VII): append to `wiki/log.md` after any state-changing operation.
8. **Write in plain, simple English** (constitution §Output Language): short sentences, common
   words, explain jargon. Keep ids, citations, paths, and code exact; only the prose is plain.

## Confidence Gates (Principle V)

`confidence = 0.40·test_evidence + 0.35·standards_compliance + 0.25·spec_alignment`

PASS ≥ 0.85 · CONDITIONAL_PASS 0.70–0.84 · PARTIAL 0.60–0.69 (annotate the rest) · < 0.60 ESCALATE.
FAIL at review → max 2 implementer retries, then `/dev.review-escalated`. Escalation is a success
path — never guess to avoid it.

## Structure (Codex specifics)

- Canonical procedure lives in `.specify/extensions/dev/commands/*.md` runbooks — commands and
  personas are thin adapters. Change behavior in the runbook, never in an adapter.
- Personas are `.codex/agents/<persona>.toml` (`developer_instructions` = the shared persona body;
  `sandbox_mode` carries the read/write posture). They delegate to each other through artifacts
  (queue files, review reports), never direct calls.
- The Orchestrator spawns each persona as a SEPARATE subagent so the Reviewer stays independent.
- Behavioral protocols: `.github/instructions/*.instructions.md` (runtime-neutral; they apply here).
- Hooks: `.codex/hooks.json` (or `[hooks]` in `~/.codex/config.toml`) wire the same scripts as the
  other runtimes — the `/standards/` + `/exemplars/` read-only guard is hook-enforced.
- One-shot pipeline: `/dev.feature <target> "<description>"` runs the full lifecycle. Full reference:
  `COMMANDS.md`. Lifecycle: `/speckit.specify → clarify → plan → tasks → implement → analyze`.

> Adapter status: proof-of-concept. Personas wired so far: Tester, Reviewer, Orchestrator
> (`.codex/agents/`). See `.codex/README.md` for the full mapping and `.codex/VERIFICATION.md` for
> the spike that must pass before porting the remaining personas.
