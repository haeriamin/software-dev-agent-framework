# Contributing

Thanks for improving the framework. Two rules dominate everything else here:

1. **The constitution wins.** `.specify/memory/constitution.md` overrides every other file.
   Changing thresholds, formula weights, principles, or write boundaries is a constitutional
   amendment (`/speckit.constitution` → human approval → version bump → log entry) — never a
   quiet config edit.
2. **One brain, two adapters.** Substantive procedure lives ONLY in
   `.specify/extensions/dev/commands/*.md` (runbooks) and `.github/instructions/*.instructions.md`
   (protocols). The `.github/` and `.claude/` files are thin adapters. If your PR puts steps into
   an adapter, it will be asked to move them.

## Adding or changing a command

1. Write/edit the runbook: `.specify/extensions/dev/commands/dev.<name>.md`
   (preconditions, steps, exit criteria, failure modes).
2. Declare it in `.specify/extensions/dev/extension.yml` (and hook bindings if it joins the lifecycle).
3. Copilot adapters: `.github/agents/dev.<name>.agent.md` (thin) + `.github/prompts/dev.<name>.prompt.md` (3 lines).
4. Claude adapter: `.claude/commands/dev/<name>.md` (thin). Do NOT add a per-command Claude
   subagent — the command file adopts one of the 8 persona subagents; per-command subagents
   would bloat every session's context (see ARCHITECTURE §14 file-count asymmetry).
5. Update the command tables in `README.md`, `ARCHITECTURE.md`, `.github/copilot-instructions.md`, `CLAUDE.md`.

## Editing skills

Edit `.github/skills/<name>/SKILL.md`, then copy the file to `.claude/skills/<name>/SKILL.md`.
The two trees must stay **byte-identical** — CI and `/dev.lint-wiki` both fail on drift.

## Standards & exemplars

`/standards/` and `/exemplars/` are human-curated seeds. They ship as **replaceable examples** —
teams adopting the framework substitute their own. Contributions here should be broadly
applicable, follow the machine-readable rule format (standards) or the `.meta.md` convention
(exemplars), and avoid stack-specific dogma where a stack-neutral rule exists.

## Hooks & scripts

Every hook/script ships in both shells (`.ps1` + `.sh`) with identical behavior. CI smoke-tests
the bash variants (block/allow exit codes); test PowerShell variants locally on Windows.

## Dashboard extension

```bash
cd tools/dashboard && npm ci && npm run compile   # must compile clean under strict TS
```

Zero runtime dependencies is a hard rule — the repo's plain-text artifacts are the only data source.

## Local-only files

Machine-specific state never lands in shared files: target access permissions go in
`.claude/settings.local.json` (gitignored), generated `targets/*.code-workspace` files are
gitignored, and `targets/*.yml` entries contain absolute paths — fine for private team forks,
but don't commit personal target entries to the public repo.
