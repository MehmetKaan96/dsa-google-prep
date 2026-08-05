# LeetCode #485 — Max Consecutive Ones

> **Zorluk:** Easy · **Konular:** Array · **Pattern:** Running counter + max (tek geçiş)
> **Çözüm tarihi:** 2026-08-05 · **Amaç:** zayıf nokta drill'i (sayaç kalıbı)

---

## 1. Problem
Binary array `nums` (0/1). Ardışık 1'lerin en uzun serisinin uzunluğu.
`[1,1,0,1,1,1]` → `3` · `[1,0,1,1,0,1]` → `2`

---

## 2. Çözüm

```swift
func maxConsecutiveOnes(_ nums: [Int]) -> Int {
    var longest = 0
    var current = 0                        // for'un DIŞINDA — turlar arası yaşar
    for num in nums {
        if num == 1 {
            current += 1                   // seri uzuyor
            longest = max(longest, current) // her artışta kontrol
        } else {
            current = 0                    // seri koptu
        }
    }
    return longest
}
```
- **Time:** O(n) · **Space:** O(1)

**Neden "dizi 1 ile biterse" özel durumu yok:** `longest`'ı her artışta güncellediğimiz için son seri zaten kaydedilmiş olur. (Sadece `0` görünce güncelleseydik, sona kadar 1 giden seri kaçardı.)

---

## 3. Trace — `[1,1,0,1,1,1]`
```
1 → current=1, longest=1
1 → current=2, longest=2
0 → current=0
1 → current=1, longest=2
1 → current=2, longest=2
1 → current=3, longest=3  ✓
```

---

## 4. Common Mistakes — Personal Record

### Mistake 1 — **Sayacı blok İÇİNDE tanımlamak (ana bug, 3 denemede çözüldü)**
`else { var length = 1 ... }` yazdım → her `1` görüşünde sayaç **yeniden doğdu**, birikim olmadı, hep 1-2 döndü.
**Kural:** Blok içinde tanımlanan `var` her girişte sıfırdan yaratılır. Turlar arası bilgi taşıyacak değişken **döngünün dışında** tanımlanmalı.
**Nüans (ezber değil):** *Sayacın ömrü, saydığın şeyin ömrüne eşit olmalı.* #128'de sayaç içerideydi ve doğruydu (her başlangıç kendi yürüyüşü); burada tek geçişte biriktiğimiz için dışarıda.

### Mistake 2 — Alakasız koşulla tuzağı çözmeye çalışmak
"Dizi 1 ile biterse" endişesiyle `if index != nums.count - 1 { length += 1 }` yazdım — ardışıklıkla **hiç ilgisi yok**, sadece gürültü. Doğru çözüm: `longest`'ı her artışta güncelle, özel durum gerekmez.
**Kural:** Bir edge case'i çözmeden önce, doğru ana mantığın onu zaten kapsayıp kapsamadığına bak.

### Mistake 3 — `max(longest, 1)` (sabit yazmak)
Sayaç yerine literal `1` kullanmak → hep 1 döner. Değişkeni kullandığından emin ol.

---

## 5. Reusable Pattern — Running counter + max
```swift
var best = 0, current = 0        // İKİSİ DE döngü dışında
for x in items {
    if devamKosulu(x) { current += 1; best = max(best, current) }
    else { current = 0 }
}
```
**Kardeşler:** Max Consecutive Ones III (1004, sliding window), Longest Substring Without Repeating (3), Maximum Subarray/Kadane (53) — hepsi "running state + best" iskeleti.

---

## 6. Re-solve
1. **+1 gün:** Sıfırdan, ≤ 4 dk. Sayacın **nerede** tanımlandığına dikkat.
2. **+3 gün:** Kadane (53) ile kıyasla — aynı iskelet, farklı state.

## References
- [LeetCode #485](https://leetcode.com/problems/max-consecutive-ones/)
- Deck: LOOP-2 (scope/ömür), PROB-0485
