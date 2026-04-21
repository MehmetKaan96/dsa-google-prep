# Array

> **Full deep-dive:** `DSA.playground/Pages/01-Array.xcplaygroundpage/Contents.swift`
> This file is a quick-reference summary. The playground has runnable examples.

## TL;DR

Array = contiguous memory block. O(1) random access via base-plus-offset arithmetic.
Swift `Array` is a value type with Copy-on-Write on a reference-counted heap buffer.

## Key Invariants

- Contiguity — all elements in one memory block
- Homogeneity — same type, same stride
- Bounds — `index ∈ [0, count)`, Swift traps on violation
- Capacity ≥ count — allocated ≥ used

## Big O

| Operation | Average | Worst |
|-----------|---------|-------|
| `arr[i]` | O(1) | O(1) |
| `append` | O(1) amortized | O(n) realloc |
| `insert(at:)` | O(n) | O(n) |
| `remove(at:)` | O(n) | O(n) |
| `contains` | O(n) | O(n) |
| Binary search (sorted) | O(log n) | O(log n) |
| `sort()` | O(n log n) | O(n log n) |
| CoW copy | O(1) | O(n) first mutation |

## Swift-specific

- `Array<T>` supports Obj-C bridging; `ContiguousArray<T>` doesn't (~2x faster iteration)
- `ArraySlice` retains entire parent buffer — hidden memory leak if long-lived
- CoW triggers on **mutation** when `isKnownUniquelyReferenced == false`, NOT on assignment
- Geometric growth (~2x) gives amortized O(1) append; `reserveCapacity` avoids resize storms

## Decision Engine

✅ Use when:
- Read-heavy + random access
- Known/bounded size
- Cache-sensitive hot path
- Iteration-dominated algorithms

❌ Avoid when:
- Frequent mid-insert/delete
- Need O(1) key lookup → use `Dictionary`
- FIFO/LIFO with growth from both ends → use `Deque`

## Senior Signals / Must-Drop Terms

- Amortized analysis (banker's / potential method)
- Spatial / temporal locality
- Cache line, prefetching
- Stride vs size vs alignment
- Geometric growth factor
- Copy-on-Write, `isKnownUniquelyReferenced`
- Pointer chasing (LinkedList contrast)

## Common Interview Problems

- [ ] Two Sum (Easy)
- [ ] Contains Duplicate (Easy)
- [ ] Best Time to Buy and Sell Stock (Easy)
- [ ] Product of Array Except Self (Medium)
- [ ] Maximum Subarray / Kadane's (Medium)
- [ ] Rotate Array (Medium)
- [ ] 3Sum (Medium)
- [ ] Container With Most Water (Medium)
- [ ] Trapping Rain Water (Hard)
