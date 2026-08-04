# LeetCode #167 — Two Sum II (Input Array Is Sorted)

> **Zorluk:** Medium · **Konular:** Array, Two Pointers · **Pattern:** Converging two pointers (sorted)
> **Çözüm tarihi:** 2026-08-04 (guided, Format B) · **İlk denemede bug'sız ✓**

---

## 1. Problem Tanımı

**Sıralı** (artan) integer array `numbers` ve `target`. Toplamı `target` olan iki sayının **1-indexed** pozisyonlarını `[i, j]` döndür (tam bir çözüm var varsayılır). O(1) ek yer kullanılmalı.

**Örnek:** `[1,3,4,6,8,11]`, target=10 → `4+6` → `[3, 4]`.

**Constraint teyidi:**
| Constraint | Cevap | Etki |
|------------|-------|------|
| **Sorted** (prompt) | Evet | **Two pointers'ı açar** → O(1) space |
| Ek yer O(1) | Evet | Hash çözümünü (O(n) space) eler |
| Tek çözüm garanti | Evet | "bulunamadı" nadir; `[]` defensive |
| 1-indexed dönüş | Evet | `[left+1, right+1]` |

---

## 2. Clarify — refleks
Prompt "sorted" + "O(1) space" diyor → **implikasyon:** *"Two pointers kullanıyorum; hash (O(n) space) çözümünü eliyorum."* Kritik: **sorted sinyalini görmek.** (Bu problemin özü: unsorted olsaydı hash gerekirdi.)

---

## 3. Approach Evolution

### Approach 1 — Brute force nested (REJECT)
Her `(i, j)` çiftini dene. O(n²) time, O(1) space. Reject: n=10⁴'te 10⁸ ops, ve sorted'ı kullanmıyor.

### Approach 2 — Hash map (REJECT burada)
`[value: index]`, complement ara. O(n) time ama **O(n) space**. Unsorted için doğru; ama burada sorted + O(1) istendiğinden **space'i boşa harcar.**

### Approach 3 — Converging two pointers (OPTIMAL)

`left` başta (küçük), `right` sonda (büyük). `sum` ile `target`'ı karşılaştır; sorted olduğundan hangi yöne oynayacağını bilirsin.

```swift
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var left = 0
    var right = numbers.count - 1
    while left < right {
        let sum = numbers[left] + numbers[right]
        if sum == target { return [left + 1, right + 1] }
        else if sum > target { right -= 1 }   // daha küçük toplam lazım
        else { left += 1 }                     // daha büyük toplam lazım
    }
    return []
}
```

- **Time:** O(n) · **Space:** O(1) — **zaten optimal.**

### Neden O(n)? Neden sorted şart?
- Her turda **tek** işaretçi oynar; mesafe (`right-left`) her turda 1 azalır, `n-1`'den başlar → en fazla n adım → O(n).
- **Sorted** olmadan çalışmaz: `sum > target` iken `right--`'ın toplamı **kesin** küçülteceğini ancak sıralılık garanti eder. Unsorted → hash'e dön.

---

## 4. Trace — `[1,3,4,6,8,11]`, target=10
```
L=0(1) R=5(11): sum=12 >10 → R=4
L=0(1) R=4(8) : sum=9  <10 → L=1
L=1(3) R=4(8) : sum=11 >10 → R=3
L=1(3) R=3(6) : sum=9  <10 → L=2
L=2(4) R=3(6) : sum=10 ==  → [3,4] ✓
```

---

## 5. Edge Cases
| Case | Sonuç |
|------|-------|
| Tam 2 eleman | tek karşılaştırma |
| Negatifler | çalışır (sorted olduğu sürece) |
| Çözüm yok | `[]` (while biter, L==R) |

---

## 6. Common Mistakes / Notlar — Personal Record

### Not 1 — "Daha optimize edeyim mi?" → HAYIR, tanı
O(n)/O(1) zaten optimal. **Optimalliği tanımak** senior sinyali; uydurma karmaşıklık ekleme.

### Not 2 — sum'ı iki kez hesaplama
`numbers[left]+numbers[right]`'i bir `let sum`'a al (okunurluk + ufak verim). Big-O'yu değiştirmez.

### Not 3 — Pattern tanıma (warm-up'ta kaçırıldı)
"Sorted + pair-sum" → refleks **two pointers** olmalı, hash değil. Hash çalışır ama O(n) space; sorted sinyali O(1)'i açar.

---

## 7. Reusable Pattern — Converging Two Pointers

**Ne zaman:** **Sorted** dizi + "iki-uçtan yakınsayan" karar (pair-sum, palindrome, container).

```swift
var left = 0, right = n - 1
while left < right {
    // karşılaştır → bir uçtan içeri gir
    if condition { left += 1 } else { right -= 1 }
}
```

**Kardeşler:** Valid Palindrome (125), Container With Most Water (11), 3Sum (15, sort + fix one + two-pointer), Trapping Rain Water (42).

---

## 8. Follow-up
- **"Unsorted olsaydı?"** → hash map (O(n) time, O(n) space) veya önce sort (O(n log n)).
- **"Üç sayı (3Sum)?"** → sort + bir elemanı sabitle + kalanda two-pointer → O(n²).
- **"Birden fazla çift, hepsini döndür?"** → eşleşince ikisini de kaydır, taramaya devam.

---

## 9. Re-solve Protocol
1. **+3 gün:** Sıfırdan çöz, ≤ 5 dk. Üç-yönlü karar + `while left < right`.
2. **+1 hafta:** "Neden sorted şart, neden O(1) space?" sözel.
3. **+2 hafta:** Container With Most Water (11) — aynı pattern, farklı karar.

---

## References
- [LeetCode #167](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/)
- Pattern: `concepts/00-PATTERN-TRIGGERS.md` (sorted → two pointers)
- Kontrast: `problems/hashmap/0001-two-sum.md` (unsorted → hash)
