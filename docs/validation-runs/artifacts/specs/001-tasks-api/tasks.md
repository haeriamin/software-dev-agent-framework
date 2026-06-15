# Tasks: Tasks REST API

**Slice ID**: 001-tasks-api
**Target**: sdd-demo-tasks-api
**Plan**: [plan.md](plan.md)
**Created**: 2026-06-11

## Phase 1: Setup (scaffold)
- [x] **T001** Project skeleton: package.json, tsconfig.json, .gitignore, README; verify `node --test` and `npx tsc --noEmit` exit 0 on empty skeleton — *SC-002; standards/engineering-standards.md §ENG-04; files: package.json, tsconfig.json, .gitignore, README.md, test/smoke.test.ts*

## Phase 2: Interfaces & Contracts
- [x] **T002** Task + DTO types and `toDTO` allowlist — *FR-005; SEC-04; files: src/task.ts*
- [x] **T003** Cursor codec (encode/decode index, reject malformed) — *FR-003, FR-004; API-04; files: src/cursor.ts*
- [x] **T004** In-memory store implementing `TaskReader` + append — *NFR-001; ENG-01; files: src/store.ts*

## Phase 3: Core Logic
- [x] **T005** `createTask` handler: validate non-empty title, assign id/status/createdAt — *FR-001; API-04, ENG-02; files: src/handlers.ts*
- [x] **T006** `listTasks` handler: bounded limit, cursor paging, newest-first, page envelope, DTO — *FR-002, FR-003, FR-004, FR-005; API-02, API-03, API-04, SEC-04; files: src/handlers.ts*

## Phase 4: Integration
- [x] **T007** Thin node:http adapter mapping Result → status + JSON; no logic — *FR-001..004; API-03; files: src/server.ts*

## Phase 5: Tests Hardening
- [x] **T008** Tests: create happy + blank-title 400; list paging + last-page null cursor + limit bounds (0/neg/>100) 400 + unknown cursor 400; DTO shape has no internal fields — *SC-001, SC-003; TST-01, TST-03, TST-04; files: test/handlers.test.ts*

## Phase 6: Documentation
- [x] **T009** README: run/test instructions, endpoint summary — *files: README.md*

## Definition of Done (per task)
Decision Record written; `node --test` exits 0; `tsc --noEmit` exits 0; no unlogged PARTIAL.
