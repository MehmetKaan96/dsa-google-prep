// LeetCode #128 — Longest Consecutive Sequence
// Array · HashSet · Set O(1) membership + sequence-start detection
// Time: O(n) · Space: O(n)

import Foundation

func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)                        // O(n), dedup dahil, O(1) membership
    var longest = 0

    for num in set {
        // Sadece bir run'ın BAŞLANGICINDAN say: sol komşusu (num-1) yoksa.
        if !set.contains(num - 1) {
            var current = num
            var length = 1                     // num'un kendisi = 1
            while set.contains(current + 1) {  // 'current' ilerler, 'num' değil (yoksa sonsuz döngü)
                current += 1
                length += 1
            }
            longest = max(longest, length)
        }
    }
    return longest
}

// O(n) neden: for = n × O(1) start-check; tüm while adımlarının TOPLAMI = tüm run
// uzunlukları toplamı = n. Toplam 2n = O(n) (iç içe döngü ama iç iş n ile sınırlı).

// Quick checks
// [100,4,200,1,3,2] -> 4   ([1,2,3,4])
// [3,1,2]           -> 3
// []                -> 0
// [1,2,2,3]         -> 3   (Set dedup)
// [10,20,30]        -> 1
