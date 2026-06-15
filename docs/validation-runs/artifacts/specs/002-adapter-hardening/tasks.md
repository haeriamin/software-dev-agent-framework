# Tasks: Adapter Hardening

**Slice ID**: 002-adapter-hardening | **Target**: sdd-demo-tasks-api | **Created**: 2026-06-11

- [x] **T001** Add `/v1` prefix + injectable `Logger` seam to `createServer`; CLI entry supplies a real logger — *FR-002, FR-003; API-05, ENG-01, DEL-03; files: src/server.ts*
- [x] **T002** Integration tests: 201 create, 400 blank-title, 400 invalid-JSON, 200 list, 400 limit, 404 unknown, 404 unversioned — *FR-001; TST-01, TST-03; files: test/server.test.ts*
- [x] **T003** README: document `/v1` routes — *FR-002; files: README.md*

## Definition of Done
Decision Record per task; `npm test` + `npm run lint` + `npm audit` exit 0; regression suite green.
