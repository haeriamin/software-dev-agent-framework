# /dev.ingest-exemplars

**Agent**: Archivist
**Reads**: `/exemplars/**`, `wiki/**`
**Writes**: `wiki/pattern-library.md`, `wiki/concepts/*`, `wiki/index.md`; append to `wiki/log.md`
**Never writes**: `/exemplars/**`, `/standards/**`

## Preconditions

- Every exemplar code file has a sibling `.meta.md` (Kind, Pattern Class, Languages,
  Standard References, Complexity, Description, Tags). Missing metadata → that exemplar
  is skipped and reported; never invent metadata.

## Steps

1. **Bootstrap** (Principle II, steps 1–3).
2. Inventory `/exemplars/good/**` and `/exemplars/anti-patterns/**` (code + `.meta.md` pairs).
3. Group by **Pattern Class**. For each class, create/refresh an entry in `wiki/pattern-library.md`:
   ```markdown
   ## Pattern: <Name>
   **Pattern ID**: PAT-NNN          ← stable; never renumber existing entries
   **Class**: <Pattern Class>
   **Exemplars**: [[exemplars/good/...]] (1+)
   **Anti-patterns**: [[exemplars/anti-patterns/...]] (0+)
   **Standard Basis**: standards/<file>.md §<RULE-ID>
   **When to apply**: …
   **Implementation Steps**: …       ← derived ONLY from the exemplar content
   **Confidence typical range**: 0.XX–0.XX
   ```
4. Verify every `Standard References` citation resolves to a real rule in
   `wiki/standards-summary.md`; broken citations → flag, don't drop.
5. Update `wiki/index.md`. Append to `wiki/log.md` (patterns added/updated, exemplars skipped).

## Exit Criteria

- Every valid exemplar pair is reachable from exactly one pattern entry.
- No pattern entry lacks a Standard Basis.

## Failure Modes

- **Code file without `.meta.md`** → skip + report (human must add metadata).
- **Two classes claim the same exemplar** → keep first, flag for human in the log.
