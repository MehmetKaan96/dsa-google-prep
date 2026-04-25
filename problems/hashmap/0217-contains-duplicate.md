# LeetCode #217 — Contains Duplicate

> **Difficulty:** Easy · **Topics:** Array, HashSet · **Pattern:** Single-pass hash lookup
> **Blind 75 / NeetCode 150:** ✅ Core problem
> **Solved:** 2026-04-25 (Format C — Solo Sprint, 30 min)

---

## 1. Problem Statement

Given an integer array `nums`, return `true` if any value appears **at least twice** in the array, return `false` if every element is **distinct**.

**Examples:**
```
nums = [1, 2, 3, 1]                    → true
nums = [1, 2, 3, 4]                    → false
nums = [1, 1, 1, 3, 3, 4, 3, 2, 4, 2]  → true
```

**Constraints:**
| Constraint | Value |
|-----------|-------|
| Array length | 1 ≤ nums.length ≤ 10⁵ |
| Value range | -10⁹ ≤ nums[i] ≤ 10⁹ |

---

## 2. Clarifying Questions — Calibration

For an Easy problem with clear constraints, **2-3 questions** is the right amount. Asking 5+ on an easy problem is anti-signal.

**Priority 1 — Asked**
- Is the array sorted? → No (random order). *Important: would change optimal approach.*

**Priority 2 — Constraint-readable (could skip)**
- Empty array? → No, constraint says ≥ 1.
- Negatives / zero? → Yes (range includes negative).

**Priority 3 — Optional**
- Can I modify the original? → Relevant for sort-based approach.
- Memory budget? → Relevant for choosing hash vs sort.

### Senior move
Skip questions whose answers are in the constraints. Saves time, signals "I read the problem carefully."

---

## 3. Approach Evolution

### Approach 1 — Brute Force (Nested Loops)

For every `i`, check every `j > i` for `nums[i] == nums[j]`.

- **Time:**  O(n²)
- **Space:** O(1)
- **Why reject:** At n=10⁵, O(n²) = 10¹⁰ ops. Dies.

### Approach 2 — Sort + Adjacent Check

Sort the array. If any duplicates exist, they will be adjacent. Single pass to compare neighbors.

- **Time:**  O(n log n) — sort dominates
- **Space:** O(1) if in-place sort, O(n) for tuple-preserving variants
- **Why reject:** Strictly worse than Hash Set. Only attractive if O(1) space is mandated.

### Approach 3 — Hash Set Single-Pass (OPTIMAL)

For each `num`, check if it's already in a set. If yes → duplicate. If no → insert and continue.

```swift
var seen: Set<Int> = []
for num in nums {
    if seen.contains(num) { return true }
    seen.insert(num)
}
return false
```

- **Time:**  O(n)
- **Space:** O(n) — set can grow to n entries

---

## 4. Set vs Dictionary — Why Set Here

Two Sum used `Dictionary [value: index]` because we needed to **return the index** of the matched complement.

Contains Duplicate only needs a **boolean answer**. No associated data per element. So `Set<Int>` is the right type.

| Need | Use |
|------|-----|
| "Have I seen X? Yes/No." | `Set<T>` |
| "Have I seen X? If so, what was its index/count/data?" | `Dictionary<T, Data>` |

**Common mistake:** Reaching for `[Int: Void]`. Don't. `Set` is purpose-built and cleaner.

---

## 5. Complexity Analysis

| Metric | Value | Notes |
|--------|-------|-------|
| Time (avg) | O(n) | Single pass × O(1) avg set ops |
| Time (worst) | O(n²) | Theoretical — hash collisions |
| Space | O(n) | Worst: all unique → set grows to n |

Same Swift Dictionary/Set guarantees apply: **randomized hash seed** makes the practical case O(n) safe.

---

## 6. Trace Walkthroughs

### Trace 1 — Duplicate at end
```
nums = [1, 2, 3, 1]

num=1: seen={}        contains? no → insert {1}
num=2: seen={1}       contains? no → insert {1,2}
num=3: seen={1,2}     contains? no → insert {1,2,3}
num=1: seen={1,2,3}   contains? YES → return true
```

### Trace 2 — All unique
```
nums = [1, 2, 3, 4]

(Each num inserted, never seen.)
After loop: return false
```

### Trace 3 — Single element
```
nums = [1]

num=1: seen={} contains? no → insert {1}
After loop: return false
```

---

## 7. Edge Cases Checklist

| Case | Expected | Notes |
|------|----------|-------|
| Single element | `false` | Loop runs once, no duplicate found |
| Two same elements | `true` | Immediate detection at i=1 |
| All unique | `false` | Loop completes, return at end |
| Many duplicates | `true` | Returns on first collision (early exit) |
| Negatives / zero | Works | `Set<Int>` handles full Int range |
| Max size (10⁵) | O(n), fine | No issue |

---

## 8. Common Mistakes — Personal Record

Captured live from today's session.

### Mistake 1 — Inverted Guard Logic

Initial code:
```swift
guard nums.count == 1 else { return false }
```

This says *"continue only if count == 1; otherwise return false."* So for any input with 2+ elements, we'd return `false` immediately without entering the loop. **Catastrophic.**

**Fix:**
```swift
guard nums.count != 1 else { return false }
// Or simpler: just delete the guard — the loop handles count==1 correctly.
```

**Rule:** Read every `guard` aloud as *"continue only if X; otherwise do Y."* If the "otherwise" branch is what you actually want for the early-exit, the condition needs negation.

### Mistake 2 — Inverted Return Values

Initial code returned `false` when a duplicate was found and `true` at the end.

**Rule:** Map your return values to **English semantics** before coding. *"Found a duplicate? → return true (yes, contains duplicate)."* Don't write the boolean first; write the meaning first, then the boolean follows.

### Mistake 3 — Calling Set a Dictionary

Said *"Set[Int: Void]"* in verbal. Swift's `Set<Int>` is its own first-class type, not a Dictionary with Void values.

**Rule:** Set and Dictionary share underlying mechanics (hash table) but are distinct types in Swift. When the problem only needs membership testing, name `Set` explicitly — both for correctness and signal.

### Mistake 4 — Defensive Guard That Adds Nothing

Even after fixing the guard logic, the guard for `count == 1` was redundant. The main loop handles single-element arrays correctly: it iterates once, doesn't insert anything that matches, and returns `false` at the end.

**Rule:** Defensive code is good only when it changes behavior or readability. A guard that early-exits to the same result the loop produces is just noise.

---

## 9. Reusable Pattern Reference

This problem is a **direct application** of the hash-map single-pass pattern documented in [`0001-two-sum.md`](./0001-two-sum.md).

The skeleton:

```swift
var seen: Set<Element> = []   // Or [Element: Data] if data needed
for item in collection {
    if seen.contains(item) {
        return /* match-found result */
    }
    seen.insert(item)
}
return /* no-match result */
```

**Mental model:** *"Have I seen this exact thing before? → Set."*

### Direct Cousins (Same Pattern Family)

| Problem | Twist |
|---------|-------|
| #1 Two Sum | Need complement, return indices |
| #217 Contains Duplicate (this) | Just a yes/no |
| #219 Contains Duplicate II | Within distance k — store index |
| #220 Contains Duplicate III | Within distance k AND value range t — bucket / sliding window |
| #242 Valid Anagram | Frequency counts |
| #49 Group Anagrams | Group by canonical key |

---

## 10. Follow-up Questions an Interviewer May Ask

### FU-1: "What if you can't use extra space?"
Sort + adjacent comparison. O(n log n) time, O(1) space (with in-place sort). Mention the trade-off.

### FU-2: "What if duplicates only count if they're within k indices apart?"
This is **LeetCode #219**. Store `[value: lastSeenIndex]` and compare `currentIndex - lastSeenIndex <= k`.

### FU-3: "What if the array is very large and doesn't fit in memory?"
External sorting + adjacent check. Or probabilistic: Bloom filter for first pass (false positives possible, no false negatives), exact verification on the small candidate set.

### FU-4: "What if we need to count occurrences, not just detect any duplicate?"
Switch from `Set<Int>` to `[Int: Int]` (frequency map). Returns counts in a single pass.

### FU-5: "How would you parallelize this?"
Map-reduce: partition the array, build per-shard sets, merge. Memory blow-up on full set.
A more practical approach: sort externally, then sequential adjacent scan.

### FU-6: "Test cases you'd write?"
- Empty (constraint says no, but test the function defensively): handles or rejects?
- Single element: `false`
- Two elements: same/different
- All same value
- All unique
- Match at start, end, middle
- Max size (perf, not correctness)
- Negatives, zero, max/min Int

---

## 11. Mock Session Debrief

### What Went Well
- Brute force + complexity correctly stated upfront.
- Trace narration on `[1, 2, 3, 1]` — improvement over Two Sum.
- Recognized Set as the right structure (vs Dictionary).
- Self-corrected both bugs (guard, return values) after a probe.

### Needs Work
- **Set vs Dictionary terminology**: said `Set[Int: Void]`. Conflated structures. Memorize: *"Set is a first-class type in Swift, distinct from Dictionary."*
- **Boolean inversion**: returned the wrong values until probed. Map English meaning to booleans before typing.
- **Guard logic inversion**: read your `guard` aloud before committing.
- **Active recall (warm-up)**: said *"hatırlıyorum"* without verbalizing answer. In interviews, "remembering" without articulation = not knowing.

### One Rule to Internalize
**"Return values mirror English semantics. Write the meaning, then the boolean."**
*"Did I find a duplicate? Yes → return true."* Don't start with the keyword.

---

## 12. Re-solve Protocol

1. **+1 day:** 30-min passive review of this MD.
2. **+2 days:** Solve from scratch, no notes, target ≤ 5 min (it's an Easy).
3. **+7 days:** Recall question — *"Set vs Dictionary, when?"*
4. **+14 days:** Re-solve.
5. **+1 month:** Spaced repetition final.

---

## References

- [LeetCode #217](https://leetcode.com/problems/contains-duplicate/)
- Pattern doc: [`0001-two-sum.md`](./0001-two-sum.md)
- Swift `Set` — [Apple Docs](https://developer.apple.com/documentation/swift/set)
- Related: `0001-two-sum`, `0049-group-anagrams` (next), `0242-valid-anagram` (next)
