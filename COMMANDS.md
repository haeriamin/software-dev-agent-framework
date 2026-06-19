# Command Reference

Every command available in the framework, for new users and agents. Canonical procedure
for each `/dev.*` command lives in `.throughline/extensions/dev/commands/<command>.md`.

**Slash syntax**: this file writes the **Claude Code colon form** (`/dev:analyze`), the default
across the docs. Copilot, Codex, and Cursor use the dot form (`/dev.analyze`); the mapping is
mechanical.

---

## One-time setup

Pick your tool and run the installer from the repo root. It generates the thin adapter files from
`.throughline/adapters/source/` and wires hooks for your OS.

```bash
bash tools/install.sh --list                 # Git Bash / macOS / Linux
bash tools/install.sh --tool claude          # one tool
powershell -ExecutionPolicy Bypass -File tools\install.ps1 -Tool claude   # Windows PowerShell
```

See [docs/runtimes/](docs/runtimes/) for per-tool walkthroughs. To regenerate adapters after editing
the source: `bash tools/convert.sh --tool <id>` (or `tools/convert.ps1 -Tool <id>`).

---

## The One-Shot Entry Point

| Command | Arguments | What happens |
|---------|-----------|--------------|
| `/dev:feature` | `<target-id> "<description>" [--express] [--micro] [--audit]` | Runs the entire lifecycle from one request: specify → clarify → plan (+analysis) → design if HIGH → tasks → implement → test → review. **Empty target → greenfield mode**: design becomes mandatory and `/dev:scaffold` runs before implement. Pauses only at constitutional gates; resumes idempotently if re-run. `--express` skips the optional spec/plan gates (LOW/MEDIUM). `--micro` collapses to implement→test→review for a genuinely small LOW change (no contract/schema/security surface) — keeps the gates, drops the planning paperwork. |

New to the framework? Register a target, then run this:

```
/dev:target register path/to/my-app            # existing codebase
/dev:feature my-app "Add cursor pagination to the orders endpoint"

/dev:target register path/to/new-app --new     # brand-new project
/dev:feature new-app "A CLI tool that converts CSV to Parquet"
```

---

## Lifecycle Commands

Run individually when you want phase-by-phase control instead of `/dev:feature`.

**Slash syntax**: lifecycle commands use the `/throughline:*` namespace (e.g. `/throughline:specify`). Copilot, Codex, and Cursor use the dot form (`/throughline.specify`).

| Command | Arguments | Produces | Notes |
|---------|-----------|----------|-------|
| `/throughline:constitution` | `[amendment]` | Amended `.throughline/memory/constitution.md` | Human approval + version bump required |
| `/throughline:specify` | `"<description incl. target>"` | `specs/NNN-*/spec.md` | WHAT + WHY; records the Target; max 3 `[NEEDS CLARIFICATION]` |
| `/throughline:clarify` | — | Resolved markers in spec.md | Max 3 questions per run; waits for your answers |
| `/throughline:plan` | `[context]` | `specs/NNN-*/plan.md` | `before_plan` hook runs `/dev:analyze`; HIGH/CRITICAL requires `/dev:design` |
| `/throughline:tasks` | — | `specs/NNN-*/tasks.md` | Atomic, dependency-ordered; every task cites FR + standard |
| `/throughline:implement` | — | Implemented slice on branch `sdd/<slice>` | Chains `/dev:implement` → `/dev:test` → `/dev:review` (mandatory) |
| `/throughline:analyze` | — | Consistency-matrix report | Cross-artifact check; routes findings to the owning phase |
| `/throughline:checklist` | `[requirements\|design\|implementation\|release]` | `specs/NNN-*/checklists/<type>.md` | Verifies; never modifies artifacts |

## Agent Commands

| Command | Persona | Arguments | Writes |
|---------|---------|-----------|--------|
| `/dev:feature` | Orchestrator | `<target-id> "<desc>" [--express] [--micro] [--audit]` | Drives all phase commands (greenfield auto-detected: +design +scaffold; `--micro` collapses to implement→test→review); queue state; log |
| `/dev:target` | Orchestrator | `register <path> [--id <id>] [--new]` · `inspect <id>` · `update <id> <k>=<v>` · `list` | `targets/<id>.yml`, `<id>.code-workspace`, per-tool access (Claude `settings.local.json`, workspace for VS Code/Cursor, Codex config note) |
| `/dev:ingest-standards` | Archivist | — | `wiki/standards-summary.md` (+ concepts, index, log) |
| `/dev:ingest-exemplars` | Archivist | — | `wiki/pattern-library.md` (+ concepts, index, log) |
| `/dev:ideate` | Analyst | `"<rough idea>" [target-id]` | `work-queue/pending/<topic>-ideation.md` — read-only brainstorming before any spec; explores options/trade-offs/risks, recommends a direction, builds nothing |
| `/dev:analyze` | Analyst | `<target-id> [scope]` | `work-queue/in-progress/<slice>-analysis.md` |
| `/dev:design` | Architect | `<slice-id>` | `specs/NNN-*/design.md` + ADR index entries (required for HIGH/CRITICAL) |
| `/dev:scaffold` | Implementer | `<slice-id>` | Greenfield skeleton at the target with verified-green test/lint loop |
| `/dev:implement` | Implementer | `<slice-id>` | Target source on `sdd/<slice>` + Decision Records per task + `<target>/.throughline/CHANGELOG.md` entry |
| `/dev:test` | Tester | `<slice-id>` | Target test files + `review-reports/<target>/<slice>-tests.md` (real execution evidence) |
| `/dev:review` | Reviewer | `<slice-id>` | `review-reports/<target>/<slice>-review.md` — PASS / CONDITIONAL_PASS / FAIL |
| `/dev:audit` | Auditor | `[target-id]` | `review-reports/portfolio-summary.md` + `recommendations.md` |
| `/dev:lint-wiki` | Archivist | `[--write]` | Findings table (links, staleness, citation + skill parity, log integrity, concept-page scope) |
| `/dev:review-escalated` | Orchestrator + human + Archivist | — | `wiki/exception-registry.md` entries + queue moves; waits for your decisions |

---

## Gates Cheat Sheet

`confidence = 0.40·test_evidence + 0.35·standards_compliance + 0.25·spec_alignment`

| Verdict | Confidence | Then |
|---------|-----------|------|
| PASS | ≥ 0.85 | Merge-ready (merging is always human) |
| CONDITIONAL_PASS | 0.70–0.84 | Merge-ready + flagged items for spot-check |
| FAIL | < 0.70 or structural fail | Back to Implementer; max 2 retries → escalate |

Never skipped, in any mode: clarification answers · HIGH design approval · CRITICAL
hand-over (human-led) · escalations · merge/push.

---

## Skills (invoked by agents, or directly)

| Skill | Purpose |
|-------|---------|
| `standards-retrieval` | Rules from `/standards/` with §RULE-ID citations for a topic |
| `exemplar-retrieval` | Top-N relevant exemplars (+ anti-patterns) for a pattern class |
| `codebase-mapper` | Normalized module inventory of a target scope (JSON + fingerprint) |
| `pattern-matcher` | Match a need to a `wiki/pattern-library.md` pattern + best exemplar |
| `diff-generator` | Standards-annotated diff paired with Decision Records |
| `wiki-writer` | Create/update wiki pages in the standard format |
| `compliance-checker` | Per-rule verdicts over a file/diff + the `standards_compliance` ratio |
| `test-scaffolder` | Test skeletons per the target's framework and testing standards |

## Personas

| Persona | Role (one line) |
|---------|-----------------|
| Orchestrator | Entry point; targets, queue, delegation, escalation — never edits code |
| Archivist | Only writer of `/wiki/` content; ingests standards + exemplars |
| Analyst | Read-only codebase understanding; analysis reports with fingerprints |
| Architect | `design.md` + ADRs for HIGH/CRITICAL; never edits source |
| Implementer | Code at the target on `sdd/<slice>`; cites spec + standard; never merges |
| Tester | Test authoring + real execution evidence; never alters non-test source |
| Reviewer | Independent gate; re-reads `/standards/` source; PASS/CONDITIONAL/FAIL |
| Auditor | Portfolio roll-ups, systemic patterns, exemplar gaps; recommends only |

---

## Running it cheap (fewest tokens)

The full process is many model steps. Match the effort to the risk:

| Option | Use when | What it does |
|--------|----------|--------------|
| `/dev:feature --micro` | Small, low-risk change; no API or security part | implement → test → review only; skips spec/plan/design/tasks |
| `/dev:feature --express` | Low/medium risk, you trust the plan | Skips the two approval pauses |
| Single commands (`/dev:analyze`, `/dev:review`) | Quick check, no full task | One step, no full process |
| Reusing reads (automatic) | Any multi-step task | Later steps read the task's own analysis + plan, not the whole wiki again |
| Plain Copilot/Claude Code | You don't need the checks | Cheapest — skip the framework |

**Does it save tokens?** Per task, no — it runs more steps, so it costs more. Over time it
can pay off, like insurance: you pay a little extra on every task, and you get it back on the
tasks where it catches a bug that would cost a lot to fix later. Worth it for important code;
not worth it for throwaway code — use the cheap options above there.

## Typical Flows

```
First-time setup     tools/install.sh --tool <your-tool> → /throughline:constitution → /dev:ingest-standards → /dev:ingest-exemplars
Add a feature        /dev:target register <path> → /dev:feature <id> "<description>"
Greenfield project   /dev:target register <path> --new → /dev:feature <id> "<description>"
Phase-by-phase       /throughline:specify → /throughline:clarify → /throughline:plan → [/dev:design] → /throughline:tasks → [/dev:scaffold] → /throughline:implement
Maintenance          /dev:audit → /dev:review-escalated → /dev:lint-wiki
```
