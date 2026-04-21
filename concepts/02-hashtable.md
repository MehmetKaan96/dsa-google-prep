# HashTable (Dictionary / Set)

> **Full deep-dive:** `DSA.playground/Pages/02-HashTable.xcplaygroundpage/Contents.swift`
> This file is a quick-reference summary.

## TL;DR

Hash table = array (of buckets) + hash function. Key is mapped to bucket index via
`hash(key) % capacity`. Average O(1) operations, but worst case O(n) under collisions.

## Key Invariants

- Hashable contract: `a == b ⇒ a.hashValue == b.hashValue` (converse NOT required)
- Deterministic per instance (randomized seed per process for HashDoS resistance)
- Load factor α = count / capacity — typically rehash at α ≈ 0.75
- No duplicate keys

## Big O

| Operation | Average | Worst |
|-----------|---------|-------|
| `dict[key]` lookup | O(1) | O(n) |
| `dict[key] = v` insert | O(1) amortized | O(n) rehash |
| `removeValue(forKey:)` | O(1) | O(n) |
| `contains` | O(1) | O(n) |
| iteration | O(n + capacity) | |
| CoW copy (first mutation) | O(n) | |

## Swift-specific

- `Dictionary` uses **open addressing** + SipHash with randomized seed
- `Set<T>` is essentially `Dictionary<T, Void>`
- Value type with CoW on heap `ManagedBuffer`
- Iteration order undefined and may differ across runs
- Hash values NOT persistable (seed changes per process launch)
- Auto-synthesize: if all stored properties are `Hashable`, compiler writes `hash(into:)` for you

## Collision Resolution

| Strategy | Description | Pros/Cons |
|----------|-------------|-----------|
| Separate chaining | Each bucket holds a list | Simple delete; pointer chasing hurts cache |
| Linear probing | Next slot on collision | Cache-friendly; primary clustering |
| Quadratic probing | `i*i` offset | Reduces clustering; secondary clustering remains |
| Double hashing | Second hash for step | Best distribution; most complex |

## Decision Engine

✅ Use when:
- Key-based lookup
- Frequency counting
- Caching / memoization
- Deduplication (Set)
- Graph adjacency

❌ Avoid when:
- Ordered iteration needed
- Range queries
- Positional access
- Hard real-time (worst O(n) unacceptable)
- Very small N (<10) — linear scan often faster

## Senior Signals / Must-Drop Terms

- Load factor (α)
- Collision resolution (chaining / linear / quadratic / double hashing)
- Primary & secondary clustering
- Tombstone deletion
- Rehashing / resize storm
- HashDoS / algorithmic complexity attack
- SipHash / randomized hashing
- Hashable contract / hash-equals invariant
- Open addressing vs separate chaining

## Common Interview Problems

- [ ] Two Sum (Easy)
- [ ] Valid Anagram (Easy)
- [ ] Contains Duplicate (Easy)
- [ ] Group Anagrams (Medium)
- [ ] Top K Frequent Elements (Medium)
- [ ] Longest Consecutive Sequence (Medium)
- [ ] Subarray Sum Equals K (Medium)
- [ ] LRU Cache (Medium) — hash + doubly linked list
- [ ] LFU Cache (Hard)
