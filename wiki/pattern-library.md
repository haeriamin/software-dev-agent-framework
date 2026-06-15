# Pattern Library
**Maintained by**: Archivist | **Last ingest**: 2026-06-11T12:00:05Z
**Sources**: exemplars/good/api/paginated-endpoint.ts, exemplars/anti-patterns/god-service.ts

> Compiled from `/exemplars/**` by `/dev.ingest-exemplars`. PAT ids are stable.

## Pattern: Cursor-Paginated Collection Endpoint
**Pattern ID**: PAT-001
**Class**: REST Pagination
**Exemplars**: [[exemplars/good/api/paginated-endpoint.ts]]
**Anti-patterns**: [[exemplars/anti-patterns/god-service.ts]] (unbounded list + raw dump)
**Standard Basis**: api-design.md §API-02, §API-03, §API-04; engineering-standards.md §ENG-02; security-policy.md §SEC-04
**When to apply**: Any endpoint returning a collection of resources.
**Implementation Steps** (derived from the exemplar):
1. Validate query params at the boundary (`limit` bounded 1–100, optional `cursor`) — API-04.
2. Keep IO behind a reader port/interface so the handler is unit-testable without binding a port.
3. Return a page envelope `{ items, next_cursor }` — never the whole collection (API-02).
4. On bad input, return a structured error envelope `{ code, message, details? }` with the right status (API-03).
5. Expose explicit DTO fields, not raw entities (SEC-04). Propagate unexpected errors, never swallow (ENG-02).
**Confidence typical range**: 0.80–0.95 (strong exemplar, deterministic shape).

## Pattern: Service Decomposition (cautionary)
**Pattern ID**: PAT-002
**Class**: Service Decomposition
**Anti-patterns**: [[exemplars/anti-patterns/god-service.ts]]
**Standard Basis**: engineering-standards.md §ENG-01, §ENG-02; security-policy.md §SEC-01, §SEC-02, §SEC-04; api-design.md §API-02, §API-03, §API-04
**When to apply**: Recognizing/rejecting a single unit that mixes validation, persistence, formatting, transport, and secrets. Split by responsibility; never use the anti-pattern as a basis.
**Confidence typical range**: n/a (recognition only).

**Exemplar gaps**: none recorded yet (2 exemplars, 2 pattern classes).
