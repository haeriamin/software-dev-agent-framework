<!-- Codex CLI adapter for /dev.design — generated from .claude/commands\dev\design.md. Filename (dev.design.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Produce design.md + ADRs for a slice (required for HIGH/CRITICAL complexity)"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **architect** persona (`.codex/agents/architect.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.design.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
