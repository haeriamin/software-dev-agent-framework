<!-- Codex CLI adapter for /dev.scaffold — generated from .claude/commands\dev\scaffold.md. Filename (dev.scaffold.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Scaffold a greenfield target project skeleton with a verified quality loop"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **implementer** persona (`.codex/agents/implementer.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.scaffold.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
