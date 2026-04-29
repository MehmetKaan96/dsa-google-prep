# HashTable (Dictionary / Set)

> **Tam deep-dive:** `DSA.playground/Pages/02-HashTable.xcplaygroundpage/Contents.swift`
> Bu dosya hızlı referans özetidir.

## TL;DR

Hash table = bucket'lardan oluşan bir array + hash function. Key, `hash(key) % capacity` formülü ile bir bucket index'ine map'lenir. Average O(1) operasyonlar, ama collision durumunda worst case O(n).

## Temel Invariant'lar

- Hashable contract: `a == b ⇒ a.hashValue == b.hashValue` (tersi gerekmez)
- Aynı instance içinde deterministic (process başına randomized seed — HashDoS koruması)
- Load factor α = count / capacity — tipik olarak α ≈ 0.75'te rehash
- Duplicate key olmaz

## Big O

| Operation | Average | Worst |
|-----------|---------|-------|
| `dict[key]` lookup | O(1) | O(n) |
| `dict[key] = v` insert | O(1) amortized | O(n) rehash |
| `removeValue(forKey:)` | O(1) | O(n) |
| `contains` | O(1) | O(n) |
| iteration | O(n + capacity) | |
| CoW copy (ilk mutation) | O(n) | |

## Swift'e Özgü

- `Dictionary` **open addressing** + SipHash + randomized seed kullanır
- `Set<T>` aslında `Dictionary<T, Void>`'a çok benzer ama ayrı bir first-class type
- Value type; heap'teki `ManagedBuffer` üzerinde CoW
- Iteration order tanımsız ve runlar arasında değişebilir
- Hash value'lar persistable **değildir** (seed her process başlangıcında değişir)
- Auto-synthesize: tüm stored property'ler `Hashable` ise compiler `hash(into:)` yazar

## Collision Resolution

| Strateji | Açıklama | Pros / Cons |
|----------|----------|-------------|
| Separate chaining | Her bucket bir liste tutar | Delete kolay; pointer chasing cache'i bozar |
| Linear probing | Collision'da bir sonraki slot | Cache-friendly; primary clustering |
| Quadratic probing | `i*i` offset | Clustering azalır; secondary clustering kalır |
| Double hashing | Step için ikinci hash | En iyi distribution; en karmaşık |

## Karar Motoru

✅ Kullan:
- Key-based lookup
- Frequency counting
- Caching / memoization
- Deduplication (Set)
- Graph adjacency

❌ Kaçın:
- Ordered iteration gerekiyor
- Range query gerekiyor
- Positional access gerekiyor
- Hard real-time (worst case O(n) kabul edilemez)
- Çok küçük N (<10) — linear scan genelde daha hızlı

## Set vs Dictionary — Hangisi Ne Zaman?

İkisi de hash-based, ikisi de average O(1). Seçim **match bulunduğunda hangi veriye ihtiyacın olduğuna** bağlı.

| İhtiyaç | Tercih |
|---------|--------|
| Sadece "var mı? evet/hayır" | `Set<T>` |
| "Var mı? Varsa index/count/payload getir" | `Dictionary<T, Data>` |

### Ezberlenecek Cümle (interview-ready)

> *"If I need associated data per element (index, count, payload), I use Dictionary. If I only need membership testing, Set is the minimal correct choice."*

### Somut Örnekler

| Problem | Tercih | Neden |
|---------|--------|-------|
| Two Sum (LC #1) | `[Int: Int]` | Complement'in **index'ini** döndürmek lazım |
| Contains Duplicate (LC #217) | `Set<Int>` | Sadece evet/hayır — associated data yok |
| Valid Anagram (LC #242) | `[Character: Int]` | Karakter başı **count** lazım |
| Longest Consecutive Sequence (LC #128) | `Set<Int>` | Boundary check için O(1) membership lazım |
| Group Anagrams (LC #49) | `[String: [String]]` | Canonical key'e göre **gruplamak** lazım |

### Senior Sinyali

> *"Swift'te `Set` simüle etmek için `Dictionary<T, Void>` kullanmak anti-pattern'dir — `Set<T>` kendi optimizasyonlarına sahip first-class bir type. İşin için en spesifik tool'u kullan."*

## Senior Sinyalleri / Bilinmesi Gereken Terimler

- Load factor (α)
- Collision resolution (chaining / linear / quadratic / double hashing)
- Primary & secondary clustering
- Tombstone deletion
- Rehashing / resize storm
- HashDoS / algorithmic complexity attack
- SipHash / randomized hashing
- Hashable contract / hash-equals invariant
- Open addressing vs separate chaining

## Yaygın Mülakat Problemleri

- [ ] Two Sum (Easy)
- [ ] Valid Anagram (Easy)
- [ ] Contains Duplicate (Easy)
- [ ] Group Anagrams (Medium)
- [ ] Top K Frequent Elements (Medium)
- [ ] Longest Consecutive Sequence (Medium)
- [ ] Subarray Sum Equals K (Medium)
- [ ] LRU Cache (Medium) — hash + doubly linked list
- [ ] LFU Cache (Hard)
