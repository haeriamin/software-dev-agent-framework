# Slice 001 — Enforce add_to_cart input rules

**Target**: cartkit (X:/Work/cartkit)
**Complexity**: LOW
**Source**: cartkit/SPEC.md (product spec)

## Problem

`add_to_cart` currently accepts a quantity that pushes an item's total above the
available `stock`, allowing oversell. The happy-path tests pass and the function looks
finished, but the stock rule from the product spec is not enforced.

## Functional Requirements (enumerated)

- **FR1 — Reject non-positive / non-integer qty.** `qty` ≤ 0, non-int, or boolean →
  raise `ValueError`. *(already enforced; covered for regression)*
- **FR2 — Reject over-stock adds.** If the item's resulting total quantity would exceed
  `stock`, raise `ValueError` and do not add. *(the gap this slice closes)*
- **FR3 — Accumulate existing items.** Adding an item already in the cart increases its
  quantity by `qty`, with the running total still subject to FR2.
- **FR4 — No mutation.** The input `cart` is never modified; a new cart is returned.

## Success Criteria

- SC1: `add_to_cart({}, "x", 5, stock=3)` raises `ValueError` (FR2, fresh item).
- SC2: `add_to_cart({"x": 2}, "x", 2, stock=3)` raises `ValueError` (FR2, accumulation pushes total to 4 > 3).
- SC3: `add_to_cart({"x": 2}, "x", 1, stock=3)` returns `{"x": 3}` (FR2 boundary: total == stock is allowed).
- SC4: existing happy-path and FR1/FR4 behavior unchanged (regression).

## Out of Scope

- Removing items, persistence, concurrency, multi-item batch adds.
