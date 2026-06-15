# dev — Software Development Extension for spec-kit

Provides the thirteen `/dev.*` commands and the SDD lifecycle hook bindings that turn the
generic speckit cycle into a gated software-development pipeline operating on external
**targets** (registered project paths).

- Command runbooks: `commands/dev.<name>.md` — the canonical, runtime-neutral procedures.
- Lifecycle hooks: declared in `extension.yml`, merged into `.specify/extensions.yml`.
- Helper scripts: `scripts/bash/dev-common.sh`, `scripts/powershell/dev-common.ps1`.
- Config: copy `config-template.yml` → repo-root `dev-config.yml` for overrides.

Runtime adapters (`.github/agents/dev.*.agent.md`, `.claude/commands/dev/*.md`) are thin
wrappers — never put procedure there; put it in the runbook.
