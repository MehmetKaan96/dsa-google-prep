// MARK: - Problem
// LeetCode #1 — Two Sum
// https://leetcode.com/problems/two-sum/
// Difficulty: Easy
// Topics: Array, HashMap
// Date solved: 2026-04-23
// Solve time: ~45m (guided, Format B) / ~10m (clean re-solve target)
//
// MARK: - Approach
// 1. Brute force:    O(n²) time, O(1) space
//    → Nested loop, every pair. Rejected: O(n²) dies at n=10M.
// 2. Sort + 2 Ptr:   O(n log n) time, O(n) space
//    → Must pair with original indices before sort (tuples). Rejected: hash map beats it.
// 3. Hash Map (opt): O(n) time, O(n) space
//    → Single pass. For each num, check if complement exists in dict.
//    → Key insight: LOOKUP BEFORE INSERT handles duplicates and same-index constraint.
//
// MARK: - Dictionary Structure
// [value: originalIndex]
//   - key   = element value we've already seen
//   - value = that element's index in original array
//
// MARK: - Edge Cases
// - Duplicates: [3, 3], target = 6 → [0, 1]  (handled by lookup-before-insert)
// - Negatives: [-1, -2, -3, -4, -5], target = -8 → [2, 4]
// - Match at end: [3, 2, 4], target = 6 → [1, 2]
// - No solution: problem guarantees exactly one solution (defensive return [] for compiler)

import Foundation

class Solution {
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
}

// MARK: - Tests
let s = Solution()

assert(s.twoSum([2, 7, 11, 15], 9) == [0, 1],
       "Basic case failed")

assert(s.twoSum([3, 3], 6) == [0, 1],
       "Duplicate case failed")

assert(s.twoSum([3, 2, 4], 6) == [1, 2],
       "Match-at-end case failed")

assert(s.twoSum([-1, -2, -3, -4, -5], -8) == [2, 4],
       "Negative numbers case failed")

print("✅ All tests passed")
