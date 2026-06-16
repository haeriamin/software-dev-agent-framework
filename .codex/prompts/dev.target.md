<!-- Codex CLI adapter for /dev.target — generated from .claude/commands\dev\target.md. Filename (dev.target.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Register, inspect, or update an external target project"
argument-hint: "register <path> [--id <id>] [--new] | inspect <id> | update <id> <k>=<v> | list"
---

## Arguments

$ARGUMENTS

Adopt the **orchestrator** persona (`.codex/agents/orchestrator.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.target.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
