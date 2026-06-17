# cartkit Codebase Analysis

## Overview
cartkit is a minimal Python shopping-cart library implementing a single public function `add_to_cart(cart, item_id, qty, stock)` that adds items to a cart while enforcing stock limits. The implementation is immutable (no input mutation) and includes comprehensive input validation per SPEC.md. Total surface: one module with one function.

---

## Module Map

| File | Responsibility |
|------|---|
| `cartkit/__init__.py` (3 lines) | Package initialization; exports `add_to_cart` as sole public API. |
| `cartkit/cart.py` (18 lines) | Core logic: `add_to_cart()` function implements R1–R4 from SPEC.md. |
| `tests/test_cart.py` (68 lines) | unittest-based test suite; 11 test cases covering new items, accumulation, stock rejection, non-positive qty, float/bool rejection, and immutability. |
| `SPEC.md` | Behavioral specification: four rules (R1–R4) for qty validation, stock respect, accumulation, and no-mutation guarantee. |
| `README.md` | Project overview and test invocation instructions. |

---

## Conventions Found (with evidence)

| Convention | Evidence | Notes |
|---|---|---|
| **Test Framework** | `tests/test_cart.py:1,6` — `import unittest` and `class TestAddToCart(unittest.TestCase)` | Standard Python unittest; no pytest or other framework. |
| **Naming** | `cartkit/cart.py:4` — function named `add_to_cart`, parameter names `cart`, `item_id`, `qty`, `stock` | Snake_case function and parameters; descriptive, no abbreviations beyond `qty`/`stock`. |
| **Error Handling** | `cartkit/cart.py:10,15` — explicit `raise ValueError(...)` with descriptive messages | ValueError for all validation failures; two distinct error scenarios (qty and stock). |
| **Immutability Pattern** | `cartkit/cart.py:12` — `new_cart = dict(cart)` | Shallow copy enforces input immutability; confirmed in tests at `tests/test_cart.py:13-16`. |
| **Input Validation Order** | `cartkit/cart.py:9` — `isinstance(qty, int)` and `isinstance(qty, bool)` checked before stock logic | Qty validation before state mutation; explicit bool rejection (bool is int subclass in Python). |

---

## Public Surface: `add_to_cart` Contract

```python
def add_to_cart(cart, item_id, qty, stock):
    """Add `qty` units of `item_id` to `cart`, returning a new cart.

    See SPEC.md for the full rules.
    """
```

**Signature location:** `cartkit/cart.py:4`

**Contract (from SPEC.md:3–14):**
- **R1 — Positive quantity:** `qty` must be a positive integer; rejects 0, negative, non-integer, bool with `ValueError`.
- **R2 — Respect available stock:** resulting quantity must not exceed `stock`; rejects over-stock with `ValueError` (all-or-nothing, no partial add).
- **R3 — Accumulate existing items:** if `item_id` is in `cart`, increment by `qty`; otherwise insert with value `qty`.
- **R4 — No mutation:** input `cart` is never modified; returns a fresh dict with the new state.

**Return value:** dict (new cart state).

**Raises:** `ValueError` (two paths: qty validation failure at line 10, or stock check at line 15).

---

## Complexity & Risk Notes

1. **Boolean type confusion (low risk, well-handled):**
   - Line 9: `isinstance(qty, bool)` check is necessary because in Python `bool` is a subclass of `int`, so `isinstance(True, int)` is True.
   - Implementation correctly rejects this before stock logic. Test coverage at `tests/test_cart.py:52–55` confirms.

2. **Stock check logic (straightforward):**
   - Line 13–14: `new_total = new_cart.get(item_id, 0) + qty` followed by `if new_total > stock`.
   - Boundary case tested: `new_total == stock` is allowed (test at `tests/test_cart.py:31–33`).
   - Risk: low — logic is simple and boundary is explicitly tested.

3. **Immutability via shallow copy:**
   - Line 12: `new_cart = dict(cart)` creates a shallow copy.
   - Sufficient for this use case (values are integers, not nested objects).
   - Risk: very low (shallow copy is idiomatic Python; no nested mutation in practice).

4. **No explicit validation of `item_id` or `stock` types:**
   - `item_id` is assumed hashable (dict key); `stock` is assumed numeric.
   - Could raise TypeError or fail silently if violated (e.g., `stock="abc"`).
   - Risk: low in controlled environments; spec does not mandate validation, so this is by design.

---

## Source Fingerprint

**Current HEAD commit:** `d68e32a1d07204e9aec11e6685d0cb0d512ed292`

**Working tree status (git status --short):**
```
 M cartkit/cart.py
 M tests/test_cart.py
?? cartkit/__pycache__/
?? tests/__pycache__/
```

**Note:** Branch `sdd/001-enforce-stock-limit` is checked out; `cartkit/cart.py` and `tests/test_cart.py` have uncommitted modifications. `__pycache__` directories are untracked (not committed).

---

## Summary

**cartkit** is a 1-function shopping-cart library enforcing qty validation, stock limits, and immutability. **Conventions:** unittest framework (test_cart.py:6), snake_case naming (cart.py:4), ValueError for all errors (cart.py:10,15), shallow-copy immutability (cart.py:12), and bool-rejection before stock logic (cart.py:9). **Public API:** `add_to_cart(cart, item_id, qty, stock) → dict` per SPEC.md R1–R4. **Risk:** minimal — logic is simple, boundary-tested, immutability is correct. **Fingerprint:** HEAD `d68e32a1d07204e9aec11e6685d0cb0d512ed292`; working tree has M-flags on cart.py and test_cart.py.
