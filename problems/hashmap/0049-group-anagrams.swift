// LeetCode #49 — Group Anagrams
// Difficulty: Medium · Topics: Hash Table, String, Sorting
// Pattern: Canonical key (sorted string) → Dictionary grouping

import Foundation

// MARK: - Approach 1: Sort Key (Interview default — short + correct)
// Time: O(n · k log k), Space: O(n · k)
// n = number of strings, k = max string length

class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var groups: [String: [String]] = [:]
        for s in strs {
            let key = String(s.sorted())
            groups[key, default: []].append(s)
        }
        return Array(groups.values)
    }
}

// MARK: - Tests (order-independent)

func normalizeGroups(_ groups: [[String]]) -> [[String]] {
    groups
        .map { $0.sorted() }
        .sorted {
            if $0.count != $1.count { return $0.count < $1.count }
            return $0.lexicographicallyPrecedes($1)
        }
}

let solution = Solution()

let out1 = solution.groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"])
let exp1 = [["bat"], ["nat", "tan"], ["ate", "eat", "tea"]]
assert(normalizeGroups(out1) == normalizeGroups(exp1))

let out2 = solution.groupAnagrams(["ab", "ba", "b", "aab", "baa"])
let exp2 = [["ab", "ba"], ["b"], ["aab", "baa"]]
assert(normalizeGroups(out2) == normalizeGroups(exp2))

let out3 = solution.groupAnagrams(["a", "b", "c"])
let exp3 = [["a"], ["b"], ["c"]]
assert(normalizeGroups(out3) == normalizeGroups(exp3))

let out4 = solution.groupAnagrams(["a", "a", "a"])
let exp4 = [["a", "a", "a"]]
assert(normalizeGroups(out4) == normalizeGroups(exp4))

let out5 = solution.groupAnagrams([""])
let exp5 = [[""]]
assert(normalizeGroups(out5) == normalizeGroups(exp5))

let out6 = solution.groupAnagrams(["", ""])
let exp6 = [["", ""]]
assert(normalizeGroups(out6) == normalizeGroups(exp6))

print("✅ Group Anagrams tests passed")
