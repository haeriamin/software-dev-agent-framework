# Validation Run — Greenfield: tasks REST API

**Date**: 2026-06-11 · **Mode**: greenfield · **Slice**: 001-tasks-api ·
**Target**: sdd-demo-tasks-api (external, `X:/Work/sdd-demo-tasks-api`) ·
**Verdict**: PASS (0.96) · **Driver**: a Claude Code agent acting as the framework's personas

This is the first real end-to-end execution of the framework — the evidence STATUS.md said
did not yet exist. It is one run, not a benchmark, but it converts "never been run" into
"run once, here's exactly what happened."

## What was actually produced

- A **working external project**: 410 LOC across 11 files, on branch `sdd/001-tasks-api`,
  never merged (Principle VI held).
- **8/8 behavior tests pass**, `node --test` exit 0; typecheck exit 0; `npm audit` 0 vulns
  — all real command executions, captured in the test report.
- Full artifact chain: spec → analysis → plan → design (3 ADRs) → tasks → implementation
  report (9 Decision Records) → test report → review report with a per-rule disposition
  table over 20 scored standards.

## Did it follow proper principles? (observed, not asserted)

| Principle | Held? | Evidence |
|-----------|-------|----------|
| Knowledge before action | Yes | Bootstrap read populated wiki; analysis cited PAT-001 |
| Cite or don't ship | Yes | Every task carried a spec + standard citation; review re-verified 6 against source, all apposite |
| Reversible only | Yes | All work on `sdd/001-tasks-api`; nothing merged/pushed |
| Confidence-gated | Yes | Review scored 0.96 with itemized dispositions; found a real gap rather than rubber-stamping |
| Quality-loop-first (greenfield) | **Caught a real bug** | Scaffold gate refused to pass until `@types/node` was fixed — before any feature code |

## Bugs the process surfaced (the valuable part)

1. **Scaffold gate did its job**: the empty skeleton failed typecheck (`node:test` types
   missing). The "verify green before feature code" rule blocked progress until fixed — a
   misconfiguration that would otherwise have surfaced much later.
2. **Stale build artifacts**: `tsc` doesn't clean `dist/`, so a deleted test kept running.
   The Tester noticed the count was wrong, added a `clean` step. Without an attentive test
   phase this would have let removed code keep executing — a genuine correctness trap.
3. **Reviewer found an uncovered surface**: the http adapter (`server.ts`) has no tests.
   The review docked `test_evidence` to 0.90 and filed a follow-up rather than passing
   clean — exactly the non-rubber-stamp behavior the design promises.

## Honest friction & limitations of this run

- **The driver is one model wearing eight hats.** This validates that the runbooks are
  *followable* and *catch real issues*; it does **not** prove the separation-of-duties
  safety claim, because there were not two independent reviewers. (STATUS.md §4 still stands.)
- **No A/B.** I did not build the same API with plain Copilot to compare cost/defects. The
  next run should (see `docs/10-validation.md`).
- **Effort was front-loaded.** Spec+plan+design for a ~400-LOC API is heavy; the payoff was
  the traceability and the three caught bugs, not speed. For this size, `--micro` would
  have been the honest lane — this run used the full pipeline deliberately, to exercise it.
- **`standards_compliance = 1.00` is judgment-heavy.** 18 of 20 scored rules were judged,
  not tool-checked (only `npm audit` and `tsc` were deterministic). The amended Principle V
  is honest about this; it's why the disposition table exists for a human to audit.

## Reproduce

The demo project was built in a separate repo (the author's `sdd-demo-tasks-api`); its
build/test loop was `npm install && npm test && npm run lint && npm audit` (all exit 0).

**The full artifacts** — spec, plan, design, tasks, analysis, implementation/test/review
reports, and the target entry, for both slices — are preserved under
[`artifacts/`](artifacts/) (relocated there so the framework's live `specs/`, `work-queue/`,
`review-reports/`, and `targets/` stay clean for your own work).

## Follow-up: slice 002 closed the review's findings (feature mode)

The 0.96 was not a ceiling to game — it pointed at a real gap, so a second slice fixed it
(and exercised **feature mode** on the now-existing target):

- **Adapter coverage gap** → 7 integration tests over a real ephemeral server (`fetch` against
  port 0). Suite went 8 → **15 tests, all passing**.
- **API-05 advisory** → all routes moved under `/v1`; unversioned paths now 404.
- **console.log advisory** → injectable `Logger` seam (default silent; CLI supplies a real one).

Re-review: **PASS, confidence 1.00** (`review-reports/sdd-demo-tasks-api/002-adapter-hardening-review.md`).

**On the 1.00**: it means every *specified* behavior is tested and every *applicable* rule is
satisfied by the available evidence — not "bug-free". The review still declares one untested
defensive branch (the request-stream error guard, out of FR scope) rather than hiding it.
A score that reaches 1.00 *after* a real fix is the loop working; a score that started at
1.00 would have been the rubber-stamp failure mode. The progression 0.96 → fix → 1.00 is the
healthy shape.

## Bottom line

The framework *works as specified* on real tasks: across two slices (greenfield + feature) it
produced correct, tested, cited code; **caught three real problems**; and used its own review
findings to drive a follow-up to a clean pass. What remains unproven is comparative value
(vs. baseline) and the multi-reviewer safety claim. Two honest data points, with the gaps named.
