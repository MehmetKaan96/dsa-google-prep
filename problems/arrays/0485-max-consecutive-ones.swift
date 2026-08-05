// LeetCode #485 — Max Consecutive Ones
// Array · Running counter + max (single pass)
// Time: O(n) · Space: O(1)

import Foundation

func maxConsecutiveOnes(_ nums: [Int]) -> Int {
    var longest = 0
    var current = 0                         // OUTSIDE the loop: must survive iterations
    for num in nums {
        if num == 1 {
            current += 1                    // run grows
            longest = max(longest, current) // check on every increment
        } else {
            current = 0                     // run broken
        }
    }
    return longest
}

// Why no special case for "array ends with 1": longest is updated on every
// increment, so the final run is already recorded. (Updating only on 0 would miss it.)
//
// Scope lesson: a `var` declared inside a block is recreated on every entry —
// accumulation is impossible. Counter lifetime must match what you're counting.

// Quick checks
// [1,1,0,1,1,1] -> 3
// [1,0,1,1,0,1] -> 2
// [0,0,0]       -> 0
// [1,1,1]       -> 3
// []            -> 0
