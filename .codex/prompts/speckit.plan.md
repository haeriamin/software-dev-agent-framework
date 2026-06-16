<!-- Codex CLI adapter for /speckit.plan — generated from .claude/commands\speckit\plan.md. Filename (speckit.plan.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Produce the implementation plan grounded in the Analyst report"
argument-hint: "[context]"
---

## Arguments

$ARGUMENTS

Follow the runbook at `.github/agents/speckit.plan.agent.md` — its content is runtime-neutral; ignore Copilot-specific frontmatter (tools/handoffs) and use your own tools. Helper scripts referenced there live under `.specify/scripts/` (PowerShell and bash variants).

Check `.specify/extensions.yml` for lifecycle hooks per `.github/instructions/extension-hooks.instructions.md` (in Codex, run a hook command as its `/dev.<name>` slash form). The constitution at `.specify/memory/constitution.md` overrides everything else.
