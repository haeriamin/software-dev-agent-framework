# Test Report: 002-adapter-hardening
**Target**: sdd-demo-tasks-api | **Date**: 2026-06-11 | **Branch**: sdd/002-adapter-hardening
**Command**: `npm test` | **Exit code**: 0
**Results**: 15 passed / 0 failed / 0 skipped (7 new adapter tests; 8 handler tests regression-green)

## Coverage of changed behavior
| Behavior (FR) | Test | Status |
|---------------|------|--------|
| FR-001 create 201 over HTTP | POST /v1/tasks valid → 201 | COVERED |
| FR-001 validation 400 | POST /v1/tasks blank title → 400 | COVERED |
| FR-001 invalid JSON 400 | POST /v1/tasks bad JSON → 400 INVALID_JSON | COVERED |
| FR-001 list 200 envelope | GET /v1/tasks → 200 page | COVERED |
| FR-001 limit passthrough 400 | GET /v1/tasks?limit=0 → 400 | COVERED |
| FR-001 unknown route 404 | GET /nope → 404 | COVERED |
| FR-002 versioning | GET /tasks (unversioned) → 404 | COVERED |

## Deterministic tool evidence
- `npm audit` → 0 vulnerabilities (DEL-01). `tsc --noEmit` → exit 0.

## Known uncovered (declared, not a spec behavior)
- The request-stream `error` handler (`REQUEST_ERROR`) is a defensive guard; it is not
  triggerable without injecting a socket fault and is out of FR scope. Recorded, not claimed as covered.

## Failures: none. Pre-existing failures: none.
