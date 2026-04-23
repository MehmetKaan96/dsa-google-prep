# LeetCode #1 — Two Sum

> **Difficulty:** Easy · **Topics:** Array, HashMap · **Pattern:** Single-pass hash lookup
> **Blind 75 / NeetCode 150:** ✅ Core problem
> **Solved:** 2026-04-23 (Format B — guided solve)

---

## 1. Problem Statement

Given an integer array `nums` and an integer `target`, return **indices** of the two numbers such that they add up to `target`.

**Assumptions (from problem):**
- Exactly one valid answer per input.
- Cannot use the same element twice.
- Return indices in any order.

**Example:**
```
Input:  nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
```

**Constraints to confirm in interview:**
| Constraint | Answer | Impact |
|-----------|--------|--------|
| Sorted? | No | Rules out pure two-pointer |
| Negatives allowed? | Yes | Doesn't affect approach |
| Duplicates? | Yes | Must use lookup-before-insert |
| Array size? | 2 to 10⁴ | O(n²) too slow for upper end |
| Guaranteed solution? | Yes | No "return -1 / nil" case |

---

## 2. Clarifying Questions — The Right Set

The goal is **3-4 high-signal questions**, not 10.

**Priority 1 — Input structure** (changes the algorithm entirely)
- Is the array sorted?
- Can values be negative / zero?
- Can values be duplicated?
- What's the array size range?

**Priority 2 — Output specification**
- Return indices or values?
- Is there always a solution, or do I need to handle "not found"?
- Multiple valid solutions — all, any, specific?

**Priority 3 — Environment / edge cases**
- Can I modify the original array?
- Can empty or single-element arrays be input?

### Closing the clarification phase

> *"Bu kadar yeterli sanırım — eğer kritik bir nüans varsa çözerken fark edersem sorarım. Yaklaşımıma geçebilir miyim?"*

This signals **time management + openness** — a staff-engineer move.

---

## 3. Approach Evolution

Always walk through **at least two** approaches. Naming a brute force first shows you think in trade-offs.

### Approach 1 — Brute Force (Nested Loops)

For every `i`, try every `j > i` and check if `nums[i] + nums[j] == target`.

```
for i in 0..<nums.count {
    for j in (i+1)..<nums.count {
        if nums[i] + nums[j] == target { return [i, j] }
    }
}
```

- **Time:**  O(n²) — Gauss sum: `(n-1) + (n-2) + ... + 1 = n(n-1)/2`
- **Space:** O(1)
- **Why reject:** At n=10⁷, O(n²) = 10¹⁴ ops → dead.

### Approach 2 — Sort + Two Pointers

Sort the array, then use `low` and `high` pointers moving toward each other.

**Critical catch:** Two pointers requires a **sorted** array — a pre-condition. If we sort, we **lose original indices**. Solution: pair each `(value, originalIndex)` as tuples, sort by value, then two-pointer returning original indices.

- **Time:**  O(n log n) — sort dominates
- **Space:** O(n) for the tuple array
- **Why reject:** Strictly worse than hash map on both axes. Only attractive if O(1) space is a hard requirement (it isn't here).

### Approach 3 — Hash Map Single-Pass (OPTIMAL)

**Key insight — Complement:**
> For each element `num`, the question becomes: *"Have I seen `target - num` before?"*
> If yes → pair found. If no → record `num` for future queries.

**Dictionary structure:** `[value: originalIndex]`
- Key = value you've seen
- Value = its index

**Algorithm (7 lines):**

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (index, num) in nums.enumerated() {
        let complement = target - num
        if let storedIndex = seen[complement] {
            return [storedIndex, index]
        }
        seen[num] = index
    }
    return []
}
```

- **Time:**  O(n) — one pass, average O(1) dict ops
- **Space:** O(n) — dict can grow to n entries in worst case

### Why LOOKUP BEFORE INSERT Matters

Three subtle properties of this ordering, **all free**:

1. **Same-index protection.** At iteration `i`, `nums[i]` hasn't been inserted yet, so you can never pair it with itself.
2. **Duplicate handling.** `[3, 3], target=6`: at i=1 we find `3` in dict from i=0 → return `[0, 1]`. If we had pre-built the full dict, `{3: 1}` would have overwritten `{3: 0}`.
3. **Early exit.** Return the moment a pair is found — no second pass needed.

---

## 4. Complexity Analysis

| Metric | Value | Notes |
|--------|-------|-------|
| Time (avg) | O(n) | Single pass × O(1) avg dict ops |
| Time (worst) | O(n²) | Theoretical — hash collisions |
| Space | O(n) | Worst: pair lies in last 2 elements → dict size n-1 |

### Why Swift `Dictionary` is Practically O(1)

Swift's `Dictionary` uses **per-process randomized hash seeds** (Swift 4.2+). This is HashDoS protection — an adversary cannot craft inputs that force all keys into one bucket, because the hash function varies per process run.

**Interview-ready sentence:**
> *"Total time is O(n) — Swift Dictionary gives average O(1) lookup. Worst case is theoretically O(n²) due to hash collisions, but Swift uses randomized hashing, so practically it's always O(n)."*

---

## 5. Trace Walkthroughs

Always narrate at least one trace verbally in the interview.

### Trace 1 — Basic

```
nums = [2, 7, 11, 15], target = 9

i=0: num=2,  comp=7.  seen={}              → insert {2: 0}
i=1: num=7,  comp=2.  seen={2:0}   2 ✓    → return [0, 1]
```

### Trace 2 — Duplicates

```
nums = [3, 3], target = 6

i=0: num=3,  comp=3.  seen={}              → insert {3: 0}
i=1: num=3,  comp=3.  seen={3:0}   3 ✓    → return [0, 1]
```

### Trace 3 — Match at End

```
nums = [3, 2, 4], target = 6

i=0: num=3,  comp=3.  seen={}              → insert {3: 0}
i=1: num=2,  comp=4.  seen={3:0}   4 ✗    → insert {3:0, 2:1}
i=2: num=4,  comp=2.  seen={3:0,2:1} 2 ✓ → return [1, 2]
```

### Trace 4 — Negatives

```
nums = [-1, -2, -3, -4, -5], target = -8

i=0: num=-1, comp=-7. ✗ → insert {-1:0}
i=1: num=-2, comp=-6. ✗ → insert {-1:0, -2:1}
i=2: num=-3, comp=-5. ✗ → insert {..., -3:2}
i=3: num=-4, comp=-4. ✗ → insert {..., -4:3}
i=4: num=-5, comp=-3. seen[-3]=2 ✓ → return [2, 4]
```

---

## 6. Edge Cases Checklist

| Case | Expected | Covered By |
|------|----------|-----------|
| Minimum size (n=2) | Returns pair | `[3, 3], 6` |
| Duplicates | Works | `[3, 3], 6` |
| Match at start | Works | `[2, 7, ...], 9` |
| Match at end | Works | `[3, 2, 4], 6` |
| Negatives | Works | `[-1, -2, ...], -8` |
| Target = 0 with zero value | Works | `[0, 4, 3, 0], 0` → `[0, 3]` |
| No solution | Returns `[]` (defensive) | Problem guarantees solution |

---

## 7. Common Mistakes — Personal Record

Captured live from today's session. Review before next hash-map problem.

### Mistake 1 — Calling O(n²) "Two Pointer"

I proposed "two pointer" on an **unsorted** array by moving `high` down then resetting with `low++`. This is not two-pointer — it's nested iteration in disguise, still O(n²).

**Rule:** True two-pointer requires **sorted** input (or monotonic property). If the array isn't sorted, naming something "two pointer" is a category error.

### Mistake 2 — Skipping the Verbal Trace

On first verbal approach, I didn't walk through a concrete example. Abstract explanations lose interviewers.

**Rule:** Every verbal approach includes at least one trace on an example (`[2, 7, 11, 15], target = 9`). 30 seconds of trace buys enormous clarity signal.

### Mistake 3 — Variable Naming (`storedNumber` vs `storedIndex`)

Named the value retrieved from `dict[complement]` as `storedNumber`. But the dict is `[value: index]`, so the retrieved value is an **index**, not a number. This caused a return bug: `return [complement, index]` instead of `return [storedIndex, index]`.

**Rule:** Variable name must describe **what the variable holds**, not the surrounding concept. If the dict stores indices, the extracted value is `storedIndex`.

### Mistake 4 — Space Complexity Uncertainty

Said "space is O(1) or O(n), not sure." Big O is always worst-case (upper bound). Even if lucky-case is O(1), the answer is O(n).

**Rule:** Big O = worst case. Always state the worst case; mention best case only if explicitly asked.

### Mistake 5 — `dict[num] = 0` Typo

Briefly wrote a constant `0` instead of the current `index`. Caught via probe.

**Rule:** Before any dict insert, ask: *"What do I want to retrieve later?"* That's what goes in as the value.

---

## 8. Reusable Pattern — Hash Map Single-Pass

### When to Apply

- **"Find a pair / complement / counterpart"** problems
- **"Have I seen this before?"** queries
- **O(n) target with O(n) space budget**

### Pattern Skeleton

```swift
var seen: [Key: Value] = [:]
for (index, element) in collection.enumerated() {
    let needed = /* what would complete the answer? */
    if let matchedIndex = seen[needed] {
        return /* use matchedIndex + current index */
    }
    seen[element] = index
}
```

### Related Problems That Fit This Skeleton

| Problem | Needed | Dict Holds |
|---------|--------|-----------|
| Two Sum (this) | `target - num` | `[value: index]` |
| Contains Duplicate | `num` itself | `Set<value>` |
| Valid Anagram | character counts | `[Character: Int]` |
| Subarray Sum Equals K | `prefixSum - k` | `[prefixSum: count]` |
| First Unique Character | character counts | `[Character: Int]` |
| Group Anagrams | sorted key | `[String: [String]]` |

**Mental model:** *"Am I looking backward to find a match? → Single-pass hash map."*

---

## 9. Follow-up Questions an Interviewer May Ask

Be ready — these commonly follow Two Sum in a real interview.

### FU-1: "What if the array is sorted?"
Switch to two-pointer, O(n) time, O(1) space. Be ready to code it.

### FU-2: "What if there can be multiple pairs? Return all."
Can't early-exit. Must scan the whole array. `seen[num]` becomes `[Int: [Int]]` to track all indices of each value.

### FU-3: "What if you need three numbers (3Sum)?"
Sort + fix one element + two-pointer on the rest → O(n²). This is the canonical pattern for k-Sum family.

### FU-4: "What if the numbers don't fit in Int (overflow)?"
Use `Int.addingReportingOverflow` or pre-check `target - num` against `Int.min` / `Int.max`. In production, prefer `BigInt` library if values can exceed 64 bits.

### FU-5: "What if memory is very tight?"
Sort + two-pointer, O(n log n) time, O(1) space (if in-place sort and index preservation isn't needed — or O(n) extra for tuples if needed). Trade time for space.

### FU-6: "Would you unit test this? What cases?"
See `Edge Cases Checklist` above. Emphasize:
- Duplicates (`[3, 3], 6`)
- Negatives and zero
- Minimum size (n=2)
- Match at boundaries (start, end)

### FU-7: "What could go wrong in production?"
- Non-hashable keys (custom types without `Hashable`)
- Hash collision DoS (mitigated by Swift's randomized seed)
- Very large inputs → memory pressure (O(n) space)

---

## 10. Mock Session Debrief

### What Went Well
- Asked 3 Priority-1 clarifying questions (sorted, negatives, duplicates).
- Scale sensitivity: noted O(n²) problem at n=10⁷ — staff-level signal.
- Gauss sum derivation for brute-force complexity.
- Discovered the complement insight (with a nudge).
- Recognized the critical duplicate-handling subtlety (lookup before insert).
- Self-corrected two bugs via targeted probes.

### Needs Work
- **Two-pointer category error** — proposed it on unsorted array. Unforced.
- **No verbal trace** in first approach narration.
- **Weak naming refactor reflex** — shipped `storedNumber` and `j` without pushback.
- **Space complexity waffling** — "O(1) or O(n)" instead of firm "O(n) worst case".
- **Didn't know** Dictionary worst case = O(n) due to collisions.

### One Rule to Internalize
**"Verbal before code, trace before verbal."** Narrate a concrete example as part of your approach. It's the cheapest clarity signal in interviews.

---

## 11. Re-solve Protocol

To lock this in:

1. **+1 day (Fri 24/04):** 30-min passive review of this MD.
2. **+2 days (Sat 25/04):** Solve from scratch, no notes, target ≤ 10 min.
3. **+7 days (Thu 30/04):** Warm-up recall question: *"Hash-map single-pass pattern, when?"*
4. **+14 days:** Re-solve again, target ≤ 7 min.
5. **+1 month:** Spaced repetition final check.

---

## References

- [LeetCode #1 — Two Sum](https://leetcode.com/problems/two-sum/)
- Blind 75 — Array & Hashing group
- NeetCode 150 — [Two Sum walkthrough](https://neetcode.io/problems/two-integer-sum)
- Swift stdlib: `Dictionary` subscript returns `Optional<Value>`
- Related: `0049-group-anagrams`, `0217-contains-duplicate`, `0560-subarray-sum-equals-k` (future)
