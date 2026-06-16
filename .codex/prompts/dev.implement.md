<!-- Codex CLI adapter for /dev.implement — generated from .claude/commands\dev\implement.md. Filename (dev.implement.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Execute the tasked slice at the target path with cited, reversible changes"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **implementer** persona (`.codex/agents/implementer.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.implement.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
