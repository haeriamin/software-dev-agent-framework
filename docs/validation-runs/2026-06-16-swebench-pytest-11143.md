# Validation run: SWE-bench Lite `pytest-dev__pytest-11143`

**Date:** 2026-06-16 · **Target:** [pytest](https://github.com/pytest-dev/pytest) at base `6995257cf` · **Mode:** `/dev.feature --micro` (Implementer, Tester, independent Reviewer) · **Outcome:** solved. The hidden benchmark test passes, and nothing else broke.

## The short version

We pointed Throughline at a real GitHub issue from a well-known project (pytest) and gave it only the bug report, never the benchmark's hidden test. Its build-then-test loop found the root cause and fixed it in one line. That fix makes the benchmark's gold `FAIL_TO_PASS` test pass and leaves the rest of the affected suite green (115 passed, 1 skipped). The Tester went a step further than the gold test on its own, covering `int`, `float`, and `complex` leading constants plus two regression guards. That extra coverage is exactly what the framework is supposed to add.

## The ticket the agents saw

A pytest user reported that collecting a test file whose first expression is a number crashes with:

```
TypeError: argument of type 'int' is not iterable
```

The agents got the raw bug report and nothing else. They never saw the benchmark's gold patch or its hidden test.

## Setup

Cloned pytest at the instance's base commit into an isolated venv, registered it as a Throughline target, and made the slice branch `sdd/fix-rewrite-leading-number`. The three `--micro` phases ran as separate, role-scoped agents in independent contexts, driven through the runbooks.

## Phase 1: Implementer

It found the root cause without help. `AssertionRewriter.run` treats the first expression as a docstring whenever it's an `ast.Constant`, but `ast.Constant` covers every literal, including ints, floats, bytes, and `None`. So a leading `0` becomes `doc = 0`, and then `is_rewrite_disabled` runs `"PYTEST_DONT_REWRITE" in 0`, which raises the `TypeError`.

```diff
# src/_pytest/assertion/rewrite.py  (AssertionRewriter.run)
                 expect_docstring
                 and isinstance(item, ast.Expr)
                 and isinstance(item.value, ast.Constant)
+                and isinstance(item.value.value, str)  # ticket: pytest-11143 leading-number-as-docstring
             ):
                 doc = item.value.value
```

One line, in the style of the surrounding code, with a cited Decision Record. It happens to be the same guard pytest's own gold patch uses, reached from the ticket alone.

## Phase 2: Tester

It wrote `testing/test_issue11143_leading_number.py` (5 tests, in pytest's own `pytester` style) and proved the tests meant something with a real red-then-green:

| Test (leading expression) | fix absent | fix present |
|---|---|---|
| `0` (int) | fails, `TypeError: … 'int' …` | passes |
| `3.14` (float) | fails, `TypeError: … 'float' …` | passes |
| `1j` (complex) | fails, `TypeError: … 'complex' …` | passes |
| real `"""docstring"""` still works | passes | passes |
| `PYTEST_DONT_REWRITE` in a string still honoured | passes | passes |

Fix absent: 3 failed, 2 passed (exit 1). Fix present: 5 passed (exit 0).

## The objective score

We then applied the instance's hidden gold test and ran it against Throughline's fix:

```
FAIL_TO_PASS  testing/test_assertrewrite.py::TestIssue11140::test_constant_not_picked_as_module_docstring
              -> 1 passed
regression    testing/test_assertrewrite.py  -> 115 passed, 1 skipped
```

SWE-bench Lite `pytest-11143`: resolved.

## Phase 3: independent Reviewer

A fresh agent that wrote none of the code or tests re-checked everything itself. It ran the new test (5 passed), stashed the fix to confirm the ticket's `TypeError` came back, then restored it and saw the tests pass again. It ran the regression file (114 passed, 1 skipped; 119 combined). It even added its own edge cases, trying `None`, `True`, `False`, and `b'bytes'`, all handled.

Its verdict was PASS at confidence 0.903 (spec alignment 0.95, test evidence 0.95, standards compliance 0.85), with no defects. The one honest deduction was that the fix adds no docstring or CHANGELOG note, which is fine for a one-line change. It also pinned the exact failing path, `is_rewrite_disabled` doing `"PYTEST_DONT_REWRITE" in <int>`.

## Honest caveats

This was hand-driven, not the native host runtime. The personas ran as faithful, role-separated subagents through the runbooks, but outside a host that auto-loads `.claude/` and the hooks, so the write-guard hooks weren't actively enforcing; the agents kept to the constraints by instruction instead. The property that matters most, Implementer, Tester, and Reviewer as separate contexts, held.

The models weren't uniform. Implementer and Tester ran on the medium tier (Sonnet), and the Reviewer ran on a lighter model (Haiku) after an API capacity spike forced the swap. So this is a different-context and different-model check, but with a weaker reviewer than we'd want. The intended setup is a reviewer at least as strong as the builder.

And it's one instance in `--micro` mode, a single small fix rather than a sweep. The obvious next step is several instances, including a larger repo or two, for a real distribution.

## Takeaway

On a real issue from a well-known project, scored by the issue's own hidden test, Throughline's build-then-test loop produced a correct, regression-free, root-cause fix, and the Tester broadened the coverage past the benchmark's single case on its own. That's the framework doing what it's meant to do on a recognized benchmark, and it's the first concrete, objective evidence beyond the original three-task A/B.
