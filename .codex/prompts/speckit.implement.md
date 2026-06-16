<!-- Codex CLI adapter for /speckit.implement — generated from .claude/commands\speckit\implement.md. Filename (speckit.implement.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Execute the tasked slice through Implementer -> Tester -> Reviewer with gates"
argument-hint: ""
---

## Arguments

$ARGUMENTS

Follow the runbook at `.github/agents/speckit.implement.agent.md` — its content is runtime-neutral; ignore Copilot-specific frontmatter (tools/handoffs) and use your own tools. Helper scripts referenced there live under `.specify/scripts/` (PowerShell and bash variants).

Check `.specify/extensions.yml` for lifecycle hooks per `.github/instructions/extension-hooks.instructions.md` (in Codex, run a hook command as its `/dev.<name>` slash form). The constitution at `.specify/memory/constitution.md` overrides everything else.
