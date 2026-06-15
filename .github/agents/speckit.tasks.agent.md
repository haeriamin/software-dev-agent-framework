---
description: Break the approved plan into atomic, independently testable, dependency-ordered tasks.
handoffs:
  - label: Implement the slice
    agent: speckit.implement
    prompt: Tasks ready. Execute the implementation lifecycle.
    send: true
---

## User Input

```text
$ARGUMENTS
```

## Pre/Post Hooks

Check `.specify/extensions.yml` for `hooks.before_tasks` / `hooks.after_tasks` per [extension hook protocol](../instructions/extension-hooks.instructions.md).

## Outline

1. Verify prerequisites: `check-prerequisites -Phase tasks` (spec + plan exist; design Approved if HIGH/CRITICAL).
2. Load plan (+ design if present). Create `specs/NNN-*/tasks.md` from `.specify/templates/tasks-template.md`.
3. Derive tasks:
   - One task = one logical unit of behavior, independently testable and reversible (ARCHITECTURE.md §12.2).
   - Phase order: Setup → Interfaces & Contracts → Core Logic → Integration → Tests Hardening → Documentation.
   - Every task line carries: id (T00N), description, *FR/SC reference, standard clause, files touched*.
   - Mark `[P]` only where tasks share no files and no ordering dependency.
   - Design contracts (if design.md exists) become explicit "implement against contract §X" tasks — tasks never reinvent contracts.
4. Sanity checks before reporting:
   - Every in-scope FR maps to ≥ 1 task; every task maps to ≥ 1 FR (no orphan work).
   - No task requires a dependency absent from the plan's new-dependency list.
   - Test-hardening tasks reference the spec's success criteria.
5. Report: task count per phase, parallelizable count, dependency notes, readiness for `/speckit.implement`. Append to `wiki/log.md`.
