# HashTable (Dictionary / Set)

> **Tam deep-dive:** `DSA.playground/Pages/02-HashTable.xcplaygroundpage/Contents.swift`
> Bu dosya hızlı referans özetidir.

## TL;DR

Hash table = bucket'lardan oluşan bir array + hash function. Key, `hash(key) % capacity` formülü ile bir bucket index'ine map'lenir. Average O(1) operasyonlar, ama collision durumunda worst case O(n).

## Mekanik (Under the Hood) — türet, ezberleme

HashTable = **bucket dizisi + hash fonksiyonu.** Altında yine bir array var.

- **Lookup `dict[key]` → O(1) ortalama:** `index = hash(key) % capacity`. Hash devasa bir sayı üretir; `% capacity` onu geçerli bir bucket index'ine (`0..capacity-1`) **katlar**. Sonra doğrudan o bucket'a zıpla — taramaz. Array'in `base + i×stride`'ının karşılığı: ikisi de "index'i hesapla, doğrudan git".
  - Kapasite genelde 2'nin kuvveti → `% 2^k` hızlı bit işlemine (`hash & (capacity-1)`) iner.
- **Collision (iki key aynı index'e düşer):** iki çözüm —
  - *Separate chaining:* bucket bir **liste** tutar (`5 → [cat, dog]`).
  - *Open addressing (Swift `Dictionary`):* bir sonraki **boş** slota probe et (`5→cat, 6→dog`).
- **Worst case → O(n) (O(n²) değil):** Tüm key'ler tek bucket'a düşerse, tek bir lookup o `n`-elemanlı zinciri baştan sona tarar → `n` karşılaştırma → O(n). (O(n²) ancak `n` ayrı arama × her biri O(n) yapılırsa.)
- **Load factor α = count / capacity → rehash:** α yükseldikçe collision artar (dolu slota düşme olasılığı ↑). α > ~0.75 olunca **rehash**: 2× büyük bucket dizisi ayır, **tüm** key'leri `hash % yeni_capacity` ile yeniden yerleştir. O(n) tek sefer, seyrek → **amortized O(1)** — **Array growth'un birebir aynısı.**

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
- [x] Group Anagrams (Medium)
- [ ] Top K Frequent Elements (Medium)
- [ ] Longest Consecutive Sequence (Medium)
- [ ] Subarray Sum Equals K (Medium)
- [ ] LRU Cache (Medium) — hash + doubly linked list
- [ ] LFU Cache (Hard)
