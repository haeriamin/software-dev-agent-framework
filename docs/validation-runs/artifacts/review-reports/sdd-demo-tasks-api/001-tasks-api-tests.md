# Test Report: 001-tasks-api
**Target**: sdd-demo-tasks-api | **Date**: 2026-06-11 | **Branch**: sdd/001-tasks-api
**Source fingerprint**: HEAD of sdd/001-tasks-api
**Command**: `npm test` (= `npm run clean && tsc -p . && node --test dist/test/`) | **Exit code**: 0
**Results**: 8 passed / 0 failed / 0 skipped (8 new tests)

## Coverage of changed behavior

| Behavior (FR/SC) | Test | Status |
|------------------|------|--------|
| FR-001 create with id/status/createdAt, title trimmed | creates a task with id, open status, and timestamp | COVERED |
| FR-004 blank title → 400, nothing persisted | rejects a blank title … creates nothing | COVERED |
| FR-004 missing body → 400 | rejects a missing body | COVERED |
| FR-002/003 newest-first, bounded, next_cursor | lists newest-first and bounds to the limit | COVERED |
| FR-003 full paging, null cursor on last page | walks all pages and ends with a null cursor | COVERED |
| FR-004 limit bounds (0/-1/101/abc/2.5) → 400 | rejects out-of-range limits | COVERED |
| FR-004/SC-003 unknown/malformed cursor → 400, no crash | rejects an unknown or malformed cursor | COVERED |
| FR-005/SEC-04 DTO allowlist, no createdIndex | list DTO exposes only allowlisted fields | COVERED |

Every in-scope FR and SC has a passing test. No MISSING rows.

## Deterministic tool evidence
- `npm audit` → **found 0 vulnerabilities** (DEL-01, exit 0).
- `tsc --noEmit` (lint gate) → exit 0.

## Failures (verbatim)
None.

## Pre-existing failures (out of scope)
None (greenfield).

## Notes
- Stale-artifact defect found and fixed: `tsc` did not clean `dist/`, so a deleted
  `smoke.test.js` kept running. Added a `clean` step to the build; re-run is authoritative
  at 8 tests. (TST-06-adjacent: ensures the runner can't execute removed code.)
