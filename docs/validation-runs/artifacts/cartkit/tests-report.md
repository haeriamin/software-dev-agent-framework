# Test Evidence Report: 001-enforce-stock-limit

**Date**: 2026-06-16  
**Tester Persona**: Throughline Spec-Driven Development  
**Target**: cartkit/add_to_cart  
**Specification**: X:\Work\throughline\specs\001-enforce-stock-limit\spec.md

---

## Test Execution

**Command run** (from X:\Work\cartkit):
```
py -m unittest discover -s tests -v
```

**Exit code**: 1 (FAILED)

**Summary**:
- Total tests run: 11
- Passed: 9
- Failed: 2

---

## Test Results

```
test_adds_a_new_item (test_cart.TestAddToCart) ... ok
test_allows_accumulation_when_total_equals_stock (test_cart.TestAddToCart) ... ok
test_does_not_mutate_input_with_multiple_items (test_cart.TestAddToCart) ... ok
test_does_not_mutate_the_input_cart (test_cart.TestAddToCart) ... ok
test_increments_an_existing_item (test_cart.TestAddToCart) ... ok
test_rejects_accumulation_when_total_exceeds_stock (test_cart.TestAddToCart) ... FAIL
test_rejects_boolean_qty (test_cart.TestAddToCart) ... ok
test_rejects_float_qty (test_cart.TestAddToCart) ... ok
test_rejects_fresh_item_when_qty_exceeds_stock (test_cart.TestAddToCart) ... FAIL
test_rejects_negative_qty (test_cart.TestAddToCart) ... ok
test_rejects_zero_qty (test_cart.TestAddToCart) ... ok

Ran 11 tests in 0.001s

FAILED (failures=2)
```

---

## Failure Details

### Failure 1: test_rejects_fresh_item_when_qty_exceeds_stock

```
FAIL: test_rejects_fresh_item_when_qty_exceeds_stock (test_cart.TestAddToCart)
SC1: add_to_cart({}, "x", 5, stock=3) raises ValueError (FR2, fresh item).
----------------------------------------------------------------------
Traceback (most recent call last):
  File "X:\Work\cartkit\tests\test_cart.py", line 21, in test_rejects_fresh_item_when_qty_exceeds_stock
    with self.assertRaises(ValueError):
AssertionError: ValueError not raised
```

**Root cause**: FR2 (Reject over-stock adds) is not implemented. The function does not validate that a fresh item's qty does not exceed stock.

---

### Failure 2: test_rejects_accumulation_when_total_exceeds_stock

```
FAIL: test_rejects_accumulation_when_total_exceeds_stock (test_cart.TestAddToCart)
SC2: add_to_cart({"x": 2}, "x", 2, stock=3) raises ValueError (FR2, accumulation pushes total to 4 > 3).
----------------------------------------------------------------------
Traceback (most recent call last):
  File "X:\Work\cartkit\tests\test_cart.py", line 27, in test_rejects_accumulation_when_total_exceeds_stock
    with self.assertRaises(ValueError):
AssertionError: ValueError not raised
```

**Root cause**: FR2 (Reject over-stock adds) is not implemented. The function does not validate that accumulated qty does not exceed stock.

---

## Coverage Map: Specification to Test Methods

| FR / SC | Requirement | Test Method(s) | Status |
|---------|-------------|-----------------|--------|
| FR1 | Reject non-positive qty | test_rejects_zero_qty, test_rejects_negative_qty | PASS |
| FR1 | Reject non-integer qty | test_rejects_float_qty, test_rejects_boolean_qty | PASS |
| FR2 | Reject over-stock (fresh item) | test_rejects_fresh_item_when_qty_exceeds_stock | **FAIL** |
| FR2 | Reject over-stock (accumulation) | test_rejects_accumulation_when_total_exceeds_stock | **FAIL** |
| FR2 | Boundary: total == stock allowed | test_allows_accumulation_when_total_equals_stock | PASS |
| FR3 | Accumulate existing items | test_increments_an_existing_item | PASS |
| FR4 | No mutation of input cart | test_does_not_mutate_the_input_cart, test_does_not_mutate_input_with_multiple_items | PASS |
| SC1 | add_to_cart({}, "x", 5, stock=3) raises ValueError | test_rejects_fresh_item_when_qty_exceeds_stock | **FAIL** |
| SC2 | add_to_cart({"x": 2}, "x", 2, stock=3) raises ValueError | test_rejects_accumulation_when_total_exceeds_stock | **FAIL** |
| SC3 | add_to_cart({"x": 2}, "x", 1, stock=3) returns {"x": 3} | test_allows_accumulation_when_total_equals_stock | PASS |
| SC4 | Regression: happy-path and FR1/FR4 unchanged | test_adds_a_new_item, test_increments_an_existing_item, test_does_not_mutate_the_input_cart, test_rejects_zero_qty, test_rejects_negative_qty, test_rejects_float_qty, test_rejects_boolean_qty | PASS |

---

## Source Fingerprint

**Repository**: X:\Work\cartkit

**HEAD commit**:
```
d68e32a1d07204e9aec11e6685d0cb0d512ed292
```

**Working tree status**:
```
 M tests/test_cart.py
?? cartkit/__pycache__/
?? tests/__pycache__/
```

**Modified file**: tests/test_cart.py (tests added; no implementation changes)

---

## Finding Summary

**Tests Added**: 8 new test methods covering FR1 (regression), FR2 (core gap), FR3, and FR4.

**Failures**: 2 tests fail against the current implementation:
1. **test_rejects_fresh_item_when_qty_exceeds_stock** — FR2 gap (fresh item stock validation missing)
2. **test_rejects_accumulation_when_total_exceeds_stock** — FR2 gap (accumulation stock validation missing)

**Passing**: 9 tests pass, including:
- All FR1 cases (non-positive, non-integer qty rejection)
- FR2 boundary case (total == stock is allowed) ✓
- FR3 (accumulation with passing stock limit)
- FR4 (no mutation)
- All original happy-path tests (regression OK)

**Recommendation**: The two FR2 failures are **expected findings**. They trace directly to the specification gap identified in the problem statement: stock limit enforcement is not currently implemented. The tests correctly derive from the enumerated functional requirements and success criteria and expose the gap. Implementation of stock validation in `add_to_cart` will resolve both failures.
