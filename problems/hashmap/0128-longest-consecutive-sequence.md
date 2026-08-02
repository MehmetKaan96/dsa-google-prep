# LeetCode #128 — Longest Consecutive Sequence

> **Zorluk:** Medium · **Konular:** Array, HashSet · **Pattern:** Set O(1) membership + sequence-start detection
> **Blind 75 / NeetCode 150:** ✅ · **Çözüm tarihi:** 2026-08-02 (guided, Format B)

---

## 1. Problem Tanımı

Sırasız integer array `nums`. **Ardışık** elemanlardan oluşan en uzun dizinin **uzunluğunu** döndür. Algoritma **O(n)** olmalı.

**Örnek:** `[100, 4, 200, 1, 3, 2]` → ardışık en uzun `[1,2,3,4]` → **4**.

**Constraint teyidi:**
| Constraint | Cevap | Etki |
|------------|-------|------|
| **O(n) şart** (prompt) | Evet | Sort tabanlı (O(n log n)) çözümü **eler** → hash gerekir |
| Duplicate? | Evet | `Set` doğal dedup; `[1,2,2,3]`→3 |
| Negatif? | Evet | Hash fark etmez (Priority 3) |
| Boş dizi? | Evet | 0 döner |

---

## 2. Clarifying — refleks

Prompt "O(n)" diyor → **soru değil, implikasyon:** *"Sort'u (O(n log n)) eliyorum, hash tabanlı düşünüyorum."* Ek algoritma-etkileyen: duplicate olabilir mi (evet → Set dedup).

---

## 3. Approach Evolution

### Approach 1 — Sort + tarama (REJECT)
Diziyi sort et, ardışık run'ları say (eşitleri atla).
- **Time:** O(n log n) — sort baskın · **Space:** O(1)/O(n)
- **Reject:** Prompt O(n) istiyor; sort bunu ihlal eder.

### Approach 2 — Set + başlangıç tespiti (OPTIMAL)

**İki fikir:**
1. Tüm sayıları `Set`'e koy → **O(1) membership** (+ dedup).
2. Her run'ın **tek başlangıcı** var: `x-1`'i Set'te **olmayan** sayı. Sadece oradan sağa yürü; ortadakileri atla.

```swift
func longestConsecutive(_ nums: [Int]) -> Int {
    let set = Set(nums)
    var longest = 0
    for num in set {
        if !set.contains(num - 1) {          // num bir başlangıç mı?
            var current = num
            var length = 1
            while set.contains(current + 1) { // run'ı sağa yürü
                current += 1
                length += 1
            }
            longest = max(longest, length)
        }
    }
    return longest
}
```

- **Time:** **O(n)** — aşağıda ispat · **Space:** O(n) (Set)

### Neden O(n)? (iç içe döngü ama lineer)
- `for` = n kez × O(1) başlangıç-kontrolü = O(n).
- `while` = sadece başlangıçlardan; **tüm** while adımlarının toplamı = tüm run uzunlukları toplamı = **n** (her sayı tam bir run'a ait, bir kez yürünür).
- Toplam = n + n = **O(n)**. (Amortized mantığı: iç işin *toplamı* n ile sınırlı.)

---

## 4. Trace — `[3, 1, 2]` (Set for'da rastgele sırada)

```
set = {3,1,2}, longest=0
num=3: contains(2)? EVET → başlangıç değil, atla
num=1: contains(0)? hayır → başlangıç. current=1,length=1
        contains(2)? evet → current=2,length=2
        contains(3)? evet → current=3,length=3
        contains(4)? hayır → dur. longest=max(0,3)=3
num=2: contains(1)? EVET → atla
→ 3
```

---

## 5. Edge Cases
| Case | Sonuç | Neden |
|------|-------|-------|
| `[]` | 0 | for hiç çalışmaz |
| `[5]` | 1 | tek başlangıç, while girmez, length=1 |
| `[1,2,2,3]` | 3 | Set dedup → {1,2,3} |
| Hepsi ayrık `[10,20,30]` | 1 | her biri tek başına run |

---

## 6. Common Mistakes — Personal Record

### Mistake 1 — `while set.contains(num + 1)` (sonsuz döngü)
`num` for değişkeni, while boyunca **sabit**. `num+1` hep aynı → koşul hep true → **sonsuz döngü**. İleri yürüyen ayrı bir `current` gerekir; koşul `current + 1` olmalı.
**Kural:** while ilerliyorsa, koşulda **ilerleyen** değişken olmalı, sabit olan değil.

### Mistake 2 — `length` sıfırlanmaması / 0'dan başlaması
`length`'i for dışında `0` tanımlayınca (a) sequence'ler arası sıfırlanmıyor, (b) tek elemanlı run 0 sayılıyor. Doğrusu: **her başlangıçta** `length = 1` (num'un kendisi).

### Mistake 3 — `set.count`'u sequence uzunluğu sanmak
`set.count` = tüm set boyutu, o run'ın uzunluğu değil. Ayrı bir yerel sayaç (`length`) tut.

### Mistake 4 — for'un sıralı geldiğini varsaymak
Set **sırasız** gezilir; `num` 1,2,3,4 sırayla gelmez. Bu yüzden bir başlangıç bulunca run'ın **tamamını o an** while ile yürümek gerekir.

---

## 7. Reusable Pattern — Set O(1) membership ile sort'u eleme

**Ne zaman:** "Sırasız veride ardışıklık / komşuluk / var mı" + **O(n) hedef**. Sort'u (O(n log n)) Set membership (O(1)) ile değiştir.

```swift
let set = Set(items)
for x in set where !set.contains(previousOf(x)) {  // sadece "başlangıç"lar
    // x'ten ileri yürü, set.contains ile
}
```

---

## 8. Follow-up
- **"Sequence'in kendisini döndür"** → length yerine start..current aralığını sakla.
- **"En uzun ardışık *çift/tek*"** → adım mantığını değiştir.
- **"Union-Find ile"** → alternatif; ardışıkları birleştir (mülakatçı sorabilir).

---

## 9. Re-solve Protocol
1. **+3 gün (2026-08-05):** Sıfırdan çöz, notsuz. Hedef: Set + başlangıç-tespiti fikrini kendin kur.
2. **+1 hafta:** "O(n) neden? iç içe döngüye rağmen" sorusunu sözel yanıtla.
3. **+2 hafta:** Tekrar çöz, ≤ 12 dk.

> Not: İlk çözümde ağır scaffold vardı — asıl "anladım" anı trace'i kendi yürütünce geldi. Re-solve bunu mühürleyecek.

---

## References
- [LeetCode #128](https://leetcode.com/problems/longest-consecutive-sequence/)
- Mekanik: `concepts/02-hashtable.md` (Set O(1) membership)
- Pattern: `concepts/00-PATTERN-TRIGGERS.md`
