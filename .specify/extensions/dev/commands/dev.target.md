# /dev.target

**Agent**: Orchestrator
**Reads**: target path (external), `targets/**`, `.claude/settings.json`
**Writes**: `targets/<id>.yml`, `targets/<id>.code-workspace`; append to `wiki/log.md`
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
5. Write `targets/<id>.yml` from `.specify/templates/target-template.yml` with probed values.
6. Generate `targets/<id>.code-workspace`:
   ```json
   { "folders": [ { "name": "framework", "path": ".." },
                  { "name": "<id>", "path": "<absolute-target-path>" } ] }
   ```
7. **Claude Code access**: add the target path to `permissions.additionalDirectories` in `.claude/settings.local.json` (create the file with a `permissions` key if absent; merge, don't overwrite). This file is gitignored — machine-specific paths never land in the shared `settings.json`. Report the change.
8. Append to `wiki/log.md`.

## Steps — inspect / update / list

- `inspect`: print the yml + live probe (git status, branch, dirty files). Read-only.
- `update`: rewrite only the named fields; log the change.
- `list`: table of id, path, vcs, stack, status.

## Exit Criteria

- `targets/<id>.yml` exists, parseable, with an absolute path that resolves.
- Workspace file generated; Claude permissions updated; log appended.

## Failure Modes

- **Path does not exist (without `--new`)** → report and stop; do not create directories implicitly.
- **Path is inside the framework** → refuse (standalone invariant).
- **Probe ambiguity** → leave fields empty and note them; never invent commands.
