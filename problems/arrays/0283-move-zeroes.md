# LeetCode #283 — Move Zeroes

> **Zorluk:** Easy · **Konular:** Array, Two Pointers · **Pattern:** In-place write-pointer (compaction)
> **Blind 75 / NeetCode 150:** Two Pointers / Array grubu · **Çözüm tarihi:** 2026-08-01 (guided, Format B)

---

## 1. Problem Tanımı

Bir integer array `nums` verildiğinde, tüm `0`'ları dizinin **sonuna** taşı; non-zero elemanların **göreli sırası korunsun**. **In-place** yapılmalı — dizinin kopyası çıkarılamaz.

**Örnek:**
```
Input:  [0, 1, 0, 3, 12]
Output: [1, 3, 12, 0, 0]
```

**Constraint teyidi:**
| Constraint | Cevap | Etki |
|------------|-------|------|
| In-place mi? | **Evet** (prompt veriyor) | Kopyalama çözümünü eler → O(1) space |
| Sıra korunacak mı? | **Evet** (prompt veriyor) | İki-uçtan swap'i eler → stable yaklaşım |
| Write minimize? | Belirtilmemiş → sorulur | Follow-up: swap versiyonu |
| Boş / hepsi sıfır / hepsi non-zero? | Evet | Algoritma bedava halleder |

---

## 2. Clarifying Questions

**Refleks:** Prompt'ta verilen kısıtı (in-place, sıra) **soru olarak sorma** — "okumadım" sinyali. Bunun yerine **implikasyonunu** verbalize et: *"In-place + sıra-korumalı diyor, o yüzden O(1) space + stable hedefliyorum, kopyalama çözümünü eliyorum."*

Gerçekten sorulacaklar (prompt'ta **olmayan**):
- Write sayısını minimize etmeli miyim? (→ swap follow-up)
- `nums` ne kadar büyük olabilir? (scale → hedef complexity)

Edge case'ler (Priority 3, sona): boş, hepsi sıfır, hepsi non-zero.

---

## 3. Approach Evolution

### Approach 1 — Brute force: `remove` + `append` (REJECT)

Bir `0` görünce diziden sil, sona `0` ekle.

```swift
for num in nums {
    if num == 0 {
        if let idx = nums.firstIndex(of: 0) { nums.remove(at: idx) }
        nums.append(0)
    }
}
```

- **Time:** O(n²) — `firstIndex` O(n) **+** `remove(at:)` O(n) (kaydırma), ikisi de döngü içinde.
- **Space:** O(1)
- **Reject sebebi:** Döngü içindeki her `remove`/`firstIndex`/`contains` gizli bir O(n)'dir. Ayrıca **diziyi iterate ederken değiştirmek** (mutate-while-iterating) kaygan/bug'lı.

### Approach 2 — Two-pointer write index (OPTIMAL)

**Yeniden çerçeveleme:** "Sıfırları sona taşı" değil → **"non-zero'ları öne kompakla, sonra kuyruğu sıfırla doldur."** Sıfırlar bir yan üründür; hiçbir şeyi kaydırmıyoruz.

```swift
func moveZeroes(_ nums: inout [Int]) {
    var slow = 0                          // bir sonraki non-zero'nun yeri
    for i in 0..<nums.count {
        if nums[i] != 0 {
            nums[slow] = nums[i]
            slow += 1
        }
    }
    for i in slow..<nums.count { nums[i] = 0 }
}
```

- **Time:** O(n) — iki pass = 2n
- **Space:** O(1)
- **Neden kazanır:** Kaydırma tamamen elendi; sadece O(1) index erişimi.

### Approach 3 — Tek-pass swap (write'ları minimize eder)

```swift
func moveZeroes(_ nums: inout [Int]) {
    var slow = 0
    for fast in 0..<nums.count where nums[fast] != 0 {
        nums.swapAt(slow, fast)
        slow += 1
    }
}
```

- **Time:** O(n) tek pass · **Space:** O(1) · sıra korunur, gereksiz yazma yok.
- "Minimize writes?" follow-up'ının cevabı.

---

## 4. Complexity Analysis

| Yaklaşım | Time | Space |
|----------|------|-------|
| Brute (remove+append) | O(n²) | O(1) |
| Two-pointer (compact+fill) | O(n) | O(1) |
| Tek-pass swap | O(n) | O(1) |

---

## 5. Trace Walkthrough — Approach 2

```
nums = [0, 1, 0, 3, 12]

Pass 1 (compact):  slow=0
i=0: 0  → skip
i=1: 1  → nums[0]=1, slow=1        [1, 1, 0, 3, 12]
i=2: 0  → skip
i=3: 3  → nums[1]=3, slow=2        [1, 3, 0, 3, 12]
i=4: 12 → nums[2]=12, slow=3       [1, 3, 12, 3, 12]

Pass 2 (fill from slow=3):
i=3 → 0                             [1, 3, 12, 0, 12]
i=4 → 0                             [1, 3, 12, 0, 0]   ✓
```

---

## 6. Edge Cases — algoritma bedava halleder

| Case | Sonuç | Neden |
|------|-------|-------|
| `[]` | `[]` | İki döngü de çalışmaz |
| `[0,0,0]` | `[0,0,0]` | slow=0 kalır; Pass 2 hepsini 0 yapar |
| `[1,2,3]` | `[1,2,3]` | slow=3; Pass 2 `3..<3` boş |
| `[5]` / `[0]` | aynen | trivial |

**Ders:** Guard clause (`if nums.isEmpty { return }`) **gereksiz** — over-engineering. Sağlam algoritma edge'leri doğal yer.

---

## 7. Common Mistakes — Personal Record

### Mistake 1 — `remove(at:i)` / `arr[i]` karışıklığı
`remove(at:i)`'yi O(1) sandım ("adres direkt bulunur"). Ama **pozisyonu bulmak** O(1); **silmek** sonraki elemanları kaydırır → **O(n)**. `insert(at:0)`'ın aynadaki hali.
**Kural:** `arr[i]` erişim = O(1); `insert`/`remove` = O(n) (shift). İkisi de index kullanır ama biri hareket ettirir.

### Mistake 2 — Döngü içindeki gizli O(n)
`firstIndex`/`contains`/`remove`/`insert` döngü içinde → toplam O(n²). "Dış döngü O(n), o yüzden O(n)" yanılgısı; iç işlemin maliyetini say.

### Mistake 3 — Mutate-while-iterating
`for num in nums` sürerken `nums`'ı değiştirmek (remove/append) → kaygan davranış. Diziyi gezerken yapısını bozma.

### Mistake 4 — `append` ≠ in-place
Sıfırları `append` etmek diziyi büyütür → in-place kısıtını bozar. Doğrusu: kuyruğu **yerinde overwrite** (`nums[i] = 0`).

### Mistake 5 — Gereksiz koşul
Pass 2'de `if nums[i] != 0 { nums[i] = 0 }` — koşul anlamsız, doğrudan `nums[i] = 0`.

---

## 8. Reusable Pattern — In-place write-pointer (compaction)

**Ne zaman:** "Bazı elemanları in-place filtrele/öne taşı, sırayı koru, O(1) space" problemleri.

```swift
var slow = 0
for fast in 0..<nums.count {
    if keep(nums[fast]) {          // tutma koşulu
        nums[slow] = nums[fast]    // (veya swapAt)
        slow += 1
    }
}
// gerekirse slow..<count'u temizle/doldur
```

**Kardeş problemler:** Remove Element (27), Remove Duplicates from Sorted Array (26), Move Zeroes (bu). Hepsi: `slow` = "geçerli sonucun bir sonraki yazma yeri".

---

## 9. Follow-up Questions

- **"Write'ları minimize et"** → Approach 3 (swap): sadece gerektiğinde yaz.
- **"Sıfırları başa taşı"** → sağdan sola aynı pattern.
- **"Sıra önemli değilse"** → iki-uçtan: sondan bir non-zero'yu sıfırın yerine at (daha az yazma, unstable).
- **"Non-zero yerine keyfi predicate"** → aynı write-pointer iskeleti (`keep(...)`).

---

## 10. Mock Debrief

**İyi giden:** Optimal mantığı (compact + fill) sözel olarak kendim türettim. Brute force'un O(n²)'sini kaydırma bağlantısıyla çıkardım. Edge case'lerin bedava hallolduğunu trace ile gördüm.

**Needs work:** İlk kod denememde reddettiğimiz brute force'a geri döndüm (`remove`/`firstIndex`) ve O(n) sandım — döngü içi O(n)'i saymayı unuttum. Pattern: **"koda geçince mantığı bırakıp alışkanlığa dönme."** Yazmadan önce türettiğim yaklaşımı sabitlе.

**Internalize:** Döngü içindeki `remove`/`firstIndex`/`contains` = gizli O(n). Ve `arr[i]` (O(1)) ≠ `remove/insert` (O(n)).

---

## 11. Re-solve Protocol

1. **+1 gün:** Bu MD'yi 5 dk pasif review.
2. **+3 gün:** Sıfırdan çöz, notsuz, hedef ≤ 8 dk. Hem compact+fill hem swap versiyonu.
3. **+1 hafta:** Warm-up: "In-place write-pointer pattern ne zaman?"
4. **+2 hafta:** Tekrar çöz, hedef ≤ 5 dk.

---

## References
- [LeetCode #283 — Move Zeroes](https://leetcode.com/problems/move-zeroes/)
- Pattern: `concepts/00-PATTERN-TRIGGERS.md` (in-place two-pointer)
- Mekanik: `concepts/01-array.md` (shift = O(n), access = O(1))
- Related: `0026-remove-duplicates`, `0027-remove-element` (gelecek)
