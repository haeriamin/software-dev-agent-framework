# Validation Run Artifacts

The complete, unedited operational artifacts from the 2026-06-11 validation run
(see [../2026-06-11-greenfield-tasks-api.md](../2026-06-11-greenfield-tasks-api.md) for the narrative).

They live here, **not** in the framework's live `specs/` `work-queue/` `review-reports/`
`targets/` directories, so a fresh clone of the framework starts clean — these are evidence
and worked examples, not your project's state.

```
specs/001-tasks-api/         spec, plan, design (3 ADRs), tasks for the greenfield slice
specs/002-adapter-hardening/ spec, plan, tasks for the feature follow-up slice
work-queue/                  analysis, implementation report, work items
review-reports/              test reports + review reports (verdicts 0.96 → 1.00)
targets/sdd-demo-tasks-api.yml   the target registry entry used (absolute path is the
                                 author's machine — illustrative only)
```

The code these artifacts describe was built in a **separate** repository
(`sdd-demo-tasks-api`), not included here. To see real filled-in examples of every
artifact type the lifecycle produces, read these.
