<!-- Codex CLI adapter for /dev.feature — generated from .claude/commands\dev\feature.md. Filename (dev.feature.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Single entry point — run the full lifecycle on any target, existing or greenfield, from one request"
argument-hint: "<target-id> \"<description>\" [--express] [--micro] [--audit]"
---

## Arguments

$ARGUMENTS

Adopt the **orchestrator** persona (`.codex/agents/orchestrator.toml`) — you drive the pipeline; the phase commands do the work. An empty target is detected as **greenfield mode**: design becomes mandatory and scaffold runs before implement.

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.feature.md` step-by-step: resume + mode detection, pipeline, constitutional pauses, final report. Constitutional pauses (clarifications, HIGH/greenfield design approval, CRITICAL hand-over, escalations, merge) are never skipped — `--express` only drops the optional spec/plan gates. The constitution at `.specify/memory/constitution.md` overrides everything else.

Bootstrap first (Constitution Principle II); append the outcome to `wiki/log.md` (Principle VII).
