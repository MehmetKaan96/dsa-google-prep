// LeetCode #242 — Valid Anagram
// Difficulty: Easy · Topics: Hash Table, Sorting, String
// Pattern: Frequency map + decrement (count-and-match)

import Foundation

// MARK: - Approach 1: HashMap (Optimal)
// Time: O(n), Space: O(n)
// Build frequency map from s, decrement from t with inline early-exit.

class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }

        var dict: [Character: Int] = [:]

        for char in s {
            dict[char, default: 0] += 1
        }

        for char in t {
            guard let c = dict[char], c > 0 else { return false }
            dict[char] = c - 1
        }

        return true
    }
}

// MARK: - Approach 2: Sort
// Time: O(n log n), Space: O(n) — copy + sort
// Compact one-liner; loses to HashMap on very large inputs.

class SolutionSort {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        return s.sorted() == t.sorted()
    }
}

// MARK: - Tests

let solution = Solution()
let sortSolution = SolutionSort()

// Test 1: Happy path — anagram
assert(solution.isAnagram("anagram", "nagaram") == true,
       "Test 1 failed: 'anagram' / 'nagaram' should be anagram")

// Test 2: Negative — different chars
assert(solution.isAnagram("rat", "car") == false,
       "Test 2 failed: 'rat' / 'car' should NOT be anagram")

// Test 3: Different lengths
assert(solution.isAnagram("ab", "abc") == false,
       "Test 3 failed: different lengths should return false")

// Test 4: Same single char
assert(solution.isAnagram("a", "a") == true,
       "Test 4 failed: 'a' / 'a' should be anagram")

// Test 5: Different single char
assert(solution.isAnagram("a", "b") == false,
       "Test 5 failed: 'a' / 'b' should NOT be anagram")

// Test 6: Same string
assert(solution.isAnagram("abc", "abc") == true,
       "Test 6 failed: same string should be anagram of itself")

print("✅ All hashmap tests passed!")

// Sort tests — same expectations
assert(sortSolution.isAnagram("anagram", "nagaram") == true)
assert(sortSolution.isAnagram("rat", "car") == false)
assert(sortSolution.isAnagram("ab", "abc") == false)

print("✅ All sort tests passed!")
