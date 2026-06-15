---
description: "Gate an implemented slice: PASS / CONDITIONAL_PASS / FAIL with cited findings"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **reviewer** subagent persona (`.claude/agents/reviewer.md`) — delegate to it via the Agent tool when running as a top-level conversation.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.review.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
