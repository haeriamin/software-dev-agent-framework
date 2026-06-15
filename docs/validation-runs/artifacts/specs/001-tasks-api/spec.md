# Feature Specification: Tasks REST API

**Slice ID**: 001-tasks-api
**Target**: sdd-demo-tasks-api
**Created**: 2026-06-11
**Status**: Draft
**Input**: "A REST API to manage tasks with a cursor-paginated list endpoint" (greenfield)

## User Scenarios & Testing *(mandatory)*

### Primary User Story
A client application needs to create tasks and list them back in pages, so it can show a
task list without loading everything at once.

### Acceptance Scenarios
1. **Given** an empty store, **When** a task is created with a title, **Then** it is returned with an id, status `open`, and a created timestamp.
2. **Given** several tasks, **When** the list endpoint is called with a limit, **Then** at most that many tasks are returned plus a `next_cursor` when more remain.
3. **Given** a `next_cursor` from a prior page, **When** the list endpoint is called with it, **Then** the following page is returned and `next_cursor` is null on the last page.

### Edge Cases
- Create with a missing/blank title → structured 400 error, no task created.
- List with `limit` out of range (0, negative, > 100) → structured 400 error.
- List with an unknown cursor → structured 400 error (not a crash, not silent empty).

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: System MUST create a task from a non-empty `title`, assigning `id`, `status="open"`, and `createdAt` (ISO-8601).
- **FR-002**: System MUST list tasks newest-first, cursor-paginated, with a caller-supplied `limit` (default 20, bounds 1–100).
- **FR-003**: System MUST return a page envelope `{ items, next_cursor }`; `next_cursor` is null when no further pages remain.
- **FR-004**: System MUST validate all input at the boundary and return a structured error `{ code, message, details? }` with HTTP 400 on invalid input.
- **FR-005**: List responses MUST expose only `{ id, title, status, createdAt }` (explicit DTO, no internal fields).

### Non-Functional Requirements
- **NFR-001**: Handlers MUST be unit-testable without binding a network socket (IO behind a port).

### Key Entities
- **Task**: `id` (string), `title` (string), `status` ("open"|"done"), `createdAt` (ISO-8601 string).

## Success Criteria *(mandatory)*

- **SC-001**: All acceptance scenarios pass as automated tests, runnable via the target's test command.
- **SC-002**: Test and lint (typecheck) commands exit 0 on the finished slice.
- **SC-003**: No unbounded list path exists (every list response is a bounded page).

## Scope & Boundaries *(mandatory)*

### In Scope
- Create-task and list-tasks behaviors; in-memory store; input validation; error envelope.

### Out of Scope
- Persistence/database, auth, update/delete, real HTTP server hardening (a thin adapter is acceptable but logic lives in unit-testable handlers).

### Dependencies
- None external beyond the dev toolchain (TypeScript, Node test runner).

### Assumptions
- In-memory store is acceptable for the demo (documented; not a production datastore).
- Cursor = opaque encoding of the last item's position; demo uses created-order index.

## Complexity Classification

**Class**: MEDIUM
**Rationale**: 2–5 modules, internal API only, standard patterns matched (PAT-001 REST
Pagination), no auth/payments/PII surface (so not CRITICAL per SEC-05). Greenfield → design
mandatory regardless.
