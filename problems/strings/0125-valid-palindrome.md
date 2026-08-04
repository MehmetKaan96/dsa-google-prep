# LeetCode #125 — Valid Palindrome

> **Zorluk:** Easy · **Konular:** String, Two Pointers · **Pattern:** Converging two pointers + skip filter
> **Çözüm tarihi:** 2026-08-04 (guided) · **Sentez:** String mekaniği + two pointers

---

## 1. Problem Tanımı

String `s`: küçük harfe çevirip harf/rakam dışını sildikten sonra baştan-sondan aynı okunuyorsa `true`.

**Örnek:** `"A man, a plan, a canal: Panama"` → `true` · `"race a car"` → `false`

**Constraint teyidi:**
| Constraint | Cevap | Etki |
|------------|-------|------|
| Case-insensitive (prompt) | Evet | `lowercased()` |
| Non-alphanumeric atılır (prompt) | Evet | Karşılaştırmada skip |
| "Alphanumeric" kapsamı? | Harf + rakam (ASCII/Unicode?) | `isLetter \|\| isNumber` |
| Boş string? | `true` (konvansiyon) | while hiç girmez |

---

## 2. Clarify
Verilenleri (case, non-alnum) teyit et, sorma. Gerçek sorular: "alphanumeric" ASCII mi Unicode mu (char-check'i etkiler); boş string → true.

---

## 3. Approach Evolution

### Approach 1 — Temizle + reverse karşılaştır (REJECT space)
Küçült+filtrele → temiz string; onu ters çevir; karşılaştır.
- **Time:** O(n) · **Space:** O(n) — **iki** O(n) kopya (temiz + reversed).
- **Reject:** Space boşa; two pointers ters kopyaya gerek bırakmaz + erken çıkar.

### Approach 2 — Converging two pointers (OPTIMAL)

`left`/`right` iki uçtan; non-alnum'ı skip'le, lowercased karşılaştır.

```swift
func isPalindrome(_ s: String) -> Bool {
    let chars = Array(s.lowercased())          // O(1) index; String str[Int] yasak
    var left = 0, right = chars.count - 1
    while left < right {
        if !chars[left].isLetter && !chars[left].isNumber { left += 1; continue }
        if !chars[right].isLetter && !chars[right].isNumber { right -= 1; continue }
        if chars[left] != chars[right] { return false }
        left += 1; right -= 1
    }
    return true
}
```

- **Time:** O(n) · **Space:** O(n) (`Array(s)`). Erken çıkış avantajı.

### Approach 3 — String.Index ile O(1) space (senior)
`Array(s)` yaratmadan `String.Index` ile yürü → **O(1) space**, O(n) time. Daha karmaşık kod; mülakatçı "O(1) space" derse bu.

> **Swift String notu:** `str[5]` yasak — Character'lar grapheme cluster, değişken byte, sabit stride yok → index O(n) olurdu. `Array(s)` uniform slotlara çevirir → O(1) index, ama O(n) space.

---

## 4. Trace — `"race a car"`
```
[r,a,c,e, ,a, ,c,a,r]  L=0 R=9
r==r → L1 R8 ; a==a → L2 R7 ; c==c → L3 R6
L=3(e) R=6(' '): ' ' skip → R5
L=3(e) R=5(a): e != a → false ✓
```

---

## 5. Edge Cases
| Case | Sonuç | Neden |
|------|-------|-------|
| `""` | true | while girmez |
| `"a"` | true | left==right, girmez |
| `".,"` | true | hepsi skip → temiz boş |
| `"0P"` | false | '0' != 'p' (rakam sayılır) |

---

## 6. Common Mistakes — Personal Record

### Mistake 1 — De Morgan: non-alphanumeric koşulu (**ana bug**)
`!isNumber || !isLetter` yazdım → **her karakter için true** (hiçbiri hem harf hem rakam olamaz) → hepsi skip → hep true.
Doğrusu: alphanumeric = `isLetter || isNumber`; **değil** = `!(isLetter || isNumber)` = **`!isLetter && !isNumber`** (`&&`, `||` değil).
**Kural:** `!(A || B) = !A && !B`. "Ne A ne B" → AND.

### Mistake 2 — Space'i atlamak
Brute'ta time O(n) dedim, space'i unuttum → O(n) (iki kopya). Big-O her zaman **time + space**.

### Mistake 3 — `var` gereksiz
`chars` mutate edilmiyor → `let`.

---

## 7. Reusable Pattern — Two pointers + skip filter
İki uçtan yakınsa, ama bazı elemanları **atlayarak** (filtre). Palindrome, "valid" kontrolleri.
```swift
while left < right {
    if skip(left)  { left += 1; continue }
    if skip(right) { right -= 1; continue }
    if a[left] != a[right] { return false }
    left += 1; right -= 1
}
```

---

## 8. Follow-up
- **"O(1) space"** → `String.Index` ile yürü, `Array(s)` yok.
- **"En fazla 1 karakter silerek palindrom (Valid Palindrome II, 680)"** → mismatch'te iki dallı dene.
- **"Unicode/aksan normalizasyonu?"** → grapheme cluster + folding nüansları.

---

## 9. Re-solve Protocol
1. **+3 gün:** Sıfırdan, ≤ 6 dk. De Morgan koşulunu doğru kur.
2. **+1 hafta:** "Neden `Array(s)`? String str[Int] neden yasak?" sözel.
3. **+2 hafta:** String.Index (O(1) space) versiyonunu dene.

---

## References
- [LeetCode #125](https://leetcode.com/problems/valid-palindrome/)
- Mekanik: `concepts/03-string-two-pointers.md`
- Pattern: `problems/arrays/0167-two-sum-ii-sorted.md` (converging two pointers)
