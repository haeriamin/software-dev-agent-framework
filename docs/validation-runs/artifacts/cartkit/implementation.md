# Implementation Decision Record — Slice 001: Enforce add_to_cart Input Rules

**Date**: 2026-06-16  
**Status**: COMPLETE  
**Spec Reference**: X:\Work\throughline\specs\001-enforce-stock-limit\spec.md

## Changes Made

**File**: `X:\Work\cartkit\cartkit\cart.py`

**Lines added** (lines 13-16):
```python
new_total = new_cart.get(item_id, 0) + qty
if new_total > stock:
    raise ValueError("resulting total would exceed stock")
new_cart[item_id] = new_total
```

**Diff (before and after)**:
- Before (line 13): `new_cart[item_id] = new_cart.get(item_id, 0) + qty`
- After (lines 13-16): Compute total first, validate against stock, then assign.

## Spec Requirements Satisfied

- **FR2 — Reject over-stock adds**: The implementation now checks if the resulting total quantity would exceed `stock` (line 14-15). If it does, a `ValueError` is raised and the item is not added.
- **SC1**: `add_to_cart({}, "x", 5, stock=3)` raises `ValueError` ✓
- **SC2**: `add_to_cart({"x": 2}, "x", 2, stock=3)` raises `ValueError` (4 > 3) ✓
- **SC3**: `add_to_cart({"x": 2}, "x", 1, stock=3)` returns `{"x": 3}` (boundary: total == stock allowed) ✓

## Engineering Standards Applied

**Standard**: ENG-02: Explicit Error Handling
- Per engineering-standards.md: "Errors are handled or propagated explicitly; empty catch blocks and swallowed promise rejections are forbidden."
- The implementation raises a `ValueError` explicitly (lines 14-15) when the resulting total would exceed the stock limit, rather than silently accepting or logging the violation.
- This satisfies ENG-02's requirement for explicit error propagation when validation fails.

## Test Results

**Command**: `py -m unittest discover -s tests -v`

**Output**:
```
test_adds_a_new_item (test_cart.TestAddToCart) ... ok
test_allows_accumulation_when_total_equals_stock (test_cart.TestAddToCart)
SC3: add_to_cart({"x": 2}, "x", 1, stock=3) returns {"x": 3} (FR2 boundary: total == stock is allowed). ... ok
test_does_not_mutate_input_with_multiple_items (test_cart.TestAddToCart)
FR4: Input cart must not be mutated regardless of content. ... ok
test_does_not_mutate_the_input_cart (test_cart.TestAddToCart) ... ok
test_increments_an_existing_item (test_cart.TestAddToCart) ... ok
test_rejects_accumulation_when_total_exceeds_stock (test_cart.TestAddToCart)
SC2: add_to_cart({"x": 2}, "x", 2, stock=3) raises ValueError (FR2, accumulation pushes total to 4 > 3). ... ok
test_rejects_boolean_qty (test_cart.TestAddToCart)
FR1: qty must not be a boolean (even though bool is int subclass in Python). ... ok
test_rejects_float_qty (test_cart.TestAddToCart)
FR1: qty must be an integer. ... ok
test_rejects_fresh_item_when_qty_exceeds_stock (test_cart.TestAddToCart)
SC1: add_to_cart({}, "x", 5, stock=3) raises ValueError (FR2, fresh item). ... ok
test_rejects_negative_qty (test_cart.TestAddToCart)
FR1: qty must be positive. ... ok
test_rejects_zero_qty (test_cart.TestAddToCart)
FR1: qty must be positive. ... ok

----------------------------------------------------------------------
Ran 11 tests in 0.001s

OK
```

**Exit Code**: 0 (all tests passed)

## Verification

- ✓ FR1 (reject non-positive/non-integer qty) preserved
- ✓ FR2 (reject over-stock adds) implemented
- ✓ FR3 (accumulate existing items) preserved
- ✓ FR4 (no mutation) preserved
- ✓ All 11 tests green; no test files modified
