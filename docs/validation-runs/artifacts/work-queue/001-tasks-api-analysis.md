## Analysis: sdd-demo-tasks-api / greenfield
**Slice**: 001-tasks-api | **Date**: 2026-06-11 | **Source fingerprint**: empty (git rev: none; 1 entry = .git)

- **Complexity Class**: MEDIUM — internal API, standard pattern matched, no sensitive surface (SEC-05 not triggered). Greenfield ⇒ design mandatory.
- **Mode**: greenfield (target empty).
- **Affected Modules**: all new — store, handlers, validation, http adapter, tests.
- **Existing Conventions Detected**: none (empty). Conventions set by scaffold ADRs.
- **Standards Violations (pre-existing)**: none (no code yet).
- **Matched Patterns**: PAT-001 Cursor-Paginated Collection Endpoint (relevance 0.90) → exemplars/good/api/paginated-endpoint.ts. Directly covers FR-002/003/004/005.
- **Unmatched Needs**: create-task validation (no dedicated pattern; trivial, governed by API-04 directly).
- **Risk Register**:
  | Risk | L | I | Mitigation |
  |------|---|---|-----------|
  | Cursor scheme ambiguity | M | L | Spec assumption: created-order index; opaque base64 |
  | Test runner choice locks convention | L | M | Use Node built-in node:test (zero dep) — TST-05 |
  | Unbounded list slips in | L | H | SC-003 + API-02; list handler always bounds limit |
- **Recommended Approach**: implement PAT-001 with a `TaskStore` reader port; handlers pure over the port; thin `node:http` adapter; node:test unit tests against handlers.
- **Confidence**: 0.88
