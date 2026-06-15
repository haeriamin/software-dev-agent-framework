---
description: "Produce design.md + ADRs for a slice (required for HIGH/CRITICAL complexity)"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **architect** subagent persona (`.claude/agents/architect.md`) — delegate to it via the Agent tool when running as a top-level conversation.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.design.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
