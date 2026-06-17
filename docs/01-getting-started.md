# 1 · Getting Started

## Prerequisites

- **VS Code with GitHub Copilot**, **Claude Code** (CLI or desktop), or **OpenAI Codex**
  (preview) — the framework is wired for all three; pick any. Per-host setup + usage:
  [docs/runtimes/](runtimes/).
- **git** — for the framework repo and for reversible changes on targets.
- **Node.js 20+** — only if you want to build the [dashboard extension](07-dashboard.md).

## Install

```bash
git clone <repo-url> throughline
cd throughline
# Copilot: open the folder in VS Code — .github/ assets load automatically.
# Claude Code: run `claude` in the folder — CLAUDE.md and .claude/ assets load automatically.
# Codex (preview): run `codex` in the folder, then /hooks to trust; copy .codex/prompts/*.md to ~/.codex/prompts/.

# One-time, to wire the write-safety hooks for your OS (Claude Code & Codex; Copilot needs nothing):
powershell -ExecutionPolicy Bypass -File tools\setup-hooks.ps1   # Windows
bash tools/setup-hooks.sh                                        # macOS / Linux
```

No build step, no services, no Python — the repo's markdown files *are* the framework, and the hooks run on PowerShell (Windows) or bash (macOS/Linux). The read-only guard on `/standards/` and `/exemplars/` is on even before you run setup-hooks.

## Slash syntax

The three runtimes spell commands differently — same commands, same behavior:

| Runtime | Syntax |
|---------|--------|
| Claude Code | `/dev:analyze`, `/speckit:specify` |
| GitHub Copilot | `/dev.analyze`, `/speckit.specify` |
| Codex (preview) | `/dev.analyze`, `/speckit.specify` |

Docs use the Claude Code colon form. The mapping is mechanical. Full per-host walkthroughs:
[docs/runtimes/](runtimes/).

## First run (one time)

```bash
/speckit:constitution        # 1. review the framework's law; fill the Ratified date
/dev:ingest-standards        # 2. compile /standards/ into the wiki
/dev:ingest-exemplars        # 3. compile /exemplars/ into the pattern library
```

The shipped `/standards/` and `/exemplars/` are **replaceable seeds** — swap in your
team's own and re-run the ingests (see [Knowledge Base](05-knowledge-base.md)).

## Your first feature

```bash
/dev:target register path/to/my-app          # register the codebase you want to work on
/dev:feature my-app "Add cursor pagination to the orders endpoint"
```

That's the whole loop. Details: [Managing Targets](03-targets.md) and
[Building Features](04-building-features.md).

## Adopting incrementally

Start small:

1. **Knowledge only** — swap in your seeds, ingest, use the skills ad hoc in chat.
2. **Out-of-band** — `/dev:analyze`, `/dev:test`, `/dev:review` on a target, no specs.
3. **Full lifecycle** — `/dev:feature` when a change warrants traceability. Heavy machinery
   (design ADRs, human-led mode) engages only at HIGH/CRITICAL.

Solo dev? Relax the thresholds — a one-file [amendment](08-customization.md).

## Using as a template

Click **Use this template** on GitHub (or fork), then do the First Run above. Nothing
needs renaming — commands, hooks, and the dashboard are project-agnostic.

---
Next: [Core Concepts →](02-concepts.md)
