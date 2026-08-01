// LeetCode #283 — Move Zeroes
// Array · Two Pointers · In-place write-pointer (compaction)
// Time: O(n) · Space: O(1)

import Foundation

// MARK: - Approach 2 — Two-pointer: compact non-zeros, then zero-fill tail
func moveZeroes(_ nums: inout [Int]) {
    var slow = 0                          // next slot for a non-zero
    for i in 0..<nums.count {
        if nums[i] != 0 {
            nums[slow] = nums[i]
            slow += 1
        }
    }
    for i in slow..<nums.count {          // overwrite tail in place (NOT append)
        nums[i] = 0
    }
}

// MARK: - Approach 3 — Single-pass swap (minimizes writes)
func moveZeroesSwap(_ nums: inout [Int]) {
    var slow = 0
    for fast in 0..<nums.count where nums[fast] != 0 {
        nums.swapAt(slow, fast)
        slow += 1
    }
}

// MARK: - Quick checks
// [0,1,0,3,12] -> [1,3,12,0,0]
// []           -> []          (loops don't run)
// [0,0,0]      -> [0,0,0]     (slow stays 0, tail zero-filled)
// [1,2,3]      -> [1,2,3]     (slow == count, tail range empty)
