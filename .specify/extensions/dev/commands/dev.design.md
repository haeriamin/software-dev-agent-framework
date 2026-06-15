# /dev.design

**Agent**: Architect
**Reads**: `specs/NNN-*/spec.md`, analysis report, `wiki/**`, `/standards/**` (via skill), target source (read-only)
**Writes**: `specs/NNN-*/design.md`; ADR index entries in `wiki/decision-registry.md` (via Archivist-format `wiki-writer`); append to `wiki/log.md`
**Never writes**: target source, `/standards/**`, `/exemplars/**`

## Preconditions

- Spec exists and is clarified (no `[NEEDS CLARIFICATION]` markers).
- Analysis report exists in `work-queue/in-progress/` (run `/dev.analyze` first).
- Required for HIGH/CRITICAL complexity; optional otherwise.

## Steps

1. **Bootstrap** (Principle II — full sequence).
2. Load spec + analysis. Restate constraints; identify the design-relevant forces
   (contracts, data flow, trust boundaries, failure modes).
3. Produce `design.md` from `.specify/templates/design-template.md`:
   - Component table (target-relative paths, new/modified).
   - Interfaces & contracts — concrete signatures/schemas tasks will implement against.
   - Data flow.
   - One ADR per consequential decision (alternatives + consequences + standard basis).
   - Security & failure analysis (mandatory at this complexity).
4. Index each accepted ADR in `wiki/decision-registry.md`:
   `| ADR-NNN | <title> | <slice> | <target> | Accepted | <date> | specs/NNN-*/design.md |`
5. List Open Questions; if any block tasking, mark the design `Draft` and route to
   `/speckit.clarify` or human review.
6. Append to `wiki/log.md`.

## Exit Criteria

- `design.md` complete; every ADR cites a standard basis; CRITICAL slices explicitly
  mark which parts are human-led (constitution §Agent Boundaries).
- Design status `Approved` requires explicit human approval — the Architect never
  self-approves for HIGH/CRITICAL.

## Failure Modes

- **Spec ambiguity discovered** → do not design around it; emit `[NEEDS CLARIFICATION]`
  back into the spec flow and stop.
- **No compliant design exists under current standards** → escalate with the conflicting
  clauses cited; candidate for `wiki/exception-registry.md`.
