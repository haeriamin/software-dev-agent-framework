# Software Development Agent Framework — Claude Code Instructions

Standalone, spec-driven, multi-agent development platform. **The constitution at `.specify/memory/constitution.md` is supreme law**; these rules are operational refinements. Slash syntax here is `/dev:analyze` (docs elsewhere write the Copilot form `/dev.analyze` — mapping is mechanical).

## Non-Negotiables

1. **No product code in this repo.** Code lives at external paths registered in `targets/<id>.yml` (register via `/dev:target` — grants access through `.claude/settings.local.json`). Never operate on an unregistered path.
2. **`/standards/` and `/exemplars/` are READ ONLY** (hook-enforced). Human curation only.
3. **Bootstrap before touching target code** (Principle II): read `wiki/index.md` → `wiki/standards-summary.md` → `wiki/pattern-library.md` → `wiki/exception-registry.md` → `targets/<id>.yml`. Never rely on model-trained convention knowledge — use the `standards-retrieval` skill. *Within an active slice, work from the slice's analysis + plan instead of re-reading the full wiki (bootstrap economy); the Reviewer still re-reads `/standards/` source.*
4. **Cite or don't ship** (Principle III): every change cites its spec requirement (`specs/NNN-*/spec.md §FR-X`) + standard clause (`standards/<file>.md §<RULE-ID>`) + exemplar basis when one exists.
5. **Reversible only** (Principle VI): work on branch `sdd/<slice>` (git targets) or back up originals first. NEVER merge, push, or commit to a target's default branch without explicit human instruction.
6. **Annotate, never silently skip** (Principle IV): unresolved work gets a `DEV-STATUS` block + exception-registry entry.
7. **Log everything** (Principle VII): append to `wiki/log.md` after any state-changing operation.
8. **Write in plain, simple English** (constitution §Output Language): every spec, plan, report, review, wiki page, and code comment uses short sentences and common words. Explain any jargon. Many readers are not native English speakers. Keep ids, citations, paths, and code exact; only the prose is plain.

## Confidence Gates (Principle V)

`confidence = 0.40·test_evidence + 0.35·standards_compliance + 0.25·spec_alignment`

PASS ≥ 0.85 · CONDITIONAL_PASS 0.70–0.84 · PARTIAL 0.60–0.69 (annotate the rest) · < 0.60 ESCALATE. FAIL at review → max 2 implementer retries, then `/dev:review-escalated`. Escalation is a success path — never guess to avoid it.

## Structure

- One-shot pipeline: `/dev:feature <target> "<description>"` runs the full lifecycle from a single request (empty target → greenfield mode: +design +scaffold). Full command reference: `COMMANDS.md`.
- Lifecycle: `/speckit:specify → clarify → plan → tasks → implement → analyze`; `/dev:*` commands compose in via hooks in `.specify/extensions.yml` (protocol: `.github/instructions/extension-hooks.instructions.md`).
- Canonical procedure lives in `.specify/extensions/dev/commands/*.md` runbooks — commands and subagents are thin adapters. Change behavior in the runbook, never in an adapter.
- Delegate phase work to the matching subagent (`.claude/agents/`); agents communicate through artifacts (queue files, reports), never direct calls.
- Behavioral protocols: `.github/instructions/*.instructions.md` (runtime-neutral; they apply here).
- Skills mirror `.github/skills/` byte-identically — edit there, copy here (`/dev:lint-wiki` checks).
