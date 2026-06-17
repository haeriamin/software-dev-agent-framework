<!-- Codex CLI adapter for /dev.ideate — generated from .claude/commands\dev\ideate.md. Filename (dev.ideate.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Brainstorm options before building — read-only ideation that explores approaches, trade-offs, and risks, then recommends a direction"
argument-hint: "\"<rough idea or problem>\" [target-id]"
---

## Arguments

$ARGUMENTS

Adopt the **analyst** persona (`.codex/agents/analyst.toml`) — spawn it as a separate Codex subagent (Codex has no declarative handoffs; name the agent explicitly).

Follow the canonical runbook at `.specify/extensions/dev/commands/dev.ideate.md` step-by-step: purpose, preconditions, steps, exit criteria, handoff, failure modes. The constitution at `.specify/memory/constitution.md` overrides everything else.

This step is read-only and conversational: explore options, ask the questions that matter, recommend a direction, and write the ideation note. Do **not** write a spec, create a branch, or touch target source — that begins later with `/speckit.specify`. Bootstrap lightly (Principle II); append the outcome to `wiki/log.md` (Principle VII).
