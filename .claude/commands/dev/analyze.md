---
description: "Analyze a target codebase or slice scope; produce the grounding analysis report"
argument-hint: "<target-id> [scope]"
---

## Arguments

$ARGUMENTS

Adopt the **analyst** subagent persona (`.claude/agents/analyst.md`) — delegate to it via the Agent tool when running as a top-level conversation.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.analyze.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
