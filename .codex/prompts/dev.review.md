<!-- Codex CLI adapter for /dev.review — generated from .claude/commands\dev\review.md. Filename (dev.review.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Gate an implemented slice: PASS / CONDITIONAL_PASS / FAIL with cited findings"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **reviewer** persona (`.codex/agents/reviewer.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly so the Reviewer stays independent).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.review.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
