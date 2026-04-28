# LeetCode #242 — Valid Anagram

> **Zorluk:** Easy · **Konular:** Hash Table, Sorting, String · **Pattern:** Frequency map + decrement
> **Blind 75 / NeetCode 150:** ✅ Core problem

---

## 1. Problem Tanımı

İki string `s` ve `t` verildiğinde, eğer `t` `s`'nin bir **anagram'ı** ise `true`, değilse `false` döndür.

Bir **anagram**, başka bir string'in harflerinin yeniden düzenlenmesiyle oluşturulan, orijinal harflerin hepsini tam bir kez kullanan kelimedir.

**Örnekler:**
```
s = "anagram", t = "nagaram"   → true
s = "rat",     t = "car"        → false
```

**Constraints:**
| Constraint | Değer |
|------------|-------|
| Length | 1 ≤ s.length, t.length ≤ 5 × 10⁴ |
| Karakter seti | Sadece lowercase English letters |

**Follow-up:** Input'lar Unicode karakter içerseydi, çözümü nasıl adapte ederdin?

---

## 2. Clarifying Questions — Kalibrasyon

Easy problem ve constraints açık. **1-2 soru** doğru miktar, daha fazlası anti-signal.

**Priority 1 — Sorulması Gereken**
- `s` ve `t` aynı uzunlukta gelecek mi garanti? → Hayır, farklı olabilir varsayımıyla ilerle. *Bu erken false optimization fırsatı verir.*

**Priority 2 — Constraints Kapsanmış**
- Boş gelir mi? → Hayır, min length = 1.
- Hangi karakterler? → Lowercase English (constraints).
- Unicode? → Constraint'te yok, **ama follow-up sordu** — Unicode-safe olarak düşün.

**Priority 3 — Opsiyonel**
- Memory budget kısıtı var mı? → Sort vs Hash seçimini etkiler.
- Performans hedefi? → 5×10⁴ length'te O(n) ile O(n log n) farkı pratik olarak hissedilir.

### Senior Refleks
Constraints'ten okunabilen sorulardan kaçın. Asıl sorular **belirsiz olanları**: length eşitliği, Unicode handling, modify-in-place izni gibi.

---

## 3. Approach Evolution

### Approach 1 — Brute Force (Reject)

Her `s[i]` için `t`'de eşleşen ilk karakter'i bul, sil. n iterasyon × O(n) silme = O(n²). 

- **Reject:** Easy seviyede bile bu kabul edilmez. Sort + Hash arasında trade-off yapılır.

### Approach 2 — Sort + Equality

Her iki string'i sort et, sonuç eşit mi karşılaştır.

```swift
return s.sorted() == t.sorted()
```

- **Time:** O(n log n) — sort dominate eder
- **Space:** O(n) — Swift sort copy yapar
- **Avantaj:** 1 satır, okunaklı, Unicode-safe (Character comparison'a güvenir)
- **Dezavantaj:** Hash'ten yavaş, büyük input'larda fark hissedilir

### Approach 3 — Frequency Map (Hash Map, OPTIMAL)

`s`'den frequency map oluştur (`[Character: Int]`). `t`'yi gez, her karakter için count'u decrement et. Decrement edemediğin (varolmayan veya 0 olan) bir karakter görürsen → `false`.

```swift
guard s.count == t.count else { return false }

var dict: [Character: Int] = [:]
for char in s {
    dict[char, default: 0] += 1
}

for char in t {
    guard let c = dict[char], c > 0 else { return false }
    dict[char] = c - 1
}

return true
```

- **Time:** O(n) — iki tek-geçişli loop
- **Space:** O(n) — dict en kötü n entry'ye kadar büyür (pratikte ≤ 26 lowercase için sabit, ama generic durumda n)

### Mental Model — "Ticket / Decrement"

> *"İlk string'de her karakter için bir TICKET veriyorum. İkinci string'de her karakter için TICKET tüketiyorum. Ticket biterse → false. Hepsi tüketilirse → true."*

Bu pattern adı **frequency map + decrement**. Anagram, palindrome permutation, character matching problemlerinin **standart kalıbı**.

---

## 4. Sort vs HashMap — Trade-off

| Boyut | Sort | HashMap |
|-------|------|---------|
| Time | O(n log n) | O(n) |
| Space | O(n) | O(n) — pratikte O(k), k = unique char |
| Code length | 1 satır | ~10 satır |
| Readability | Çok yüksek | Yüksek |
| Unicode-safe | ✓ | ✓ (Character tipi) |
| n = 5×10⁴ pratik fark | hissedilir | en hızlı |

**Mülakatta:**
- Sort'u **alternative olarak söyle** — Approach awareness sinyali
- HashMap'i **pick et** — optimal complexity
- "n çok küçükse sort daha pragmatik (compact code)" diyebilmek senior refleks

---

## 5. Complexity Analysis

| Metric | HashMap | Sort |
|--------|---------|------|
| Time (avg) | O(n) | O(n log n) |
| Time (worst) | O(n²) — hash collision teorik | O(n log n) |
| Space | O(n) | O(n) |

Swift Dictionary'nin **randomized hash seed**'i pratik durumda O(n)'i güvenli kılar (HashDoS koruması).

---

## 6. Trace Walkthrough — HashMap

### Trace 1 — Happy path (anagram)
```
s = "anagram", t = "nagaram"

Build dict from s:
  a → 3, n → 1, g → 1, r → 1, m → 1

Process t:
  n → dict[n]=1>0 → 0
  a → dict[a]=3>0 → 2
  g → dict[g]=1>0 → 0
  a → dict[a]=2>0 → 1
  r → dict[r]=1>0 → 0
  a → dict[a]=1>0 → 0
  m → dict[m]=1>0 → 0

return true ✓
```

### Trace 2 — Length mismatch (early false)
```
s = "ab", t = "abc"

count check: 2 != 3 → return false ✓
(dict bile yapılmadı)
```

### Trace 3 — Karakter mismatch
```
s = "rat", t = "car"

dict from s: r→1, a→1, t→1

Process t:
  c → dict[c] = nil → return false ✓
```

---

## 7. Edge Cases Checklist

| Case | Expected | Notes |
|------|----------|-------|
| Same string | `true` | Self-anagram |
| Length mismatch | `false` | Erken çıkış, dict atlanır |
| Tek karakter aynı | `true` | "a" / "a" |
| Tek karakter farklı | `false` | "a" / "b" |
| Tüm karakterler farklı | `false` | "abc" / "xyz" |
| Permütasyon (klasik) | `true` | "listen" / "silent" |
| Repeated characters | Çalışır | "aab" / "aba" → true; "aab" / "abb" → false |
| Unicode (follow-up) | Character tipi safe | "résumé" / "ésurmé" → true |
| Max size (5×10⁴) | O(n), fine | Hash fast, sort slower |

---

## 8. Common Mistakes — Personal Record

Live'da çıkan ve ileride yapma riski olan hatalar.

### Mistake 1 — Length Check'i Unutmak

İlk pseudocode'da length check yoktu — sadece dict build ediliyordu.

```swift
❌  for char in s { ... }      // farklı uzunluk durumunda yanlış sonuç riski
✅  guard s.count == t.count else { return false }
    for char in s { ... }
```

**Kural:** Anagram tanımı gereği aynı uzunluk şart. **İlk satır = length guard**. Hem correctness hem performance.

### Mistake 2 — Subscript Default Syntax Hatası

İlk yazımda:
```swift
❌  dict[char: default: 0] += 1   // YANLIŞ syntax
```

Doğrusu:
```swift
✅  dict[char, default: 0] += 1
```

**Kural:** Swift dictionary subscript with default → **virgül** ayraç, `default:` argument label.

### Mistake 3 — `[String: Int]` Demek

Verbal olarak "[String: Int]" dedim. Swift'te tek karakter `Character` tipi, `String` değil. `for char in s` döngüsünde `char` zaten `Character`.

```swift
❌  var dict: [String: Int] = [:]
✅  var dict: [Character: Int] = [:]
```

**Kural:** Single character için `Character`, sequence için `String`. Tip karışıklığı = bug.

### Mistake 4 — Decrement Step Eksikliği

İlk pseudocode'da "t'de char varsa atla" gibi yarım bir mantıktı — gerçek decrement (count tüketme) yok.

```swift
❌  for char in t {
        if dict[char] varsa atla            // count azalmıyor!
    }
```

`s = "aab"`, `t = "abb"` durumunda her ikisinde de `a` ve `b` var, ama count'lar farklı. Decrement etmezsen yanlış sonuç gelir.

**Kural:** Anagram = **count match**, sadece **char match** değil. Her t karakteri bir s "ticket"'ı **tüketmek** zorunda.

---

## 9. Reusable Pattern Reference

### Pattern Adı: Frequency Map + Decrement

İskelet:
```swift
guard collection1.count == collection2.count else { return /* mismatch */ }

var counts: [Element: Int] = [:]
for item in collection1 {
    counts[item, default: 0] += 1
}

for item in collection2 {
    guard let c = counts[item], c > 0 else { return /* mismatch */ }
    counts[item] = c - 1
}

return /* match */
```

**Mental model:** *"İlk koleksiyondan ticket dağıt, ikinci koleksiyonda tüket. Ticket eksiği veya fazlası → mismatch."*

### Direct Cousins (Aynı Pattern Family)

| Problem | Twist |
|---------|-------|
| #242 Valid Anagram (this) | Klasik frequency match |
| #383 Ransom Note | "ransom" karakterleri "magazine"'da var mı (bir yön) |
| #49 Group Anagrams | Anagram olanları grupla — canonical key (sorted str veya count signature) |
| #438 Find All Anagrams in a String | Sliding window + frequency match |
| #567 Permutation in String | Sliding window + frequency match (yine) |

### Variants (Pattern Mutations)

- **Tek-yön ticket check (Ransom Note):** `s.count >= t.count` yetebilir, decrement yine var.
- **Sliding window'da:** Window'da bir char ekle, bir char çıkar — count map'i incremental olarak güncelle. O(n) toplam.

---

## 10. Follow-up Questions an Interviewer May Ask

### FU-1: "Input Unicode olursa nasıl adapte edersin?"

Algoritma değişmez — `[Character: Int]` Swift'te zaten Unicode-safe. `Character` Unicode grapheme cluster'ı temsil eder, "é" gibi accented karakterler veya emoji'ler doğru karşılaştırılır. **Sort versiyonu da safe** (Character comparison Unicode-aware).

**Eğer ASCII assumption yapacaksan** (sadece a-z, 26 char) → `Array(repeating: 0, count: 26)` ile sabit space optimize edilebilir. Ama bu **Unicode'u kırar** — sadece input ASCII garantili ise yapılır.

### FU-2: "Sabit space ile çözebilir misin?"

Evet, sadece lowercase English varsayımı altında: 26 elemanlı array. Space O(1) (sabit 26).

```swift
var counts = [Int](repeating: 0, count: 26)
let aValue = Int(Character("a").asciiValue!)
for char in s { counts[Int(char.asciiValue!) - aValue] += 1 }
for char in t {
    let i = Int(char.asciiValue!) - aValue
    counts[i] -= 1
    if counts[i] < 0 { return false }
}
return true
```

**Trade-off:** O(1) space ama **Unicode'u kıracak**. Constraint'e bak.

### FU-3: "Çok büyük string (10⁹ karakter) için ne yapardın?"

Streaming: tek geçişle her iki stream'i parallel oku, count'u tut. Memory dictionary'e dayanıyor — eğer karakter çeşidi az ise O(k) (k = unique char). Eğer her karakter farklı olabilirse → distributed sort + merge.

### FU-4: "Bu problemi UTF-16 surrogate pair'leriyle test etsem ne olur?"

`String.sorted()` ve `Character` collection iteration **grapheme cluster** seviyesinde çalışır, surrogate pair'leri bir bütün olarak ele alır. Algoritma değişmeden çalışır.

### FU-5: "Multiple comparisons (n string'in birbiriyle anagram olup olmadığı) sorulsaydı?"

Her string için **canonical form** üret (sorted string veya count signature), aynı canonical'a denk gelenler grupla. **#49 Group Anagrams** problemi tam bu.

### FU-6: "Test cases yazsan?"

- Klasik anagram: "listen"/"silent" → true
- Length mismatch: "abc"/"abcd" → false
- Aynı string: "abc"/"abc" → true
- Boş (constraint'in dışında, defensive): handle veya reject?
- Tek karakter: "a"/"a", "a"/"b"
- Tüm aynı karakter: "aaaa"/"aaaa" → true; "aaaa"/"aaab" → false
- Repeated patterns: "aabb"/"abab" → true; "aabb"/"abbb" → false
- Max size (5×10⁴) — perf test
- Unicode (follow-up): "résumé"/"ésurmé"

---

## 11. Mock Session Debrief

### What Went Well
- Length check refleksi sort approach'ta vardı (yarın hatırlamak için pekiştirildi).
- Two Sum'dan hash map pattern'ini transfer ettin — **learning transfer kanıtı**.
- Hint istedin ama syntax level'da, algoritma'yı kendin çıkardın.
- `class Solution` wrapper convention'ı doğal hatırlandı.
- İki approach arasındaki trade-off'u söyledin (Sort vs Hash).

### Needs Work
- **Length check'i hashmap version'da unuttun**: sort'ta hatırladın, hash'te kayıp. **Tüm string-pair problemlerinde** ilk satır olmalı.
- **Subscript default syntax**: `dict[char, default: 0]` — virgül kullanımı pekişti, ama tekrar görmek lazım.
- **Cold solo'da "neden hashmap optimal" cevabı boştu**: Trade-off cümlesini `*sort O(n log n) vs hash O(n)*` şeklinde refleks edinmeli.
- **Edge cases**: 2 verdin (Unicode, length mismatch), daha pratik olanlar (repeated chars, single char) atlandı.

### One Rule to Internalize
**"İki koleksiyon karşılaştırılan her problemde ilk satır length guard'ıdır."**

Anagram, palindrome check, two-string equality, two-array intersection — hepsi aynı kural. Length farklıysa **anlamsız bir compute** yapmadan dön.

---

## 12. Re-solve Protocol

1. **+1 gün:** 30-min passive review of this MD.
2. **+2 gün:** Sıfırdan çöz, notlara bakmadan, hedef ≤ 5 dk (Easy).
3. **+7 gün:** Recall question — *"Anagram → hangi pattern? Trade-off Sort vs Hash?"*
4. **+14 gün:** Re-solve with `Group Anagrams` (#49) prep.
5. **+1 ay:** Spaced repetition final.

---

## References

- [LeetCode #242](https://leetcode.com/problems/valid-anagram/)
- Pattern doc: [`0001-two-sum.md`](./0001-two-sum.md), [`0217-contains-duplicate.md`](./0217-contains-duplicate.md)
- Swift `Dictionary` subscript with default — [Apple Docs](https://developer.apple.com/documentation/swift/dictionary/subscript(_:default:))
- Related: `0383-ransom-note`, `0049-group-anagrams` (next), `0438-find-all-anagrams`
