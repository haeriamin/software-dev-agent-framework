# Design: Tasks REST API

**Slice ID**: 001-tasks-api
**Target**: sdd-demo-tasks-api
**Author**: ArchitectAgent
**Status**: Approved (greenfield design; human-approved 2026-06-11 for this validation run)
**Created**: 2026-06-11

## Context
Greenfield demo API. Design attention warranted because greenfield mode makes stack and
layout ADRs (mandatory), and the pagination contract must be unit-testable without a socket.

## Component Design

### Components
| Component | Responsibility | Path | New/Modified |
|-----------|----------------|------|--------------|
| Task + DTO | Entity type, `toDTO` field allowlist | src/task.ts | New |
| TaskStore | In-memory store behind a reader port | src/store.ts | New |
| Cursor codec | Encode/decode opaque cursor ↔ index | src/cursor.ts | New |
| Handlers | `createTask`, `listTasks` (pure over the port) | src/handlers.ts | New |
| HTTP adapter | Maps node:http req/res to handlers | src/server.ts | New |

### Interfaces & Contracts
```ts
type Status = "open" | "done";
interface Task { id: string; title: string; status: Status; createdAt: string; createdIndex: number; }
interface TaskDTO { id: string; title: string; status: Status; createdAt: string; }
interface Page<T> { items: T[]; next_cursor: string | null; }
interface TaskReader { listNewestFirst(afterIndex: number | null, limit: number): { items: Task[]; more: boolean }; }
type Result<T> = { ok: true; value: T } | { ok: false; error: { code: string; message: string; details?: unknown } };

createTask(store, input: unknown): Result<TaskDTO>           // FR-001, API-04
listTasks(reader, query: unknown): Result<Page<TaskDTO>>      // FR-002..005
```

### Data Flow
http adapter → parse req → handler(validate → port → envelope) → Result → adapter maps
`ok` to 200/201 JSON, `!ok` to 400 structured error. No business logic in the adapter.

## Architecture Decision Records

### ADR-001: Stack — TypeScript + Node built-in test runner, zero runtime deps
- **Status**: Accepted
- **Context**: Demo target; want a real, fast, reliable test loop without registry-flaky installs.
- **Decision**: TypeScript (dev dep) compiled to `dist/`; tests via `node --test`; lint = `tsc --noEmit`.
- **Alternatives**: Express + Vitest (more realistic, heavier install, more deps — rejected for a demo; ENG-05 favors fewer deps); Jest (extra config — rejected).
- **Consequences**: + minimal deps, fast CI; − http adapter is hand-rolled (acceptable, logic is in handlers).
- **Standard basis**: engineering-standards.md §ENG-05, testing-standards.md §TST-05.

### ADR-002: IO behind a reader port
- **Status**: Accepted
- **Context**: NFR-001 requires unit-testing handlers without a socket.
- **Decision**: Handlers take a `TaskReader`/store interface; tests pass an in-memory instance directly.
- **Consequences**: + handlers are pure and trivially testable; mirrors the PAT-001 exemplar's port design.
- **Standard basis**: engineering-standards.md §ENG-01.

## Security & Failure Analysis
- **Trust boundaries crossed**: HTTP input → handler. Mitigation: validate at boundary (API-04), never trust `limit`/`cursor`/`title`.
- **Failure modes**: bad input → structured 400, no state change; unknown cursor → 400 (not crash, not silent empty); internal error → propagate (ENG-02), adapter returns 500 envelope.
- **Data sensitivity**: none. No auth/PII/payments ⇒ not CRITICAL (SEC-05 does not apply). DTO allowlist still applied (SEC-04).

## Open Questions
None blocking.
