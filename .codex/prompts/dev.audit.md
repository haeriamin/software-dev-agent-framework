<!-- Codex CLI adapter for /dev.audit — generated from .claude/commands\dev\audit.md. Filename (dev.audit.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Portfolio-wide quality roll-up across targets"
argument-hint: "[target-id]"
---

## Arguments

$ARGUMENTS

Adopt the **auditor** persona (`.codex/agents/auditor.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.audit.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
