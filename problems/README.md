# Problems

LeetCode çözümleri, primary data structure / pattern'e göre organize.

## Naming Convention

`{leetcode-number}-{kebab-case-name}.swift`

Örnek: `0001-two-sum.swift`, `0049-group-anagrams.swift`

## Solution File Template

Her solution dosyası şunları içermeli:

```swift
// MARK: - Problem
// LeetCode #XXX — Problem Title
// https://leetcode.com/problems/problem-slug/
// Difficulty: Easy | Medium | Hard
// Topics: Array, HashMap, ...
// Date solved: YYYY-MM-DD
// Solve time: Xm (first attempt) / Ym (clean)
//
// MARK: - Approach
// 1. Brute force: O(?) time, O(?) space — neden reject
// 2. Optimal:     O(?) time, O(?) space — anahtar insight
//
// MARK: - Edge Cases
// - empty input
// - duplicates
// - ...

import Foundation

class Solution {
    func functionName(...) -> ... {
        // implementation
    }
}

// MARK: - Tests
let s = Solution()
assert(s.functionName(...) == expected)
print("✅ All tests passed")
```

## Folder Index

| Folder | Topics | Primary DS |
|--------|--------|------------|
| `arrays/` | Two pointers, sliding window, prefix sum | Array |
| `hashmap/` | Frequency, lookup, dedup | Dictionary, Set |
| `strings/` | Palindrome, pattern matching | String, Array |
| `linked-list/` | Reversal, cycle detection, merging | LinkedList |
| `trees/` | Traversal, BST, path problems | Tree |
| `graphs/` | BFS, DFS, topological sort | Graph |
| `dp/` | Memoization, tabulation | various |

## Çözülen Problemler

| # | Problem | Zorluk | Pattern | Dosya |
|---|---------|--------|---------|-------|
| 0001 | Two Sum | Easy | Hash single-pass | [hashmap/0001](hashmap/0001-two-sum.md) |
| 0049 | Group Anagrams | Medium | Hash grouping | [hashmap/0049](hashmap/0049-group-anagrams.md) |
| 0217 | Contains Duplicate | Easy | Set membership | [hashmap/0217](hashmap/0217-contains-duplicate.md) |
| 0242 | Valid Anagram | Easy | Char-count map | [hashmap/0242](hashmap/0242-valid-anagram.md) |
| 0283 | Move Zeroes | Easy | In-place write-pointer | [arrays/0283](arrays/0283-move-zeroes.md) |
| 0128 | Longest Consecutive Sequence | Medium | Set O(1) membership + start detection | [hashmap/0128](hashmap/0128-longest-consecutive-sequence.md) |
| 0167 | Two Sum II (Sorted) | Medium | Converging two pointers | [arrays/0167](arrays/0167-two-sum-ii-sorted.md) |
| 0125 | Valid Palindrome | Easy | Two pointers + skip; String mekaniği | [strings/0125](strings/0125-valid-palindrome.md) |
