// LeetCode #125 — Valid Palindrome
// String · Two Pointers · converging + skip filter
// Time: O(n) · Space: O(n) [Array version] or O(1) [String.Index version]

import Foundation

// MARK: - Version A — Array(s): simple, O(n) space, O(1) index
func isPalindrome(_ s: String) -> Bool {
    let chars = Array(s.lowercased())              // str[Int] yasak → Array uniform slotlar
    var left = 0, right = chars.count - 1
    while left < right {
        if !chars[left].isLetter && !chars[left].isNumber { left += 1; continue }
        if !chars[right].isLetter && !chars[right].isNumber { right -= 1; continue }
        if chars[left] != chars[right] { return false }
        left += 1; right -= 1
    }
    return true
}

// MARK: - Version B — String.Index: O(1) space (no Array copy)
func isPalindromeInPlace(_ s: String) -> Bool {
    guard !s.isEmpty else { return true }          // index(before: endIndex) crash guard
    var left = s.startIndex
    var right = s.index(before: s.endIndex)        // endIndex = past-the-end
    while left < right {
        let l = s[left], r = s[right]
        if !l.isLetter && !l.isNumber { left = s.index(after: left); continue }
        if !r.isLetter && !r.isNumber { right = s.index(before: right); continue }
        if l.lowercased() != r.lowercased() { return false }  // lowercase per-compare (O(1) space)
        left = s.index(after: left)
        right = s.index(before: right)
    }
    return true
}

// Quick checks
// "A man, a plan, a canal: Panama" -> true
// "race a car"                     -> false
// ""                               -> true
// "0P"                             -> false
