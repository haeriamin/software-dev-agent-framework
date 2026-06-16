<!-- Codex CLI adapter for /speckit.tasks — generated from .claude/commands\speckit\tasks.md. Filename (speckit.tasks.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Break the approved plan into atomic, independently testable tasks"
argument-hint: ""
---

## Arguments

$ARGUMENTS

Follow the runbook at `.github/agents/speckit.tasks.agent.md` — its content is runtime-neutral; ignore Copilot-specific frontmatter (tools/handoffs) and use your own tools. Helper scripts referenced there live under `.specify/scripts/` (PowerShell and bash variants).

Check `.specify/extensions.yml` for lifecycle hooks per `.github/instructions/extension-hooks.instructions.md` (in Codex, run a hook command as its `/dev.<name>` slash form). The constitution at `.specify/memory/constitution.md` overrides everything else.
