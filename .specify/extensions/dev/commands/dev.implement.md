# /dev.implement

**Agent**: Implementer
**Reads**: `specs/NNN-*/{spec,plan,design,tasks}.md`, analysis report, `targets/<id>.yml`, `wiki/**`, `/standards/**` + `/exemplars/**` (via skills)
**Writes**: target source on branch `sdd/<slice-id>` (or with backups for non-git targets); `work-queue/in-progress/<slice>-implementation.md` (Decision Records); append to `wiki/log.md`
**Never writes**: `/standards/**`, `/exemplars/**`, target CI/CD config or secrets, the target's default branch

## Preconditions

- Plan exists; tasks exist; analysis report exists and is not stale
  (re-run `/dev.analyze` if the source hash no longer matches).
- HIGH/CRITICAL → `design.md` exists with status `Approved`.
- Analysis confidence ≥ 0.70 (Principle V). Below → escalate, don't implement.
- Reversibility prepared (Principle VI): git target → on branch `sdd/<slice-id>`;
  non-git target → `work-queue/backups/<slice-id>/` ready.

## Steps

1. **Bootstrap** (Principle II) — within this slice, work from the analysis report + plan (they embed the relevant standards/patterns/exceptions) + the target entry; re-read full wiki summaries only if the analysis fingerprint is stale (bootstrap economy).
2. Load `tasks.md`. Execute tasks **in order** (parallel only where marked `[P]`),
   one task = one logical unit (atomicity, ARCHITECTURE.md §12.2).
3. Per task:
   - Fetch the matched pattern + top-ranked exemplars (`pattern-matcher`, `exemplar-retrieval`).
   - Follow the target's detected conventions (from the analysis) wherever standards are silent.
   - For non-git targets: back up each existing file before first modification.
   - Apply the change. Record an **Implementation Decision Record**:
     ```markdown
     ### Task: T00N <name>
     - Spec requirement: specs/NNN-<slice>/spec.md §FR-X
     - Design basis: specs/NNN-<slice>/design.md §<n> (or "n/a — LOW/MEDIUM")
     - Standard clause: standards/<file>.md §<RULE-ID>
     - Exemplar basis: exemplars/<path> (or "none exists — pattern-matcher confirmed")
     - Files changed: [...]
     - Confidence: 0.XX
     ```
     The standard clause MUST be a real rule id that exists in the source file (e.g.
     `standards/engineering-standards.md §ENG-02`), copied from the file — never a
     paraphrased or invented label. The Reviewer re-reads the clause from source and
     issues an automatic **FAIL for citation fraud** if it does not exist or does not
     apply (Principle III). If no clause governs the change, say so explicitly
     (`Standard clause: none — convention-only, see analysis`) rather than inventing one.
   - Mark the task checkbox done in `tasks.md`.
   - Cannot complete confidently → leave safe state + `DEV-STATUS: PARTIAL` annotation
     (Principle IV), entry in `wiki/exception-registry.md`, continue with independent tasks.
4. Run the target's `lint_command` (if set); fix violations introduced by this slice.
5. Forbidden at all times (ARCHITECTURE.md §12.5): behavior changes outside spec scope,
   new dependencies not named in the plan, test-surface reduction, comment/doc removal,
   CI/secrets edits.
6. Write `work-queue/in-progress/<slice>-implementation.md`: all Decision Records,
   files-changed list, per-task confidence, rollback procedure, PARTIAL count.
7. Append to `wiki/log.md`. **Do not merge, do not push.** Hand off to `/dev.test`.

## Exit Criteria

- All tasks done or explicitly PARTIAL-annotated; Decision Record per task
  (Principle III); implementation report written; lint clean.

## Failure Modes

- **Task needs an unplanned dependency** → STOP that task; annotate; escalate (plan
  amendment is a human/Architect decision).
- **Pattern has no exemplar and standards underdetermine the approach** → implement the
  minimal compliant version, flag the exemplar gap, lower the task confidence accordingly.
- **>30% of tasks end PARTIAL** → halt the slice and escalate (systemic plan failure).
