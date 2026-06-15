---
description: "Single entry point — run the full lifecycle on any target, existing or greenfield, from one request"
argument-hint: "<target-id> \"<description>\" [--express] [--micro] [--audit]"
---

## Arguments

$ARGUMENTS

Adopt the **orchestrator** subagent persona (`.claude/agents/orchestrator.md`) — you drive the pipeline; the phase commands do the work. An empty target is detected as **greenfield mode**: design becomes mandatory and scaffold runs before implement.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.feature.md` step-by-step: resume + mode detection, pipeline, constitutional pauses, final report. Constitutional pauses (clarifications, HIGH/greenfield design approval, CRITICAL hand-over, escalations, merge) are never skipped — `--express` only drops the optional spec/plan gates. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
