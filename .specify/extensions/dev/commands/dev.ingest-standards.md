# /dev.ingest-standards

**Agent**: Archivist
**Reads**: `/standards/**`, `wiki/**`
**Writes**: `wiki/standards-summary.md`, `wiki/concepts/*`, `wiki/index.md`; append to `wiki/log.md`
**Never writes**: `/standards/**`, `/exemplars/**`

## Preconditions

- At least one `.md` file exists under `/standards/`.

## Steps

1. **Bootstrap** (Principle II, steps 1–3).
2. Inventory `/standards/*.md`. For each, use the `standards-retrieval` skill to extract:
   Standard ID, effective date, applicability, and every Rule (id, severity, description, check).
3. **Diff against prior state**: compare with the existing `wiki/standards-summary.md`
   (rule added / removed / severity changed / check changed).
4. Rewrite `wiki/standards-summary.md`:
   - One section per standard doc, one table row per rule:
     `| Rule | Severity | Applies To | Check | Source |` with source as `standards/<file>.md §<RULE-ID>`.
   - Header records ingest timestamp + source file list.
5. For substantial topics, create/update `wiki/concepts/<topic>.md` via `wiki-writer`.
6. **Change propagation**: for each changed rule, list completed slices that cited it
   (search `review-reports/` and `specs/`); record the list in the log entry so the
   Auditor can surface re-validation candidates via `/dev.audit`.
7. Update `wiki/index.md` links. Append to `wiki/log.md`.

## Exit Criteria

- Every rule in `/standards/` appears in the summary with a precise source citation.
- Diff summary reported (added/removed/changed counts).

## Failure Modes

- **Malformed standard doc** (missing Rule structure) → ingest what parses; list the
  malformed sections in the log and report them to the human. Never guess rule content.
- **Conflicting rules across docs** → record both, flag the conflict in
  `wiki/exception-registry.md` as PENDING-HUMAN, and report. Do not pick a winner.
