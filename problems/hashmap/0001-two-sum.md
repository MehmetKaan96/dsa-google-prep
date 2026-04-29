# LeetCode #1 — Two Sum

> **Zorluk:** Easy · **Konular:** Array, HashMap · **Pattern:** Single-pass hash lookup
> **Blind 75 / NeetCode 150:** ✅ Core problem

---

## 1. Problem Tanımı

Bir integer array `nums` ve bir integer `target` verildiğinde, toplamı `target`'a eşit olan iki sayının **index**'lerini döndür.

**Problem'in varsayımları:**
- Her input için **tam olarak bir** geçerli cevap var.
- Aynı elemanı iki kez kullanamazsın.
- Index'leri herhangi bir sırada döndürebilirsin.

**Örnek:**
```
Input:  nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
```

**Mülakatta teyit edilecek constraint'ler:**
| Constraint | Cevap | Etki |
|------------|-------|------|
| Sorted? | Hayır | Pure two-pointer'ı eler |
| Negatif değer? | Evet | Yaklaşımı etkilemez |
| Duplicate var mı? | Evet | Lookup-before-insert şart |
| Array boyutu? | 2 → 10⁴ | Üst sınırda O(n²) yetmez |
| Çözüm garantili mi? | Evet | "Bulunamadı / -1" case'i yok |

---

## 2. Clarifying Questions — Doğru Set

Hedef **3-4 yüksek-sinyalli soru**, 10 değil.

**Priority 1 — Input yapısı** (algoritmayı tamamen değiştirir)
- Array sorted mi?
- Değerler negatif / sıfır olabilir mi?
- Duplicate olabilir mi?
- Array boyutu hangi aralıkta?

**Priority 2 — Output spesifikasyonu**
- Index mi value mı dönecek?
- Çözüm her zaman var mı, yoksa "bulunamadı" durumunu da handle etmeli miyim?
- Birden fazla geçerli çözüm — hepsi mi, herhangi biri mi, spesifik mi?

**Priority 3 — Environment / edge case'ler**
- Original array'i mutate edebilir miyim?
- Boş veya tek elemanlı array gelir mi?

### Clarification Fazını Kapatma

> *"Bu kadar yeterli sanırım — eğer kritik bir nüans varsa çözerken fark edersem sorarım. Yaklaşımıma geçebilir miyim?"*

Bu cümle **time management + openness** sinyali verir — staff-engineer hareketi.

---

## 3. Approach Evolution

Her zaman **en az iki** yaklaşımdan geç. Önce brute force'u söylemek trade-off'larla düşündüğünü gösterir.

### Approach 1 — Brute Force (Nested Loops)

Her `i` için, her `j > i`'yi dene ve `nums[i] + nums[j] == target` kontrolü yap.

```
for i in 0..<nums.count {
    for j in (i+1)..<nums.count {
        if nums[i] + nums[j] == target { return [i, j] }
    }
}
```

- **Time:**  O(n²) — Gauss toplamı: `(n-1) + (n-2) + ... + 1 = n(n-1)/2`
- **Space:** O(1)
- **Reject sebebi:** n=10⁷'de O(n²) = 10¹⁴ ops → ölü.

### Approach 2 — Sort + Two Pointers

Array'i sort et, sonra `low` ve `high` pointer'ları birbirine doğru hareket ettir.

**Kritik nokta:** Two-pointer **sorted** array gerektirir — ön koşul. Eğer sort edersek, **original index'leri kaybederiz**. Çözüm: her `(value, originalIndex)` tuple'ı eşleştir, value'ya göre sort et, sonra two-pointer ile original index'leri döndür.

- **Time:**  O(n log n) — sort dominate eder
- **Space:** O(n) — tuple array için
- **Reject sebebi:** İki eksende de hash map'ten kötü. Sadece O(1) space hard requirement ise çekici (burada değil).

### Approach 3 — Hash Map Single-Pass (OPTIMAL)

**Anahtar insight — Complement:**
> Her `num` için soru şuna dönüşür: *"`target - num`'u daha önce gördüm mü?"*
> Evet → çift bulundu. Hayır → `num`'u gelecek query'ler için kaydet.

**Dictionary yapısı:** `[value: originalIndex]`
- Key = gördüğün değer
- Value = onun index'i

**Algoritma (7 satır):**

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (index, num) in nums.enumerated() {
        let complement = target - num
        if let storedIndex = seen[complement] {
            return [storedIndex, index]
        }
        seen[num] = index
    }
    return []
}
```

- **Time:**  O(n) — tek geçiş, average O(1) dict ops
- **Space:** O(n) — dict worst case n entry'ye kadar büyür

### LOOKUP BEFORE INSERT Neden Önemli?

Bu sıralamanın üç ince özelliği var, **hepsi bedavaya geliyor**:

1. **Same-index protection.** Iteration `i`'de, `nums[i]` henüz dict'e eklenmemiş, dolayısıyla kendisiyle eşleşemez.
2. **Duplicate handling.** `[3, 3], target=6`: i=1'de dict'te i=0'dan gelen `3`'ü buluruz → `[0, 1]` döneriz. Eğer önce tüm dict'i build etseydik, `{3: 1}` `{3: 0}`'ı overwrite ederdi.
3. **Early exit.** Çift bulunduğu an return — ikinci pass gerekmez.

---

## 4. Complexity Analysis

| Metric | Value | Notes |
|--------|-------|-------|
| Time (avg) | O(n) | Tek pass × O(1) avg dict ops |
| Time (worst) | O(n²) | Teorik — hash collision |
| Space | O(n) | Worst case: çift son 2 elemanda → dict size n-1 |

### Swift `Dictionary` Pratik Olarak Neden O(1)?

Swift'in `Dictionary`'si **process başına randomized hash seed** kullanır (Swift 4.2+). Bu HashDoS korumasıdır — bir saldırgan tüm key'leri tek bucket'a sokacak input crafting yapamaz, çünkü hash function her process run'da değişir.

**Interview-ready cümle:**
> *"Total time is O(n) — Swift Dictionary gives average O(1) lookup. Worst case is theoretically O(n²) due to hash collisions, but Swift uses randomized hashing, so practically it's always O(n)."*

---

## 5. Trace Walkthrough

Mülakatta her zaman en az bir trace'i sözel olarak anlat.

### Trace 1 — Basic

```
nums = [2, 7, 11, 15], target = 9

i=0: num=2,  comp=7.  seen={}              → insert {2: 0}
i=1: num=7,  comp=2.  seen={2:0}   2 ✓    → return [0, 1]
```

### Trace 2 — Duplicate'ler

```
nums = [3, 3], target = 6

i=0: num=3,  comp=3.  seen={}              → insert {3: 0}
i=1: num=3,  comp=3.  seen={3:0}   3 ✓    → return [0, 1]
```

### Trace 3 — Sondan Match

```
nums = [3, 2, 4], target = 6

i=0: num=3,  comp=3.  seen={}              → insert {3: 0}
i=1: num=2,  comp=4.  seen={3:0}   4 ✗    → insert {3:0, 2:1}
i=2: num=4,  comp=2.  seen={3:0,2:1} 2 ✓ → return [1, 2]
```

### Trace 4 — Negatifler

```
nums = [-1, -2, -3, -4, -5], target = -8

i=0: num=-1, comp=-7. ✗ → insert {-1:0}
i=1: num=-2, comp=-6. ✗ → insert {-1:0, -2:1}
i=2: num=-3, comp=-5. ✗ → insert {..., -3:2}
i=3: num=-4, comp=-4. ✗ → insert {..., -4:3}
i=4: num=-5, comp=-3. seen[-3]=2 ✓ → return [2, 4]
```

---

## 6. Edge Cases Checklist

| Case | Beklenen | Karşılayan |
|------|----------|------------|
| Minimum boyut (n=2) | Çift döner | `[3, 3], 6` |
| Duplicate | Çalışır | `[3, 3], 6` |
| Baştan match | Çalışır | `[2, 7, ...], 9` |
| Sondan match | Çalışır | `[3, 2, 4], 6` |
| Negatif | Çalışır | `[-1, -2, ...], -8` |
| Target = 0, içinde sıfır | Çalışır | `[0, 4, 3, 0], 0` → `[0, 3]` |
| Çözüm yok | `[]` döner (defensive) | Problem çözüm garanti ediyor ama yine de |

---

## 7. Common Mistakes — Personal Record

Live seansta yaptığım hatalar. Bir sonraki hash-map probleminden önce gözden geçir.

### Mistake 1 — O(n²)'ye "Two Pointer" Demek

**Unsorted** array'de `high`'i aşağı, `low`'u yukarı oynayarak yapılan bir şeye "two pointer" dedim. Bu two-pointer değil — kılık değiştirmiş nested iteration, hâlâ O(n²).

**Kural:** Gerçek two-pointer **sorted** input (veya monotonic property) gerektirir. Array sorted değilse "two pointer" demek **kategori hatası**.

### Mistake 2 — Sözel Trace'i Atlamak

İlk verbal approach'ta somut bir örnek üzerinden gitmedim. Soyut açıklamalar mülakatçıyı kaybettirir.

**Kural:** Her sözel approach **en az bir** trace içerir (`[2, 7, 11, 15], target = 9` gibi). 30 saniye trace, çok büyük clarity sinyali kazandırır.

### Mistake 3 — Variable Naming (`storedNumber` vs `storedIndex`)

`dict[complement]`'ten gelen değere `storedNumber` ismini verdim. Ama dict `[value: index]` yapısında, dolayısıyla retrieve edilen değer **index'tir**, sayı değil. Bu return bug'ına yol açtı: `return [complement, index]` (yanlış) yerine `return [storedIndex, index]` (doğru).

**Kural:** Variable name **variable'ın ne tuttuğunu** ifade etmeli, etrafındaki kavramı değil. Dict index tutuyorsa, çıkan değer `storedIndex`'tir.

### Mistake 4 — Space Complexity Belirsizliği

"Space O(1) ya da O(n), emin değilim" dedim. Big O her zaman worst-case'dir (upper bound). Lucky case O(1) olsa bile cevap O(n)'dir.

**Kural:** Big O = worst case. Her zaman worst case'i söyle; best case'i ancak özellikle sorulduğunda dile getir.

### Mistake 5 — `dict[num] = 0` Typo

`index` yerine sabit `0` yazdım kısaca. Probe ile yakalandı.

**Kural:** Her dict insert öncesi sor: *"Sonra ne çekmek isterim?"* Cevap, value olarak yazılan şey.

---

## 8. Reusable Pattern — Hash Map Single-Pass

### Ne Zaman Uygula?

- **"Bir pair / complement / counterpart bul"** problemleri
- **"Bunu daha önce gördüm mü?"** sorgulamaları
- **O(n) hedef + O(n) space budget** durumları

### Pattern İskeleti

```swift
var seen: [Key: Value] = [:]
for (index, element) in collection.enumerated() {
    let needed = /* cevabı tamamlayacak şey nedir? */
    if let matchedIndex = seen[needed] {
        return /* matchedIndex + current index'i kullan */
    }
    seen[element] = index
}
```

### Bu İskeleti Kullanan İlgili Problemler

| Problem | Aranan | Dict Tuttuğu |
|---------|--------|--------------|
| Two Sum (this) | `target - num` | `[value: index]` |
| Contains Duplicate | `num`'un kendisi | `Set<value>` |
| Valid Anagram | character count'ları | `[Character: Int]` |
| Subarray Sum Equals K | `prefixSum - k` | `[prefixSum: count]` |
| First Unique Character | character count'ları | `[Character: Int]` |
| Group Anagrams | sorted key | `[String: [String]]` |

**Mental model:** *"Match bulmak için geriye mi bakıyorum? → Single-pass hash map."*

---

## 9. Follow-up Questions an Interviewer May Ask

Hazır ol — bunlar gerçek mülakatta Two Sum'dan sonra sıkça gelir.

### FU-1: "Array sorted olsaydı?"
Two-pointer'a geç, O(n) time, O(1) space. Kod yazmaya hazır ol.

### FU-2: "Birden fazla pair olabilir mi? Hepsini döndür."
Early exit yapamazsın. Tüm array'i tara. `seen[num]` artık `[Int: [Int]]` — her value'nun tüm index'lerini tutar.

### FU-3: "Üç sayı gerekirse (3Sum)?"
Sort + bir elemanı sabitle + kalanda two-pointer → O(n²). k-Sum ailesinin canonical pattern'i.

### FU-4: "Sayılar Int'e sığmıyorsa (overflow)?"
`Int.addingReportingOverflow` kullan veya `target - num` öncesinde `Int.min` / `Int.max` ile pre-check yap. Production'da, 64 bit aşıyorsa `BigInt` library tercih et.

### FU-5: "Memory çok kısıtlıysa?"
Sort + two-pointer, O(n log n) time, O(1) space (in-place sort + index preservation gerekmiyorsa — gerekiyorsa tuple için O(n) extra). Time'ı space için takas et.

### FU-6: "Unit test yazsan? Hangi case'ler?"
Yukarıdaki `Edge Cases Checklist`'e bak. Vurgu:
- Duplicate (`[3, 3], 6`)
- Negatif ve sıfır
- Minimum boyut (n=2)
- Boundary'lerde match (start, end)

### FU-7: "Production'da ne ters gidebilir?"
- Non-hashable key'ler (custom type'lar `Hashable` olmadan)
- Hash collision DoS (Swift'in randomized seed'i ile mitigate)
- Çok büyük input → memory pressure (O(n) space)

---

## 10. Mock Session Debrief

### What Went Well
- 3 Priority-1 clarifying question soruldu (sorted, negatif, duplicate).
- Scale sensitivity: n=10⁷'de O(n²) problemi fark edildi — staff-level sinyal.
- Brute-force complexity için Gauss toplamı türetildi.
- Complement insight'ı (küçük bir dürtüş ile) keşfedildi.
- Critical duplicate-handling subtlety (lookup before insert) yakalandı.
- Targeted probe'larla iki bug self-correct edildi.

### Needs Work
- **Two-pointer kategori hatası** — unsorted array'de önerildi. Forced değildi.
- **İlk approach'ta sözel trace yok**.
- **Naming refactor refleksi zayıf** — `storedNumber` ve `j` itirazsız geçti.
- **Space complexity belirsizliği** — "O(1) ya da O(n)" yerine net "O(n) worst case" demek lazım.
- **Bilinmiyordu**: Dictionary worst case = O(n) collision yüzünden.

### Internalize Edilecek Tek Kural
**"Verbal before code, trace before verbal."** Approach narrasyonun bir parçası olarak somut bir örneği anlat. Mülakatta en ucuz clarity sinyali.

---

## 11. Re-solve Protocol

Locking için:

1. **+1 gün:** 30-min passive review of this MD.
2. **+2 gün:** Sıfırdan çöz, notlara bakmadan, hedef ≤ 10 dk.
3. **+7 gün:** Warm-up recall sorusu: *"Hash-map single-pass pattern, ne zaman?"*
4. **+14 gün:** Tekrar çöz, hedef ≤ 7 dk.
5. **+1 ay:** Spaced repetition final check.

---

## References

- [LeetCode #1 — Two Sum](https://leetcode.com/problems/two-sum/)
- Blind 75 — Array & Hashing grubu
- NeetCode 150 — [Two Sum walkthrough](https://neetcode.io/problems/two-integer-sum)
- Swift stdlib: `Dictionary` subscript `Optional<Value>` döner
- Related: `0049-group-anagrams`, `0217-contains-duplicate`, `0560-subarray-sum-equals-k` (gelecek)
