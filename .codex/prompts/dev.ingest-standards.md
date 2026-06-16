<!-- Codex CLI adapter for /dev.ingest-standards — generated from .claude/commands\dev\ingest-standards.md. Filename (dev.ingest-standards.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Ingest /standards documents into wiki/standards-summary.md"
argument-hint: ""
---

## Arguments

$ARGUMENTS

Adopt the **archivist** persona (`.codex/agents/archivist.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.ingest-standards.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
