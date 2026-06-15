# Software Development Agent Framework
## Architecture & Implementation Guide (SDD-native)

> Canonical patterns: [spec-kit](https://github.com/github/spec-kit) for the SDD lifecycle, [Kumo Coding Agent](https://github.com/kumo-ai/kumo-coding-agent) for multi-agent topology. Agent files follow the native VS Code Copilot agent format (`description` + `handoffs` frontmatter) and the Claude Code subagent format (`name` + `description` + `tools` frontmatter). Both runtimes execute identical canonical runbooks.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Constitution & Governance](#2-constitution--governance)
3. [Repository & Folder Structure](#3-repository--folder-structure)
4. [Standalone Operation: Targets](#4-standalone-operation-targets)
5. [SDD Lifecycle](#5-sdd-lifecycle)
6. [Agent Roles & Responsibilities](#6-agent-roles--responsibilities)
7. [Extension: Dev Commands](#7-extension-dev-commands)
8. [Skills](#8-skills)
9. [Instruction Files](#9-instruction-files)
10. [Hooks & Workflow Automation](#10-hooks--workflow-automation)
11. [Knowledge Ingestion](#11-knowledge-ingestion)
12. [Safe Autonomous Implementation](#12-safe-autonomous-implementation)
13. [Testing & Review Gates](#13-testing--review-gates)
14. [Dual-Runtime Strategy (Copilot + Claude Code)](#14-dual-runtime-strategy)
15. [VS Code Dashboard Extension](#15-vs-code-dashboard-extension)
16. [Scaling Strategy](#16-scaling-strategy)
17. [Appendix: Quick Reference](#17-appendix-quick-reference)

---

## 1. System Overview

A **multi-agent, spec-driven software development platform** running inside VS Code with GitHub Copilot or inside Claude Code. Three complementary layers:

- **SDD layer** (spec-kit) — every development unit is a *slice* that flows through specify → clarify → plan → tasks → implement → analyze. Provides reproducibility, review gates, and a unified vocabulary for "what we're changing and why."
- **Dev layer** (the `dev` spec-kit extension) — domain commands (`/dev.analyze`, `/dev.implement`, `/dev.review`, …) and personas (Analyst, Architect, Implementer, Tester, Reviewer, …) that compose into the SDD layer via extension hooks.
- **Target layer** — the framework is standalone; product code lives at external paths registered in `targets/`. Every command resolves its working surface from the active target.

### Design Philosophy

| Principle | Implementation |
|-----------|---------------|
| **Spec-driven** | Every slice has a `specs/NNN-*` folder with `spec.md`, `plan.md`, `tasks.md` (+ `design.md` for HIGH complexity). No code change without a slice. |
| **Constitution-bound** | `.specify/memory/constitution.md` is the supreme law; all agents, prompts, and hooks defer to it. |
| **Standalone, multi-project** | Framework state and knowledge live here; code lives at registered external paths. Knowledge compounds across projects. |
| **Autonomy first, within bounds** | Agents act without asking inside their confidence band; below it, they escalate. |
| **Standards as law** | All implementation is gated by `/standards/` + curated `/exemplars/`. |
| **Exemplars as memory** | Reference implementations and anti-patterns are first-class knowledge, compiled into `wiki/pattern-library.md`. |
| **Wiki as ground truth** | The agent-maintained `/wiki/` accumulates engineering intelligence; `wiki/log.md` is the append-only audit trail. |
| **Runtime-agnostic** | Copilot and Claude Code adapters are thin; canonical runbooks are shared. |

### Agent Topology

```
User
  │
  ▼
[/speckit.*]  ← SDD entry points (specify, plan, tasks, implement, analyze, …)
  │
  ▼
OrchestratorAgent  ◄────────────────────────────────────────────────┐
  │                                                                 │
  ├──► ArchivistAgent    (standards + wiki maintenance)             │
  ├──► AnalystAgent      (target codebase understanding)            │
  ├──► ArchitectAgent    (design + architecture decisions)          │
  ├──► ImplementerAgent  (code writing at target path)              │
  ├──► TesterAgent       (test authoring + execution at target)     │
  ├──► ReviewerAgent     (correctness + compliance gate)            │
  └──► AuditorAgent      (portfolio reporting) ─────────────────────┘
```

All agents share read access to `/wiki/`, `/standards/`, `/exemplars/`, and `/targets/`. The Orchestrator coordinates cross-agent handoffs. Cross-agent communication happens through artifacts (queue files, test reports, review reports), never via direct agent-to-agent calls.

---

## 2. Constitution & Governance

`.specify/memory/constitution.md` enumerates seven core principles (Immutable Source of Truth, Knowledge Before Action, Cite or Don't Ship, Annotate Never Silently Skip, Confidence-Gated Autonomy, Reversible Changes Only, Append-Only Operations Log), the write-boundary invariants table, and the amendment process.

Every `/speckit.plan` and `/speckit.implement` MUST verify produced artifacts against the active principles before reporting completion. Conflicts with any other file resolve in favor of the constitution.

Amendment process: `/speckit.constitution` → semantic version bump → `wiki/log.md` entry citing the change.

---

## 3. Repository & Folder Structure

See `docs/02-concepts.md §Repository layout` for the full tree. Key invariants:

| Path | Writers | Readers |
|------|---------|---------|
| `/standards/**` | Humans only | All agents |
| `/exemplars/**` | Humans only | All agents |
| `/wiki/**` (excl. log) | Archivist; Auditor recommends only | All agents |
| `/wiki/log.md` | All agents (append-only) | All agents |
| `/specs/**` | Spec workflow agents; Architect | All agents |
| `/targets/**` | Orchestrator (via `/dev.target`) | All agents |
| `/work-queue/**` | Orchestrator; Analyst (analyses) | All agents |
| `/review-reports/**` | Reviewer, Tester, Auditor | All agents |
| `<target>/**` | Implementer (source), Tester (tests) — inside an active slice only | Analyst, Reviewer, Auditor |

Hooks at `.github/hooks/scripts/validate-immutable-paths.*` and `.claude/hooks/validate-immutable-paths.*` enforce the read-only paths at the tool-call boundary.

---

## 4. Standalone Operation: Targets

The framework never contains product code. External projects are registered as **targets**:

```yaml
# targets/<id>.yml
id: my-app
path: "path/to/my-app"           # absolute path to the external project
vcs: git                          # git | none
default_branch: main
stack: [node, typescript, react]
test_command: "npm test"
lint_command: "npm run lint"
build_command: "npm run build"
complexity_class: MEDIUM          # LOW | MEDIUM | HIGH | CRITICAL (default for slices)
conventions: |
  Repo-specific notes that override nothing but inform everything.
exceptions: []                    # ids from wiki/exception-registry.md that apply here
status: active                    # active | paused | archived
registered: 2026-06-09
```

`/dev.target register <path>` creates this entry, probes the project (stack detection, git status, test runner), and generates:

- `targets/<id>.code-workspace` — a multi-root VS Code workspace (framework + target) so Copilot agents can edit the target.
- An `additionalDirectories` permission entry in `.claude/settings.local.json` (gitignored, machine-local) so Claude Code can edit the target.

**Slice ↔ target binding**: every `spec.md` records `**Target**: <id>` in its header. All `/dev.*` commands resolve paths through the target entry — never through hardcoded paths.

**Greenfield**: `/dev.target register <new-path> --new` creates the directory, initializes git, and marks the target for `/dev.scaffold`.

---

## 5. SDD Lifecycle

Each development slice is one spec-kit feature:

```
/speckit.specify  "Add cursor pagination to my-app's orders endpoint"
  ↓                                creates specs/NNN-orders-pagination/spec.md
                                   (template: spec-template.md; records Target)
/speckit.clarify
  ↓                                resolves [NEEDS CLARIFICATION] markers (max 3)

/speckit.plan
  ↓                                template: plan-template.md
                                   hook: before_plan → /dev.analyze produces
                                   the analysis report that grounds plan.md;
                                   HIGH/CRITICAL slices also run /dev.design

/speckit.tasks
  ↓                                template: tasks-template.md
                                   atomic, independently testable, ordered by layer

/speckit.implement
  ↓                                executes tasks; each task goes
                                   /dev.implement → /dev.test
                                   hook: after_implement → /dev.review (mandatory)

/speckit.analyze                   cross-artifact consistency check
  ↓                                hook: after_analyze → optional /dev.audit
```

Pre-packaged workflows (`.specify/workflows/`): `dev-feature` (existing codebase) and `dev-greenfield` (new project, inserts `/dev.scaffold` between tasks and implement). Both chain the phases with explicit review gates.

---

## 6. Agent Roles & Responsibilities

Eight single-purpose personas, no overlap. Each persona lives at `.github/agents/<persona>.agent.md` (Copilot) and `.claude/agents/<persona>.md` (Claude Code). Each `/dev.*` command has a thin agent file at `.github/agents/dev.<command>.agent.md` that delegates the runbook to `.specify/extensions/dev/commands/dev.<command>.md` and adopts the appropriate persona.

### 6.1 OrchestratorAgent

Single point of entry for user-facing development requests. Manages `targets/` and `work-queue/`, delegates to specialized agents, assembles results, determines when human escalation is required (Principle V).

### 6.2 ArchivistAgent

Institutional memory manager. Ingests standards and exemplars; maintains `wiki/index.md`, `wiki/log.md`, `wiki/standards-summary.md`, `wiki/pattern-library.md`, concept pages. Only writer of `/wiki/` content (except log appends).

**Triggers**: `/dev.ingest-standards`, `/dev.ingest-exemplars`, `/dev.lint-wiki`, plus `/dev.review-escalated` (recording role).

### 6.3 AnalystAgent

Deep target-codebase understanding. Produces structured analysis reports. Never edits source.

**Output**:
```markdown
## Analysis: <target-id> / <scope>
- Complexity Class: LOW / MEDIUM / HIGH / CRITICAL
- Affected Modules: [...]
- Dependency Map: [...]
- Existing Conventions Detected: [...]
- Standards Violations (pre-existing): [...]
- Matched Patterns: [...]
- Risk Register: [...]
- Recommended Approach: [...]
- Confidence: 0.XX
```

### 6.4 ArchitectAgent

Design authority for HIGH/CRITICAL slices (and on demand). Produces `specs/NNN-*/design.md` (component design, interfaces, data flow) and Architecture Decision Records indexed in `wiki/decision-registry.md`. Never edits source.

### 6.5 ImplementerAgent

Autonomous code-writing engine. Works only at the registered target path, only inside an active slice with an approved plan, guided by `wiki/pattern-library.md`, `wiki/standards-summary.md`, and ranked exemplars. Never merges — hands off to Tester/Reviewer.

**Implementation Decision Record** (one per task):
```markdown
### Task: T00N <name>
- Spec requirement: specs/NNN-<slice>/spec.md §FR-X
- Design basis: specs/NNN-<slice>/design.md §<n> (or "n/a — LOW complexity")
- Standard clause: standards/<file>.md §<RULE-ID>
- Exemplar basis: exemplars/<path> (or "none exists — pattern-matcher confirmed")
- Files changed: [...]
- Confidence: 0.XX
```

### 6.6 TesterAgent

Test authoring and execution at the target. Writes/updates tests covering changed behavior, runs the target's `test_command`, records results in `review-reports/<target>/<slice>-tests.md`. Never alters non-test source files.

### 6.7 ReviewerAgent

Gatekeeper. Independently re-reads standards from `/standards/` (not the wiki summaries) and the spec for every cited change. Consumes the Tester's report. Emits PASS / CONDITIONAL_PASS / FAIL per the constitutional thresholds.

### 6.8 AuditorAgent

Portfolio-wide quality. Aggregates review reports across targets, identifies systemic failure patterns, surfaces exemplar gaps. Read-only over source; writes to `/review-reports/` and produces recommendations for the Archivist.

---

## 7. Extension: Dev Commands

`.specify/extensions/dev/` is a spec-kit extension. Its `extension.yml` declares the thirteen `/dev.*` commands, a `dev-config.yml` template for per-framework overrides, and hook bindings into the SDD lifecycle:

- `before_plan` → `/dev.analyze` (optional)
- `before_implement` → `/dev.review` (optional — drift check on prior artifacts)
- `after_implement` → `/dev.review` (**mandatory** — Reviewer gate; runbook invokes `/dev.test` first)
- `after_analyze` → `/dev.audit` (optional)

The thirteen commands:

| Command | Persona | Writes |
|---------|---------|--------|
| `/dev.feature` | Orchestrator | One-shot pipeline — drives all phase commands below; empty targets auto-run greenfield mode (+design +scaffold); queue state, log |
| `/dev.target` | Orchestrator | `targets/<id>.yml`, `targets/<id>.code-workspace`, log |
| `/dev.ingest-standards` | Archivist | `wiki/standards-summary.md`, concept pages, log |
| `/dev.ingest-exemplars` | Archivist | `wiki/pattern-library.md`, concept pages, log |
| `/dev.analyze` | Analyst | `work-queue/in-progress/<slice>-analysis.md`, log |
| `/dev.design` | Architect | `specs/NNN-*/design.md`, `wiki/decision-registry.md` entry, log |
| `/dev.scaffold` | Implementer | target project skeleton (greenfield), scaffold report, log |
| `/dev.implement` | Implementer | target source on branch `sdd/<slice>`, Decision Records, log |
| `/dev.test` | Tester | target test files, `review-reports/<target>/<slice>-tests.md`, log |
| `/dev.review` | Reviewer | `review-reports/<target>/<slice>-review.md`, log |
| `/dev.audit` | Auditor | `review-reports/portfolio-summary.md`, recommendations, log |
| `/dev.lint-wiki` | Archivist (read-only) | stdout / optional `wiki/_lint-report.md`, log |
| `/dev.review-escalated` | Orchestrator + human + Archivist | `wiki/exception-registry.md`, queue moves, log |

Each command's runbook in `commands/dev.<name>.md` defines preconditions, steps, exit criteria, and failure modes. Agent files are thin wrappers that adopt the persona and follow the runbook.

---

## 8. Skills

Skills are reusable capability modules invoked by agents. Each lives at `.github/skills/<name>/SKILL.md` and `.claude/skills/<name>/SKILL.md` (identical content).

| Skill | Purpose | Used by |
|-------|---------|---------|
| `standards-retrieval` | Locate and structure content from `/standards/` docs | Archivist, Reviewer, Implementer |
| `exemplar-retrieval` | Find top-N most relevant exemplars for a pattern class | Analyst, Implementer, Reviewer |
| `codebase-mapper` | Structural scan of a target → normalized module inventory (JSON) | Analyst (primary), Architect |
| `pattern-matcher` | Match a code construct/need to `wiki/pattern-library.md` entry | Analyst, Implementer |
| `diff-generator` | Produce standards-annotated diff with Decision Records | Implementer, Reviewer |
| `wiki-writer` | Create/update wiki pages with standard format | Archivist, Orchestrator, Auditor |
| `compliance-checker` | Audit a file or diff against standards rules | Reviewer, Auditor |
| `test-scaffolder` | Generate test skeletons per testing standards for changed behavior | Tester |

**`codebase-mapper` output schema**:
```json
{
  "target": "my-app",
  "modules": [{"path": "", "language": "", "exports": [], "imports": [], "loc": 0}],
  "entry_points": [],
  "test_layout": {"framework": "", "locations": []},
  "build_system": "",
  "external_dependencies": [],
  "conventions_detected": {"naming": "", "structure": "", "error_handling": ""},
  "hotspots": [{"path": "", "reason": ""}]
}
```

---

## 9. Instruction Files

Behavioral instructions in `.github/instructions/` are loaded by agents at runtime. They refine but never override the constitution.

- `code-analysis.instructions.md` — Analyst step-by-step.
- `implementation-rules.instructions.md` — Implementer cardinal rules + change application order + annotation convention.
- `testing-standards.instructions.md` — Tester protocol: coverage expectations, test layering, evidence format.
- `review-protocol.instructions.md` — Reviewer pre-review, structural + semantic + standards checks, verdict thresholds.
- `escalation-protocol.instructions.md` — triggers, escalation artifact format, post-escalation flow.
- `extension-hooks.instructions.md` — shared protocol for checking `.specify/extensions.yml` hooks before/after each lifecycle phase.

---

## 10. Hooks & Workflow Automation

### 10.1 Tool-call hooks

**Copilot** (`.github/hooks/hooks.json`) and **Claude Code** (`.claude/settings.json`) wire the same three scripts (shipped as both `.sh` and `.ps1`):

| Hook | Event | Purpose |
|------|-------|---------|
| `validate-immutable-paths` | PreToolUse (file-write tools) | Blocks writes to `/standards/` and `/exemplars/` |
| `validate-bash-safety` | PreToolUse (Bash) | Blocks shell writes touching `/standards/` `/exemplars/`, and `git push`/`git merge` (human-only) — closes the shell bypass of the file-write hook |
| `log-tool-use` | PostToolUse | Auto-appends file writes to `wiki/log.md` (shell-mediated changes are logged by the acting agent per runbook) |
| `check-code-quality` | PostToolUse | Lightweight lint on written source files (TODO-without-annotation, merge-conflict markers, debug statements) |

Hooks raise the cost of violation; they are string-matched guards, not a sandbox. The
Reviewer's source-grounded verification and the human-only merge are the real backstops.

### 10.2 SDD extension hooks (`.specify/extensions.yml`)

Merged from the `dev` extension. Of note:

- `before_plan` runs `dev.analyze` (optional).
- `before_implement` runs `dev.review` (optional — drift check).
- `after_implement` runs `dev.review` (**mandatory**; its runbook requires a fresh `/dev.test` report first).
- `after_analyze` runs `dev.audit` (optional).

### 10.3 Built-in workflows

- `.specify/workflows/speckit/workflow.yml` — generic SDD cycle.
- `.specify/workflows/dev-feature/workflow.yml` — feature slice on an existing target with `/dev.*` hooks engaged and explicit review gates.
- `.specify/workflows/dev-greenfield/workflow.yml` — new project: target registration → spec → plan (+design) → tasks → scaffold → implement → review → audit.

---

## 11. Knowledge Ingestion

### 11.1 Bootstrap

Every agent runs the **Knowledge Bootstrap Sequence** before any action that touches target code (Principle II):

```
1. Read wiki/index.md                  → discover relevant pages
2. Read wiki/standards-summary.md      → current synthesized standards state
3. Read wiki/pattern-library.md        → known implementation patterns
4. Read wiki/exception-registry.md     → known edge cases + human decisions
5. Read targets/<id>.yml               → active target context
6. (Task-specific) standards-retrieval skill → targeted /standards/ extraction
7. NEVER rely on model-trained convention knowledge
```

### 11.2 Standards file format

Each `/standards/*.md` follows a machine-readable structure:

```markdown
# Standard Title
**Standard ID**: STD-001
**Effective Date**: YYYY-MM-DD
**Applies To**: [API | Services | Frontend | Data | All]

## Rules
### Rule API-01: <name>
**Severity**: BLOCKING | WARNING | INFO
**Description**: ...
**Check**: ...                 # prose check, evaluated by judgment when no Tool applies
**Tool**: <optional>           # executable check (linter rule, SAST, audit command);
                               # when present, its result SUPERSEDES judgment for this rule
**Example violation**: ...
**Compliant form**: ...
```

This lets `compliance-checker` parse rules without an external parser. **Honest framing**:
rules without a `**Tool**` are *policy-as-prose* — an LLM interprets the `Check`, which is
non-deterministic. Make security- and correctness-critical rules deterministic by giving
them a `Tool` (semgrep/CodeQL/gitleaks/linter rule); the Reviewer must run it and its
result wins. Prose checks are a starting point, not a guarantee — promote the ones that
matter to executable tools as your target's tooling allows.

### 11.3 Exemplar convention

Every exemplar has a companion metadata file:

```
exemplars/
  good/api/paginated-endpoint.ts
  good/api/paginated-endpoint.meta.md     ← required
  anti-patterns/god-service.ts
  anti-patterns/god-service.meta.md       ← required
```

Metadata schema:
```markdown
# Exemplar: paginated-endpoint
**Kind**: good | anti-pattern
**Pattern Class**: REST Pagination
**Languages**: [typescript]
**Standard References**: standards/api-design.md §API-02
**Complexity**: LOW
**Description**: …
**Tags**: rest, pagination, cursor, api
```

Tags drive `exemplar-retrieval` ranking without embeddings.

### 11.4 Pattern library structure

`wiki/pattern-library.md` is the compiled index, maintained by Archivist:

```markdown
## Pattern: <Name>
**Pattern ID**: PAT-NNN
**Class**: <e.g., REST Pagination>
**Exemplars**: [[exemplars/good/...]] (1+); anti-patterns: [[exemplars/anti-patterns/...]]
**Standard Basis**: standards/<file>.md §<RULE-ID>
**When to apply**: …
**Implementation Steps**: …
**Confidence typical range**: 0.XX–0.XX
```

### 11.5 Change propagation

On `/dev.ingest-standards`:
1. Archivist diffs new `/standards/` state against prior `wiki/standards-summary.md`.
2. Identifies wiki pages referencing changed standards; updates them.
3. Flags completed slices possibly affected (entry in `wiki/log.md`); Auditor surfaces these via `/dev.audit`.

### 11.6 Gap detection

Auditor tracks **exemplar gaps** — pattern classes needed ≥ 3 times without a curated exemplar. Gaps go into the recommendations file; humans must place new files in `/exemplars/` and re-run `/dev.ingest-exemplars` (agents never synthesize exemplars; Principle I).

### 11.7 Multi-target scoping

The wiki is shared across all registered targets **by design** — that is the knowledge-compounding mechanism (§16.3). Scoping keeps sharing safe:

| Artifact | Scoping |
|----------|---------|
| `standards-summary.md`, `pattern-library.md` | Global (org-wide law and reusable patterns; stack fit handled at retrieval time) |
| `decision-registry.md`, `log.md` | Per-entry `Target` column |
| `exception-registry.md` | Per-entry `Scope: this-slice-only \| this-target \| global` |
| `concepts/*` | Optional `**Scope**: target:<id>` header (default `global`); agents MUST ignore pages scoped to a different target (Principle II) |

`/dev.lint-wiki` check 9 enforces scope integrity. **Confidentiality boundaries are not a scoping problem**: targets belonging to different clients/employers must live in separate framework instances (fork per boundary) — the pattern library, exception registry, and log would otherwise leak engineering knowledge across the boundary.

---

## 12. Safe Autonomous Implementation

### 12.1 Complexity classification (per slice)

| Class | Criteria | Handling |
|-------|----------|----------|
| LOW | Single module, no schema/API contract change, no security surface | Fully autonomous |
| MEDIUM | 2–5 modules, internal API changes, standard patterns matched | Autonomous + CONDITIONAL review |
| HIGH | Cross-cutting, public API/schema change, new dependency, concurrency | `/dev.design` required; human-approved plan |
| CRITICAL | Auth/payments/PII, data migrations, prod infra | Human-led, agent-assisted only |

### 12.2 Atomicity

Each task is one logical unit of behavior, independently testable and reversible. No multi-concern tasks. Change application order inside a slice: scaffolding → interfaces/contracts → core logic → integration → tests hardening → docs.

### 12.3 Annotation convention for incomplete work

```text
/* ============================================================
   DEV-STATUS: PARTIAL
   Requirement: specs/NNN-<slice>/spec.md §FR-X
   Reason: <why this could not be completed confidently>
   Confidence: 0.58 (below threshold)
   Standard: standards/<file>.md §<RULE-ID> applies
   Wiki: [[wiki/concepts/<relevant-page>]]
   Action Required: Human review before finalizing
   Logged: work-queue/escalated/<slice>-escalation.md
   ============================================================ */
```

(Comment syntax adapts to the target language; structure is fixed.)

### 12.4 Rollback safety (Principle VI)

- Git targets: all work on branch `sdd/<slice-id>`; rollback = delete branch. Never commit to default branch; never push without human instruction.
- Non-git targets: originals copied to `work-queue/backups/<slice-id>/` before modification; rollback = restore copies.
- Every implementation report documents the exact rollback procedure.

### 12.5 Forbidden operations (Implementer)

- Delete code without replacement and annotation.
- Change observable behavior outside the spec's scope.
- Modify CI/CD configuration, secrets, or `.git/` internals of a target.
- Reduce test surface area.
- Remove comments or documentation.
- Add a new external dependency not named in the plan.

---

## 13. Testing & Review Gates

### 13.1 Three-layer review model

```
Layer 1: Structural (automated, always)
  └─ Naming conventions, forbidden constructs, file organization, lint clean
Layer 2: Behavioral (automated, always)
  └─ Tests pass; changed behavior covered; no regression in existing suites
Layer 3: Standards compliance (automated + human spot-check)
  └─ All active standard clauses, security, performance mandates
```

### 13.2 Verdict thresholds (Constitution Principle V)

| Verdict | Condition |
|---------|-----------|
| PASS | All structural pass; confidence ≥ 0.85 |
| CONDITIONAL_PASS | All structural pass; confidence 0.70–0.84 |
| FAIL | Any structural fail; OR confidence < 0.70 |

`confidence = 0.40·test_evidence + 0.35·standards_compliance + 0.25·spec_alignment`

FAIL → return to Implementer with itemized reasons; max 2 retries; then escalate.

### 13.3 Test evidence

Reviewer never trusts "tests pass" claims — it requires the Tester's report (`review-reports/<target>/<slice>-tests.md`) containing the actual command, exit code, and summary output. A missing or stale test report forces `test_evidence = 0`.

### 13.4 Portfolio dashboard

Auditor writes `review-reports/portfolio-summary.md` with verdict counts per target, top systemic issues, exemplar gaps, and recommended wiki updates. The VS Code dashboard extension renders this live.

---

## 14. Dual-Runtime Strategy

One brain, two adapters. The canonical content lives in runtime-neutral files:

```
.specify/extensions/dev/commands/*.md   ← runbooks (the WHAT and HOW of each command)
.specify/memory/constitution.md         ← law
.github/instructions/*.instructions.md  ← behavioral rules (runtime-neutral prose)
.github/skills/**  ≡  .claude/skills/** ← identical skill content
```

Adapters:

| Layer | Copilot file | Claude Code file | Content |
|-------|--------------|------------------|---------|
| Global rules | `.github/copilot-instructions.md` | `CLAUDE.md` | Same rules, same tables |
| Command entry | `.github/prompts/dev.analyze.prompt.md` (`agent:` pointer) | `.claude/commands/dev/analyze.md` | Thin: adopt persona, follow runbook, pass `$ARGUMENTS` |
| Persona | `.github/agents/analyst.agent.md` | `.claude/agents/analyst.md` | Same persona text; frontmatter differs (Copilot `tools:`/`handoffs:` vs Claude `name:`/`tools:`) |
| Hooks | `.github/hooks/hooks.json` | `.claude/settings.json` | Same scripts, both shells |

### File-count asymmetry (28 Copilot agents vs 8 Claude subagents — intentional)

Both runtimes have exactly **21 commands** and **8 personas**; they just package them differently:

| Layer | Copilot | Claude Code |
|-------|---------|-------------|
| Command body | `.github/agents/<cmd>.agent.md` (21) — Copilot prompt files are 3-line pointers and cannot carry content | `.claude/commands/**/<cmd>.md` (21) — the command file IS the body |
| Persona | `.github/agents/<persona>.agent.md` (8) | `.claude/agents/<persona>.md` (8) |

So Copilot needs 20 extra agent files purely as slash-command bodies; in Claude Code that
content lives in the command files, which adopt the persona subagent and follow the same
canonical runbook. Do NOT mirror the 20 command agents as Claude subagents: every subagent
description is loaded into context each session, so 20 redundant entries would cost tokens
on every interaction while adding zero capability.

Rules for contributors:
1. Never put substantive procedure in an adapter file — put it in the runbook and reference it.
2. When adding a command: runbook → extension.yml → Copilot agent + prompt → Claude command → README tables.
3. When editing a skill: edit `.github/skills/<name>/SKILL.md`, then copy to `.claude/skills/<name>/SKILL.md` (they must stay byte-identical; `/dev.lint-wiki` checks this).

Slash syntax differs by runtime: `/dev.analyze` (Copilot) ≡ `/dev:analyze` (Claude Code). Docs use the Copilot form; the mapping is mechanical.

### Token economy

Daily LLM cost is dominated by always-loaded context, so the framework keeps it deliberately thin:

- `CLAUDE.md` and `.github/copilot-instructions.md` carry only the non-negotiables, gates, and pointers (~40–50 lines each). Command/skill/agent descriptions are NOT duplicated there — both runtimes surface them automatically from frontmatter.
- Everything else loads on demand: runbooks only when a command runs, skills only when invoked, instruction files only for the persona that needs them.
- The bootstrap reads wiki *summaries* (standards-summary, pattern-library), not `/standards/` source — full source is read only by targeted `standards-retrieval` calls and the Reviewer's independence check.
- Repetition of a rule across files is reserved for constitutional invariants (defense in depth); everything else has one home and pointers.

---

## 15. VS Code Dashboard Extension

`tools/dashboard/` — TypeScript VS Code extension, zero runtime dependencies.

**Views** (activity bar container "SDD Dashboard"):
- **Targets** — registered targets with status, stack, path (click to open `targets/<id>.yml`).
- **Slices** — every `specs/NNN-*` with lifecycle phase (Specified → Clarified → Planned → Tasked → Implementing → Done) and task progress from `tasks.md` checkboxes.
- **Work Queue** — pending / in-progress / completed / escalated items.
- **Reports** — review + test reports grouped by target, with verdict badges.

**Dashboard webview** (`SDD: Open Dashboard`): summary cards (targets, active slices, escalations), verdict distribution, slice pipeline table, recent `wiki/log.md` entries.

**Mechanics**: a `FrameworkModel` parses the framework's plain-text artifacts (no database — the repo *is* the database), `FileSystemWatcher`s refresh on change, a status-bar item shows the escalation count. Framework root resolution: `sddDashboard.frameworkRoot` setting → else the first workspace folder containing `.specify/memory/constitution.md` (so it works in the multi-root target workspaces generated by `/dev.target`).

Build/run: see `tools/dashboard/README.md`.

---

## 16. Scaling Strategy

### 16.1 Per-target context

`targets/<id>.yml` records stack, commands, complexity class, conventions, and applicable exceptions. Orchestrator reads this before any operation on that target.

### 16.2 Batch processing

1. Discovery: Analyst bulk-scans a target → `work-queue/pending/`.
2. Priority: LOW → MEDIUM → HIGH → CRITICAL.
3. Parallelism cap: Orchestrator allows ≤ 3 in-progress slices (context hygiene).
4. Post-batch: Archivist runs to absorb new patterns discovered in the batch.

### 16.3 Knowledge compounding

```
Slice N → discovers new pattern need
  → Auditor flags exemplar gap
  → Human provides exemplar → /dev.ingest-exemplars
  → Slice N+1 has higher confidence on same pattern
  → Slice N+K achieves full automation of that pattern
```

Target trajectory: each project should require 10–20% less human intervention than the previous one.

### 16.4 Long-term maintenance

| Trigger | Action |
|---------|--------|
| New standards version in `/standards/` | `/dev.ingest-standards` |
| New exemplar added | `/dev.ingest-exemplars` |
| Recurring escalation (3+ times) | Auditor flags; human provides canonical exemplar |
| Wiki drift detected | `/dev.lint-wiki` |
| Standards conflicts | Archivist surfaces to human → `wiki/exception-registry.md` |

### 16.5 Agent versioning

Each agent file carries a version header:
```yaml
---
name: ImplementerAgent
version: 1.0.0
last-updated: YYYY-MM-DD
changelog: "Initial release"
---
```

Agent versions logged in `wiki/log.md` on each update; rollback by reverting the agent file.

---

## 17. Appendix: Quick Reference

### 17.1 Invocation cheatsheet

| Goal | Invocation (Copilot / Claude Code) |
|------|-----------------------------------|
| Build anything, one command | `/dev.feature <target> "<desc>"` / `/dev:feature <target> "<desc>"` (empty target → greenfield mode) |
| Register a project | `/dev.target register <path> [--new]` / `/dev:target register <path> [--new]` |
| Add new standards doc | Place in `/standards/` → `/dev.ingest-standards` |
| Add new exemplar | Place in `/exemplars/` → `/dev.ingest-exemplars` |
| Start a development slice | `/speckit.specify "<scope>"` (then `clarify` → `plan` → `tasks` → `implement`) |
| One-shot feature lifecycle | workflow `dev-feature` (`.specify/workflows/`; runner or manual) |
| One-shot greenfield project | workflow `dev-greenfield` (`.specify/workflows/`; runner or manual) |
| Analyze a target (out-of-band) | `/dev.analyze <target-id> [scope]` |
| Review a slice (out-of-band) | `/dev.review <slice-id>` |
| Audit the portfolio | `/dev.audit` |
| Check wiki health | `/dev.lint-wiki` |
| Resolve escalations | `/dev.review-escalated` |
| Amend the constitution | `/speckit.constitution` |

### 17.2 File-pattern legend

See `docs/08-customization.md §File-type cheat sheet` (single source — not duplicated here).

### 17.3 Placeholders to fill before first production run

- `.specify/extensions/dev/extension.yml` — `repository` URL (after first push)
- `.specify/memory/constitution.md` — `Ratified` date
- `dev-config.yml` (from `config-template.yml`) — per-framework overrides
- `exemplars/` — initial canonical exemplars beyond the shipped samples (human-curated)
- `standards/` — beyond the shipped `engineering-standards.md`, `api-design.md`, `security-policy.md`, `testing-standards.md`, add as policy is formalized
