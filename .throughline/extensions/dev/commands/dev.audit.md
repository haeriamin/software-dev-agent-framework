# /dev.audit

**Agent**: Auditor
**Reads**: `review-reports/**`, `work-queue/**`, `wiki/**`, `specs/**`, `targets/**`
**Writes**: `review-reports/portfolio-summary.md`, `review-reports/recommendations.md`; append to `wiki/log.md`
**Never writes**: target source, `/wiki/**` content (recommendations only), `/standards/**`, `/exemplars/**`

## Arguments

```
/dev.audit [target-id]      # omit for full portfolio
```

## Steps

1. **Bootstrap** (Principle II, steps 1–3).
2. Aggregate all review + test reports (scoped to the target if given):
   verdict counts, mean confidence per sub-score, retry rates, escalation rate.
3. **Systemic patterns**: findings that recur across ≥ 3 slices (same standard clause
   violated, same sub-score dragging) → name the pattern, cite instances.
4. **Exemplar gaps**: pattern classes that appeared ≥ 3 times in Decision Records with
   "none exists" exemplar basis → list as gaps with the affected slices.
5. **Stale-knowledge check**: slices completed before the latest
   `/dev.ingest-standards` run that cite since-changed rules → re-validation candidates.
6. Write `review-reports/portfolio-summary.md` (verdict table per target, trends,
   systemic issues, gaps, re-validation candidates) and
   `review-reports/recommendations.md` (actions for the Archivist/human: exemplars to
   curate, standards to clarify, wiki pages to update). The Auditor recommends; only
   the Archivist writes wiki content.
7. Append to `wiki/log.md`.

## Exit Criteria

- Both artifacts written; every systemic claim cites ≥ 3 concrete instances.

## Failure Modes

- **No reports yet** → write an empty-state summary (don't fail); note bootstrap status.
- **Contradictory reports for one slice** (e.g., two reviews) → use the latest by
  timestamp; flag the duplication.
