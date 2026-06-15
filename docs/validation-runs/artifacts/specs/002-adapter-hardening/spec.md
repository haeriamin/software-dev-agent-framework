# Feature Specification: Adapter Hardening

**Slice ID**: 002-adapter-hardening
**Target**: sdd-demo-tasks-api
**Created**: 2026-06-11
**Status**: Draft
**Input**: Close the three findings from the 001-tasks-api review (review-reports/sdd-demo-tasks-api/001-tasks-api-review.md)

## User Scenarios & Testing *(mandatory)*

### Primary User Story
The API's HTTP layer must be trustworthy and version-ready, with its behavior proven by
tests rather than assumed.

### Acceptance Scenarios
1. **Given** a running server, **When** any documented route is exercised over HTTP, **Then** it returns the correct status and envelope (proven by integration tests).
2. **Given** the API, **When** a client calls a route, **Then** it is served under a version prefix `/v1`.
3. **Given** the server in the request path, **When** it logs, **Then** it uses an injected logger seam (no bare console in the handler path).

### Edge Cases
- Invalid JSON body → 400 `INVALID_JSON`.
- Unknown route and unversioned path → 404.

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The http adapter MUST have integration tests covering create (201), validation (400), invalid JSON (400), list (200), and not-found (404).
- **FR-002**: All routes MUST be served under the `/v1` prefix (API-05 versioning scheme).
- **FR-003**: Request-path logging MUST go through an injectable `Logger` seam defaulting to silent in-process; the CLI entry point supplies a real logger.

## Success Criteria *(mandatory)*

- **SC-001**: `test_evidence` gap from slice 001 closed — adapter behaviors are covered by passing tests.
- **SC-002**: Test + lint + audit all exit 0.

## Scope & Boundaries *(mandatory)*

### In Scope
- Adapter integration tests; `/v1` prefix; logger seam; README route update.

### Out of Scope
- New endpoints/behavior; persistence; auth.

### Assumptions
- Breaking the unversioned path is acceptable pre-release (no external consumers yet).

## Complexity Classification

**Class**: LOW
**Rationale**: Single module surface (server.ts) + tests; no schema/contract change beyond
adding a version prefix; no security/PII surface. No design.md required.
