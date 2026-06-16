<!-- Codex CLI adapter for /dev.test — generated from .claude/commands\dev\test.md. Filename (dev.test.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Author and execute tests for an implemented slice; produce the evidence report"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **tester** persona (`.codex/agents/tester.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.test.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
