# /dev.lint-wiki

**Agent**: Archivist (read-only mode)
**Reads**: `wiki/**`, `/standards/**`, `/exemplars/**`, `.github/skills/**`, `.claude/skills/**`
**Writes**: stdout report; optional `wiki/_lint-report.md`; append to `wiki/log.md`
**Never writes**: any other path

## Checks

1. **Broken links**: every `[[...]]` and relative link in `wiki/**` resolves.
2. **Orphan pages**: wiki pages unreachable from `wiki/index.md`.
3. **Stale standards summary**: any `/standards/*.md` newer than the last
   `wiki/standards-summary.md` ingest timestamp.
4. **Stale pattern library**: any `/exemplars/**` file newer than the last
   `wiki/pattern-library.md` ingest timestamp.
5. **Citation integrity**: every Standard Basis in `wiki/pattern-library.md` resolves to
   a rule present in `wiki/standards-summary.md`.
6. **Log integrity**: `wiki/log.md` entries are chronologically ordered and parse
   (timestamp | agent | command | target | verdict | summary | artifacts).
7. **Skill parity (`.github` ↔ `.claude`)**: `.github/skills/<name>/SKILL.md` is byte-identical
   to `.claude/skills/<name>/SKILL.md` for every skill. Canonical source:
   `.throughline/adapters/source/skills/<name>/SKILL.md` — if parity fails, re-run `tools/convert`.
8. **Exception registry hygiene**: no PENDING-HUMAN entry older than 30 days without a
   log reference.
9. **Scope integrity**: every `**Scope**: target:<id>` on a concept page references a
   registered target (`targets/<id>.yml` exists); scope values other than `global` or
   `target:<id>` are flagged; pages describing a single target's internals without a
   target scope are flagged as WARNING (likely mis-scoped global).

## Steps

1. Run all checks; collect findings as `| Check | Severity | Location | Detail |`.
2. Print the table. If `--write` was passed, also write `wiki/_lint-report.md`.
3. Append a one-line summary to `wiki/log.md` (counts per severity).

## Exit Criteria

- All checks executed; findings reported with exact locations.

## Failure Modes

- This command never mutates content to "fix" findings — remediation goes through
  `/dev.ingest-standards`, `/dev.ingest-exemplars`, or human edits.
