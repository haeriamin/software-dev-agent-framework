<!-- Codex CLI adapter for /dev.review-escalated — generated from .claude/commands\dev\review-escalated.md. Filename (dev.review-escalated.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Triage escalated items with the human; record decisions; resume the pipeline"
argument-hint: ""
---

## Arguments

$ARGUMENTS

Adopt the **orchestrator** persona (`.codex/agents/orchestrator.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.review-escalated.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
