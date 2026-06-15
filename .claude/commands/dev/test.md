---
description: "Author and execute tests for an implemented slice; produce the evidence report"
argument-hint: "<slice-id>"
---

## Arguments

$ARGUMENTS

Adopt the **tester** subagent persona (`.claude/agents/tester.md`) — delegate to it via the Agent tool when running as a top-level conversation.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.test.md` step-by-step: preconditions, steps, exit criteria, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
