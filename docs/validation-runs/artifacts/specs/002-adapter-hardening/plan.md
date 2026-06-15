# Implementation Plan: Adapter Hardening

**Slice ID**: 002-adapter-hardening
**Target**: sdd-demo-tasks-api
**Spec**: [spec.md](spec.md)
**Created**: 2026-06-11

## Constitution Check
- [x] Bootstrap completed
- [x] Target registered/readable
- [x] No writes to /standards/ or /exemplars/
- [x] Rollback: branch `sdd/002-adapter-hardening`
- [x] Complexity LOW → no design.md required (not HIGH/CRITICAL, not greenfield)

## Technical Context
**Stack**: existing (Node + TS). **Affected Modules**: src/server.ts, test/server.test.ts, README.md.
**New Dependencies**: none.

## Approach
Add a `/v1` prefix and an injected `Logger` to `createServer`; default logger silent so tests
stay quiet (TST-03). Cover the adapter with integration tests using a real ephemeral server
(listen on port 0) hit via global `fetch` — proving status mapping and routing end to end.

### Pattern & Standards Map
| Requirement | Pattern | Standard clause |
|-------------|---------|-----------------|
| FR-001 | — | api-design.md §API-03; testing-standards.md §TST-01, §TST-03 |
| FR-002 | — | api-design.md §API-05 |
| FR-003 | — | engineering-standards.md §ENG-01; delivery-standards.md §DEL-03 |

## Verification Strategy
**Test command**: `npm test`. **New tests**: 7 adapter integration tests. **Regression**: the 8 handler tests must stay green.

## Confidence Estimate
**Planning confidence**: 0.92 — small, well-bounded surface; mechanism proven in slice 001.
