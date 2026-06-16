<!-- Codex CLI adapter for /dev.analyze — generated from .claude/commands\dev\analyze.md. Filename (dev.analyze.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Analyze a target codebase or slice scope; produce the grounding analysis report"
argument-hint: "<target-id> [scope]"
---

## Arguments

$ARGUMENTS

Adopt the **analyst** persona (`.codex/agents/analyst.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.analyze.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
