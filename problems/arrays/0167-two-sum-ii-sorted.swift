// LeetCode #167 — Two Sum II (Input Array Is Sorted)
// Array · Two Pointers · Converging pointers on sorted array
// Time: O(n) · Space: O(1)  — already optimal

import Foundation

func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var left = 0
    var right = numbers.count - 1
    while left < right {
        let sum = numbers[left] + numbers[right]
        if sum == target { return [left + 1, right + 1] }  // 1-indexed (LC 167)
        else if sum > target { right -= 1 }                // need smaller sum
        else { left += 1 }                                 // need larger sum
    }
    return []
}

// Why O(n): each iteration moves exactly one pointer; the gap (right-left)
// shrinks by 1 each step from n-1 → at most n steps. Sorted is REQUIRED:
// only sortedness guarantees right-- makes the sum smaller.

// Quick checks
// [1,3,4,6,8,11], 10 -> [3,4]   (4+6)
// [2,7,11,15],    9  -> [1,2]   (2+7)
// [-3,0,3,5],     0  -> [1,3]   (-3+3)
