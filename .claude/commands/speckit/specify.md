---
description: "Create the feature specification for a development slice (records the Target)"
argument-hint: "<slice description including target>"
---

## Arguments

$ARGUMENTS

Follow the runbook at `.github/agents/speckit.specify.agent.md` — its content is runtime-neutral; ignore Copilot-specific frontmatter (tools/handoffs) and use your own tools. Helper scripts referenced there live under `.specify/scripts/` (PowerShell and bash variants).

Check `.specify/extensions.yml` for lifecycle hooks per `.github/instructions/extension-hooks.instructions.md` (in Claude Code, run a hook command as its `/dev:<name>` slash form). The constitution at `.specify/memory/constitution.md` overrides everything else.
