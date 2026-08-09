// LeetCode #20 — Valid Parentheses
// Stack · String · LIFO matching
// Time: O(n) · Space: O(n)

import Foundation

func isValid(_ s: String) -> Bool {
    var stack: [Character] = []
    let pairs: [Character: Character] = [")": "(", "]": "[", "}": "{"]

    for char in s {
        if let expectedOpen = pairs[char] {      // closing bracket
            if stack.last == expectedOpen {
                stack.removeLast()                // matched → pop
            } else {
                return false                      // mismatch or empty stack → invalid
            }
        } else {                                  // opening bracket
            stack.append(char)
        }
    }
    return stack.isEmpty                          // leftover opens → invalid
}

// Notes:
// - pairs[char] == nil  => opening ; non-nil => closing. One dict, both jobs.
// - stack.last on empty array returns nil (no crash); nil == "[" is false.
// - The mismatch branch MUST return false — doing nothing silently swallows
//   the character and "]" would wrongly return true.

// Quick checks
// "()"      -> true    "()[]{}" -> true    "{[]}" -> true
// "(]"      -> false   "([)]"   -> false   "]"    -> false
// "((("     -> false   ""       -> true
