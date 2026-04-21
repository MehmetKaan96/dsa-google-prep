# Problems

LeetCode solutions organized by primary data structure / pattern.

## Naming Convention

`{leetcode-number}-{kebab-case-name}.swift`

Example: `0001-two-sum.swift`, `0049-group-anagrams.swift`

## Solution File Template

Every solution file should include:

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
// 1. Brute force: O(?) time, O(?) space — why rejected
// 2. Optimal:     O(?) time, O(?) space — key insight
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
|--------|--------|-----------|
| `arrays/` | Two pointers, sliding window, prefix sum | Array |
| `hashmap/` | Frequency, lookup, dedup | Dictionary, Set |
| `strings/` | Palindromes, pattern matching | String, Array |
| `linked-list/` | Reversal, cycle detection, merging | LinkedList |
| `trees/` | Traversal, BST, path problems | Tree |
| `graphs/` | BFS, DFS, topological sort | Graph |
| `dp/` | Memoization, tabulation | various |
