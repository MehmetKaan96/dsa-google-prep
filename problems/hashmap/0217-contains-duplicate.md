# LeetCode #217 — Contains Duplicate

> **Zorluk:** Easy · **Konular:** Array, HashSet · **Pattern:** Single-pass hash lookup
> **Blind 75 / NeetCode 150:** ✅ Core problem

---

## 1. Problem Tanımı

Bir integer array `nums` verildiğinde, herhangi bir değer **en az iki kez** geçiyorsa `true`, her eleman **distinct** ise `false` döndür.

**Örnekler:**
```
nums = [1, 2, 3, 1]                    → true
nums = [1, 2, 3, 4]                    → false
nums = [1, 1, 1, 3, 3, 4, 3, 2, 4, 2]  → true
```

**Constraints:**
| Constraint | Değer |
|------------|-------|
| Array length | 1 ≤ nums.length ≤ 10⁵ |
| Value range | -10⁹ ≤ nums[i] ≤ 10⁹ |

---

## 2. Clarifying Questions — Kalibrasyon

Constraint'leri net olan bir Easy problem için **2-3 soru** doğru miktar. 5+ soru anti-signal.

**Priority 1 — Soruldu**
- Array sorted mi? → Hayır (rastgele sıra). *Önemli: optimal yaklaşımı değiştirir.*

**Priority 2 — Constraint'lerden okunabilir (skip edilebilir)**
- Boş array? → Hayır, constraint ≥ 1 diyor.
- Negatif / sıfır? → Evet (range negatif kapsıyor).

**Priority 3 — Opsiyonel**
- Original'i mutate edebilir miyim? → Sort-based approach için relevant.
- Memory budget? → Hash vs sort seçimini etkiler.

### Senior Hareketi
Cevabı constraint'lerde olan soruları skip et. Hem zaman kazanır, hem de "problemi dikkatli okudum" sinyali verir.

---

## 3. Approach Evolution

### Approach 1 — Brute Force (Nested Loops)

Her `i` için, her `j > i`'yi `nums[i] == nums[j]` ile kontrol et.

- **Time:**  O(n²)
- **Space:** O(1)
- **Reject sebebi:** n=10⁵'te O(n²) = 10¹⁰ ops. Ölü.

### Approach 2 — Sort + Adjacent Check

Array'i sort et. Eğer duplicate varsa, sort'tan sonra **bitişik (adjacent)** olur. Tek pass komşuları karşılaştır.

- **Time:**  O(n log n) — sort dominate eder
- **Space:** O(1) in-place sort ile, O(n) tuple-preserving variant'larda
- **Reject sebebi:** Hash Set'ten kesin daha kötü. Sadece O(1) space mecburi ise çekici.

### Approach 3 — Hash Set Single-Pass (OPTIMAL)

Her `num` için, set'te zaten var mı kontrol et. Varsa → duplicate. Yoksa → insert et ve devam.

```swift
var seen: Set<Int> = []
for num in nums {
    if seen.contains(num) { return true }
    seen.insert(num)
}
return false
```

- **Time:**  O(n)
- **Space:** O(n) — set n entry'ye kadar büyüyebilir

---

## 4. Set vs Dictionary — Burada Neden Set?

Two Sum'da `Dictionary [value: index]` kullandık çünkü match'in **index'ini döndürmemiz** gerekiyordu.

Contains Duplicate sadece **boolean cevap** istiyor. Eleman başına associated data yok. O yüzden `Set<Int>` doğru type.

| İhtiyaç | Tercih |
|---------|--------|
| "X'i gördüm mü? Evet/Hayır." | `Set<T>` |
| "X'i gördüm mü? Evet ise index/count/data ne?" | `Dictionary<T, Data>` |

**Yaygın hata:** `[Int: Void]`'a uzanmak. Yapma. `Set` purpose-built ve daha temiz.

---

## 5. Complexity Analysis

| Metric | Value | Notes |
|--------|-------|-------|
| Time (avg) | O(n) | Tek pass × O(1) avg set ops |
| Time (worst) | O(n²) | Teorik — hash collision |
| Space | O(n) | Worst: hepsi unique → set n'e büyür |

Aynı Swift Dictionary/Set garantileri geçerli: **randomized hash seed** pratik durumda O(n) güvencesi verir.

---

## 6. Trace Walkthrough

### Trace 1 — Sondaki Duplicate
```
nums = [1, 2, 3, 1]

num=1: seen={}        contains? hayır → insert {1}
num=2: seen={1}       contains? hayır → insert {1,2}
num=3: seen={1,2}     contains? hayır → insert {1,2,3}
num=1: seen={1,2,3}   contains? EVET → return true
```

### Trace 2 — Hepsi Unique
```
nums = [1, 2, 3, 4]

(Her num insert edilir, hiç görünmez.)
Loop sonu: return false
```

### Trace 3 — Tek Eleman
```
nums = [1]

num=1: seen={} contains? hayır → insert {1}
Loop sonu: return false
```

---

## 7. Edge Cases Checklist

| Case | Beklenen | Notlar |
|------|----------|--------|
| Tek eleman | `false` | Loop bir kez çalışır, duplicate bulunmaz |
| İki aynı eleman | `true` | i=1'de anında tespit |
| Hepsi unique | `false` | Loop tamamlanır, sonda return |
| Çok duplicate | `true` | İlk collision'da return (early exit) |
| Negatif / sıfır | Çalışır | `Set<Int>` tüm Int range'i handle eder |
| Max size (10⁵) | O(n), sorun yok | |

---

## 8. Common Mistakes — Personal Record

Bugünkü seanstan canlı yakalandı.

### Mistake 1 — Inverted Guard Logic

İlk kod:
```swift
guard nums.count == 1 else { return false }
```

Bu *"sadece count == 1 ise devam et; aksi halde false dön"* der. Yani 2+ elemanlı bir input için, loop'a girmeden anında `false` döneriz. **Felaket.**

**Fix:**
```swift
guard nums.count != 1 else { return false }
// Veya daha basit: guard'ı sil — loop count==1 case'ini doğru handle ediyor.
```

**Kural:** Her `guard`'ı sesli oku — *"sadece X ise devam et; aksi halde Y yap."* Eğer "aksi halde" branch'i istediğin early-exit ise, condition'ı tersine çevir.

### Mistake 2 — Inverted Return Values

İlk kod duplicate bulunca `false`, sonda `true` döndürüyordu.

**Kural:** Return value'larını **English semantics**'e map'le sonra kod yaz. *"Duplicate buldum mu? → return true (evet, contains duplicate)."* Önce boolean'ı yazma; önce **anlamı** yaz, boolean ondan çıkar.

### Mistake 3 — Set'e Dictionary Demek

Sözel olarak *"Set[Int: Void]"* dedim. Swift'in `Set<Int>`'i kendi başına first-class bir type — Void value'lı Dictionary değil.

**Kural:** Set ve Dictionary aynı underlying mechanic'i (hash table) paylaşır ama Swift'te ayrı type'lardır. Problem sadece membership test istiyorsa `Set` ismini açıkça söyle — hem correctness hem signal için.

### Mistake 4 — Hiçbir Şey Eklemeyen Defensive Guard

Guard logic'ini düzelttikten sonra bile, `count == 1` için guard gereksizdi. Main loop tek elemanlı array'i doğru handle eder: bir kez iterate eder, hiçbir match'leyen eklemez, sonda `false` döner.

**Kural:** Defensive code, sadece davranışı veya readability'yi değiştiriyorsa iyi. Loop'un zaten ürettiği sonuca early-exit yapan bir guard sadece gürültü.

---

## 9. Reusable Pattern Reference

Bu problem [`0001-two-sum.md`](./0001-two-sum.md)'de dökümante edilen hash-map single-pass pattern'inin **direkt uygulamasıdır**.

İskelet:

```swift
var seen: Set<Element> = []   // Veya data lazım ise [Element: Data]
for item in collection {
    if seen.contains(item) {
        return /* match-found result */
    }
    seen.insert(item)
}
return /* no-match result */
```

**Mental model:** *"Bu tam aynısını daha önce gördüm mü? → Set."*

### Direct Cousins (Aynı Pattern Family)

| Problem | Twist |
|---------|-------|
| #1 Two Sum | Complement gerekli, index dön |
| #217 Contains Duplicate (this) | Sadece evet/hayır |
| #219 Contains Duplicate II | k mesafesi içinde — index sakla |
| #220 Contains Duplicate III | k mesafe + t value range — bucket / sliding window |
| #242 Valid Anagram | Frequency count'lar |
| #49 Group Anagrams | Canonical key'e göre grupla |

---

## 10. Follow-up Questions an Interviewer May Ask

### FU-1: "Extra space kullanamasaydın?"
Sort + adjacent karşılaştırma. O(n log n) time, O(1) space (in-place sort ile). Trade-off'u söyle.

### FU-2: "Sadece k index içindeki duplicate'ler sayılsa?"
Bu **LeetCode #219**. `[value: lastSeenIndex]` sakla ve `currentIndex - lastSeenIndex <= k` karşılaştır.

### FU-3: "Array çok büyük ve memory'e sığmıyorsa?"
External sorting + adjacent check. Veya probabilistic: ilk pass için Bloom filter (false positive olabilir, false negative yok), küçük candidate set'te exact verification.

### FU-4: "Sadece duplicate detect etmek değil, kaç kez geçtiğini saymak gerekirse?"
`Set<Int>`'ten `[Int: Int]`'e (frequency map) geç. Tek pass'te count'ları döner.

### FU-5: "Bunu nasıl parallelize edersin?"
Map-reduce: array'i partition'la, shard başına set build et, merge et. Final merge'te memory blow-up var.
Daha pratik: external sort + sequential adjacent scan.

### FU-6: "Hangi test case'leri yazardın?"
- Boş (constraint hayır diyor ama defensively test et): handle mı, reject mi?
- Tek eleman: `false`
- İki eleman: aynı/farklı
- Tüm aynı value
- Hepsi unique
- Match start, end, middle
- Max size (perf, correctness değil)
- Negatif, sıfır, max/min Int

---

## 11. Mock Session Debrief

### What Went Well
- Brute force + complexity baştan doğru söylendi.
- `[1, 2, 3, 1]` üzerinden trace narrasyonu — Two Sum'a göre iyileşme.
- Set'in doğru yapı olduğu (Dictionary'ye göre) tespit edildi.
- İki bug (guard, return value) probe sonrası self-correct edildi.

### Needs Work
- **Set vs Dictionary terminolojisi**: `Set[Int: Void]` denildi. Yapılar conflate edildi. Ezber: *"Set Swift'te first-class type, Dictionary'den ayrı."*
- **Boolean inversion**: probe öncesi yanlış değerler döndü. Önce English meaning, sonra boolean.
- **Guard logic inversion**: commit öncesi `guard`'ı sesli oku.
- **Active recall (warm-up)**: *"hatırlıyorum"* dedi cevap vermeden. Mülakatlarda articulate olmadan "hatırlama" = bilmeme.

### Internalize Edilecek Tek Kural
**"Return value'lar English semantics'i mirror eder. Anlamı yaz, boolean ondan çıkar."**
*"Duplicate buldum mu? Evet → return true."* Keyword'le başlama.

---

## 12. Re-solve Protocol

1. **+1 gün:** 30-min passive review of this MD.
2. **+2 gün:** Sıfırdan çöz, notlara bakmadan, hedef ≤ 5 dk (Easy zaten).
3. **+7 gün:** Recall sorusu — *"Set vs Dictionary, ne zaman?"*
4. **+14 gün:** Re-solve.
5. **+1 ay:** Spaced repetition final.

---

## References

- [LeetCode #217](https://leetcode.com/problems/contains-duplicate/)
- Pattern doc: [`0001-two-sum.md`](./0001-two-sum.md)
- Swift `Set` — [Apple Docs](https://developer.apple.com/documentation/swift/set)
- Related: `0001-two-sum`, `0049-group-anagrams` (gelecek), `0242-valid-anagram` ✓
