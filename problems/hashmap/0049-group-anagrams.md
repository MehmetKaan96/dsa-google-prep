# LeetCode #49 — Group Anagrams

> **Zorluk:** Medium · **Konular:** Hash Table, String, Sorting · **Pattern:** Canonical key ile gruplama
> **Blind 75 / NeetCode 150:** ✅ Core problem

---

## 1. Problem Tanımı

String dizisi `strs` verildiğinde **anagram** olanları grupla.

**Örnek:**
```
Input:  ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]  (grup/iç sıra serbest)
```

**Constraints (klasik):**
| Constraint | Değer |
|------------|-------|
| `strs.length` | Genelde 1 … 10⁴ |
| Kelime uzunluğu | Sınırlı (ör. ≤ 100) |
| Karakterler | Sadece **lowercase English** |

---

## 2. Learning Arc — Bu Oturumdan Not

İlk denemede **“çift çift kıyas (nested loop)”** zihniyetiyle yaklaşmak doğal; bu problem aslında **Valid Anagram’ın çoklu versiyonu** değil — **equivalence class** problemi:

> Her string için **aynı aileye ait herkesin paylaştığı bir kimlik (key)** üret → `Dictionary` ile tek geçişte grupla.

Manuel örnek `["ab","ba","b","aab","baa"]` → sorted key’ler `ab`, `b`, `aab` ile grupların oturması, kavramın kalbidir.

---

## 3. Approach Evolution

### Approach — Brute (Pairwise / Grup inşası dağınık)

Her çift veya her string için diğerleriyle anagram kontrolü. Karmaşık ve pahalı.

- **Time:** Kabaca **O(n² · k log k)** (karşılaştırmada sort kullanılırsa) veya **O(n² · k)** (frequency ile)
- **Reject:** Gruplama için doğal API değil.

### Approach 1 — Sort Key (Default interview çözümü)

Her `s` için **`key = String(s.sorted())`**. Aynı anagram ailesi aynı key.

```swift
var groups: [String: [String]] = [:]
for s in strs {
    let key = String(s.sorted())
    groups[key, default: []].append(s)
}
return Array(groups.values)
```

- **Time:** **O(n · k log k)** — kelime başına sort
- **Space:** **O(n · k)** — tüm string’ler output’ta

### Approach 2 — Count Key (Optimal asimptotik)

`a`–`z` için 26’lık frequency vektörünü **delimiter’lı string** yap (collision yok):

- **Time:** **O(n · k)**
- **Space:** **O(n · k)**

---

## 4. Swift / API Notları

- **`dict[key, default: []].append(s)`** — `[default:]` subscript pattern’i Valid Anagram / Two Sum ailesiyle aynı.
- LeetCode fonksiyon adı: **`groupAnagrams`** (çoğul).

---

## 5. Test — Sıra Bağımsız Karşılaştırma

Swift `Dictionary` / `Array(groups.values)` **iteration order** garanti etmez. Test’te:

```swift
func normalizeGroups(_ groups: [[String]]) -> [[String]] {
    groups
        .map { $0.sorted() }
        .sorted {
            if $0.count != $1.count { return $0.count < $1.count }
            return $0.lexicographicallyPrecedes($1)
        }
}
```

---

## 6. Complexity

| Approach | Time | Space |
|----------|------|-------|
| Sort key | O(n · k log k) | O(n · k) |
| Count key | O(n · k) | O(n · k) |

---

## 7. Related

- `0242-valid-anagram` — iki string equivalence
- `0049` — çok string → **aynı key**
- Interview phrase: *“Canonical representation for hashing / grouping.”*

---

## References

- [LeetCode #49](https://leetcode.com/problems/group-anagrams/)
- Repo: [0049-group-anagrams.swift](./0049-group-anagrams.swift)
- iOS thread-safety bağlamı: [concurrency-gcd.md](../../ios-depth/concurrency-gcd.md)
