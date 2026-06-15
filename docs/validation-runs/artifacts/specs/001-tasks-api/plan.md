# Implementation Plan: Tasks REST API

**Slice ID**: 001-tasks-api
**Target**: sdd-demo-tasks-api
**Spec**: [spec.md](spec.md)
**Analysis**: [001-tasks-api-analysis.md](../../work-queue/in-progress/001-tasks-api-analysis.md)
**Design**: [design.md](design.md)
**Created**: 2026-06-11

## Constitution Check *(gate)*

- [x] Bootstrap completed (wiki index/standards-summary/pattern-library/exception-registry + target yml read)
- [x] Target registered and readable (`targets/sdd-demo-tasks-api.yml`)
- [x] No writes planned to `/standards/` or `/exemplars/`
- [x] Rollback strategy: branch `sdd/001-tasks-api` (git target)
- [x] Complexity class confirmed: MEDIUM
- [x] Greenfield ⇒ design.md exists and is human-approved (see design.md Status)

## Technical Context

**Stack**: Node + TypeScript (from target yml + design ADR-001).
**Affected Modules**: `src/task.ts` (types+DTO), `src/store.ts` (in-memory + reader port),
`src/cursor.ts` (encode/decode), `src/handlers.ts` (create/list), `src/server.ts` (http adapter),
`test/*.test.ts`.
**Existing Conventions**: none (greenfield) — set here.
**New Dependencies**: `typescript` (dev) only. No runtime deps (justified: ENG-05; keeps the demo zero-dep).

## Approach

Implement PAT-001 exactly: validate at boundary (API-04), reader port for IO (NFR-001),
page envelope `{items,next_cursor}` (API-02/003), explicit DTO (SEC-04), propagate errors
(ENG-02). Create-task validated per API-04. Newest-first ordering; cursor = base64 of the
created-order index of the last returned item.

### Pattern & Standards Map

| Requirement | Pattern | Exemplar | Standard clause |
|-------------|---------|----------|-----------------|
| FR-001 | none (trivial) | — | api-design.md §API-04; engineering-standards.md §ENG-02 |
| FR-002 | PAT-001 | exemplars/good/api/paginated-endpoint.ts | api-design.md §API-02 |
| FR-003 | PAT-001 | same | api-design.md §API-02, §API-03 |
| FR-004 | PAT-001 | same | api-design.md §API-04, §API-03 |
| FR-005 | PAT-001 | same | security-policy.md §SEC-04 |

### Risk Register
Carried from analysis; all L/M with mitigations. No CRITICAL surface.

## Verification Strategy

**Test command**: `node --test` (compiled JS in `dist/`, or ts via loader).
**New tests required**: create (happy + blank title), list (paging, last-page null cursor,
limit bounds, unknown cursor), DTO shape (no internal fields leak).
**Regression surface**: none (greenfield).

## Phase Outline
1. Scaffold (manifest, tsconfig, test/lint loop green on empty skeleton)
2. Contracts: Task type + DTO, TaskStore reader port, cursor codec
3. Core logic: create + list handlers
4. Integration: thin http adapter
5. Tests hardening: all acceptance scenarios + edges
6. Docs: README stub

## Confidence Estimate
**Planning confidence**: 0.88 — strong pattern coverage, one exemplar directly on point, no sensitive surface. ≥ 0.70 ⇒ proceed.
