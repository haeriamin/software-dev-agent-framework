# /dev.target

**Agent**: Orchestrator
**Reads**: target path (external), `targets/**`, `.claude/settings.json`, `.throughline/integrations/*.manifest.json`
**Writes**: `targets/<id>.yml`, `targets/<id>.code-workspace`, per-tool access config (see step 7); append to `wiki/log.md`
**Never writes**: `/standards/**`, `/exemplars/**`, target source files

## Subcommands

```
/dev.target register <path> [--id <id>] [--stack <csv>] [--new]
/dev.target inspect <id>
/dev.target update <id> <field>=<value> ...
/dev.target list
```

## Steps — register

1. **Bootstrap** (Principle II, steps 1–3; no target yet).
2. Validate `<path>`:
   - Existing project: path must exist and contain files. `--new` flag: path must NOT exist; create it and run `git init`.
   - Refuse paths inside this framework repo (the framework holds no product code).
3. Derive `<id>` (kebab-case of last path segment unless `--id` given). Refuse duplicate ids.
4. **Probe** the project (read-only):
   - VCS: `.git/` present → `vcs: git`, detect default branch; else `vcs: none`.
   - Stack: detect from manifests (`package.json`, `pyproject.toml`, `*.csproj`, `go.mod`, `Cargo.toml`, …).
   - Commands: detect `test_command` / `lint_command` / `build_command` from manifest scripts; leave empty if ambiguous (do NOT guess).
5. Write `targets/<id>.yml` from `.throughline/templates/target-template.yml` with probed values.
6. Generate `targets/<id>.code-workspace`:
   ```json
   { "folders": [ { "name": "framework", "path": ".." },
                  { "name": "<id>", "path": "<absolute-target-path>" } ] }
   ```
7. **Grant target access for each installed tool.** A tool is "installed" when its adapter manifest exists (`.throughline/integrations/<tool>.manifest.json`, written by `tools/convert`). The target path is outside this repo, so each tool needs to be told it may read and write there. Apply only the entries for tools that are installed; report every change.
   - **Claude Code** (`claude.manifest.json`): add the absolute target path to `permissions.additionalDirectories` in `.claude/settings.local.json` (create the file with a `permissions` key if absent; merge, don't overwrite). Gitignored — machine paths never land in the shared `settings.json`.
   - **Cursor, Copilot, and any VS Code-based tool**: access comes from the multi-root workspace generated in step 6 — `targets/<id>.code-workspace` already lists the target folder. Tell the human to open that workspace. No per-path permission file is written.
   - **Codex** (`codex.manifest.json`): Codex sandboxes writes to the workspace root. Add the absolute target path as a writable root in the user's Codex config (`~/.codex/config.toml` → `[sandbox_workspace_write] writable_roots`), or launch Codex with the target as an extra `--cd` root. This is user-level machine config; print the exact line to add rather than editing it silently.
   - **Tier B tools (Aider, Windsurf)**: no access model to wire — they operate on whatever folder the human opens. Note this in the report.
8. Append to `wiki/log.md` (record which tools were granted access).

## Steps — inspect / update / list

- `inspect`: print the yml + live probe (git status, branch, dirty files). Read-only.
- `update`: rewrite only the named fields; log the change.
- `list`: table of id, path, vcs, stack, status.

## Exit Criteria

- `targets/<id>.yml` exists, parseable, with an absolute path that resolves.
- Workspace file generated; access granted for every installed tool (per step 7); log appended.

## Failure Modes

- **Path does not exist (without `--new`)** → report and stop; do not create directories implicitly.
- **Path is inside the framework** → refuse (standalone invariant).
- **Probe ambiguity** → leave fields empty and note them; never invent commands.
