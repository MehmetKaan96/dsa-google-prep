// MARK: - Problem
// LeetCode #217 — Contains Duplicate
// https://leetcode.com/problems/contains-duplicate/
// Difficulty: Easy
// Topics: Array, HashSet
// Date solved: 2026-04-25
// Solve time: ~25m (Solo Sprint, Format C, with 2 self-corrected bugs)
//
// MARK: - Approach
// 1. Brute force:    O(n²) time, O(1) space
//    → Nested loop comparing every pair. Rejected at scale.
// 2. Sort + scan:    O(n log n) time, O(1) space (in-place)
//    → After sort, duplicates are adjacent. Trade time for space.
// 3. Hash Set (opt): O(n) time, O(n) space
//    → For each num, check if seen before. Early exit on first duplicate.
//
// MARK: - Why Set, not Dictionary?
// Only need "have I seen this value?" — no associated data (like an index).
// Set<Int> is the right type. Dictionary [Int: Void] is wrong (Void isn't Hashable
// in the value position, and it's not idiomatic).
//
// MARK: - Edge Cases
// - Single element [1] → false (no duplicate possible)
// - All same [1,1,1] → true (immediate match on i=1)
// - Negatives + zero [-1, 0, 1, -1] → true
// - Large input (10⁵ elements) → still O(n)

import Foundation

class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        var seen: Set<Int> = []

        for num in nums {
            if seen.contains(num) { return true }
            seen.insert(num)
        }

        return false
    }
}

// MARK: - Tests
let s = Solution()

assert(s.containsDuplicate([1, 2, 3, 1]) == true,
       "Basic duplicate failed")

assert(s.containsDuplicate([1, 2, 3, 4]) == false,
       "All unique failed")

assert(s.containsDuplicate([1]) == false,
       "Single element failed")

assert(s.containsDuplicate([1, 1, 1, 3, 3, 4, 3, 2, 4, 2]) == true,
       "Multiple duplicates failed")

assert(s.containsDuplicate([-1, 0, 1, -1]) == true,
       "Negatives + zero failed")

print("✅ All tests passed")
