<!-- Codex CLI adapter for /speckit.constitution — generated from .claude/commands\speckit\constitution.md. Filename (speckit.constitution.md) is the slash command; install by copying this folder's *.md into ~/.codex/prompts/ (Codex reads custom prompts from $CODEX_HOME/prompts). -->
---
description: "Ratify or amend the framework constitution with semantic versioning and audit trail"
argument-hint: "[amendment description]"
---

## Arguments

$ARGUMENTS

Follow the runbook at `.github/agents/speckit.constitution.agent.md` — its content is runtime-neutral; ignore Copilot-specific frontmatter (tools/handoffs) and use your own tools. Helper scripts referenced there live under `.specify/scripts/` (PowerShell and bash variants).

Check `.specify/extensions.yml` for lifecycle hooks per `.github/instructions/extension-hooks.instructions.md` (in Codex, run a hook command as its `/dev.<name>` slash form). The constitution at `.specify/memory/constitution.md` overrides everything else.
