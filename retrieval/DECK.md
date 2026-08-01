# RETRIEVAL DECK — Active Recall Cards

> **Bu deck unutmayı yenen motordur.** Her seans başında [SCHEDULE.md](SCHEDULE.md)'de **due** olan konudan 3-5 kart çek, **önce cevabı görmeden** sözel yanıtla, sonra aç.
> Kural: pasif okuma değil, **aktif retrieval**. Yanlış/eksik cevap → o konu SCHEDULE'da bir kutu geri düşer (daha sık gelir).
> Kart eklerken: her yeni `concepts/NN-*.md` en az 5 kart ekler. Yeni çözülen her problem 1 "pattern" kartı ekler.

**Kart formatı:** `Q:` soru — `A:` cevap. Soruyu okuyunca dur, cevapla, sonra `A`'yı kontrol et.

---

## ARR — Array

**ARR-1** · Q: Array neden O(1) random access verir? — A: Contiguous memory; `base + i*stride` aritmetiğiyle adres doğrudan hesaplanır, arama yok.

**ARR-2** · Q: `append` amortized O(1) ama worst O(n) — neden ikisi de doğru? — A: Kapasite dolunca geometric growth (~2x) ile yeni buffer'a kopyalar (O(n)); bu nadir realloc n append'e yayılınca amortized O(1).

**ARR-3** · Q: `insert(at:)` ve `remove(at:)` neden O(n)? — A: Ortadaki elemanı ekle/sil → sonraki tüm elemanları bir kaydırmak gerekir.

**ARR-4** · Q: Swift'te Copy-on-Write ne zaman tetiklenir? — A: Assignment'ta değil; buffer paylaşımlıyken (`isKnownUniquelyReferenced == false`) **ilk mutation** anında. O maliyet O(n).

**ARR-5** · Q: `Array<T>` vs `ContiguousArray<T>` farkı? — A: `Array` Obj-C bridging destekler; `ContiguousArray` etmez, ~2x hızlı iteration.

**ARR-6** · Q: `ArraySlice`'ın gizli tuzağı? — A: Parent buffer'ı tamamen retain eder; slice uzun yaşarsa büyük buffer serbest kalmaz → memory leak.

**ARR-7** · Q: `arr[i]`'nin adresi nasıl hesaplanır ve neden O(1)? — A: `base + i×stride` (stride = eleman byte boyutu). Tek çarpma+toplama, doğrudan zıplar → `i`'den ve boyuttan bağımsız sabit. Adres = bellekteki byte index'i, sıradan bir sayı.

**ARR-8** · Q: insert(at:0) neden O(n) — "yeni dizi" yüzünden mi? — A: Hayır, **kaydırma** yüzünden: bitişiklik için sonraki tüm elemanlar bir sağa kayar (n kaydırma). Yeni dizi sadece kapasite doluysa gerekir (ayrı kavram: growth).

**ARR-9** · Q: append neden O(1) *amortized*, ve neden 2× büyüme kritik? — A: Dolunca 2× büyüt+kopyala; kopyalar 1+2+4+…≈2n → n append'e bölününce sabit. `+1` büyüseydi 1+2+…+n=O(n²) → append başı O(n).

---

## HASH — HashTable (Dictionary / Set)

**HASH-1** · Q: Hash table lookup arka planda nasıl O(1)? — A: `hash(key) % capacity` → bucket index doğrudan; doğru bucket'a atlar, tüm yapıyı taramaz.

**HASH-2** · Q: Lookup worst case neden O(n)? — A: Tüm key'ler aynı bucket'a düşerse (collision) o bucket linear taranır.

**HASH-3** · Q: Load factor nedir, ne işe yarar? — A: α = count/capacity; ~0.75'te rehash tetiklenir (O(n)) — collision oranını düşük tutmak için.

**HASH-4** · Q: Swift Dictionary neden pratikte hep O(1)? — A: Process başına randomized SipHash seed; saldırgan tek-bucket input craft edemez (HashDoS koruması).

**HASH-5** · Q: `Set` mi `Dictionary` mi — nasıl seçersin? — A: Yanında veri (index/count/payload) lazımsa Dictionary; sadece "var mı?" ise Set. *"If I need associated data I use Dictionary, else Set."*

**HASH-6** · Q: Hashable contract'ı? — A: `a == b ⇒ a.hashValue == b.hashValue` (tersi gerekmez). İhlal edilirse lookup bozulur.

**HASH-7** · Q: `Dictionary<T, Void>` ile Set simüle etmek neden anti-pattern? — A: `Set<T>` first-class, kendi optimizasyonlarına sahip; en spesifik tool'u kullan.

---

## PAT — Pattern tanıma (problemden algoritmaya)

**PAT-1** · Q: "pair / complement / bunu gördüm mü?" → ? — A: Hash map / Set, tek geçiş O(n).

**PAT-2** · Q: "sorted array" + ara → ? — A: Binary search (O(log n)) veya two pointers.

**PAT-3** · Q: "top K elements" → ? — A: Size-K heap, O(n log k) — full sort gereksiz.

**PAT-4** · Q: "contiguous subarray + optimize" → ? — A: Sliding window, O(n²)→O(n).

**PAT-5** · Q: "all subsets/permutations/combinations üret" → ? — A: Backtracking (karar ağacı, geri al).

**PAT-6** · Q: n ≤ 20 constraint'i ne fısıldar? — A: Exponential kabul edilebilir → bitmask / backtracking.

**PAT-7** · Q: n ≤ 10⁵ ise hedef complexity? — A: O(n log n) veya daha iyi; O(n²) (10¹⁰) çok yavaş.

---

## PROB — Çözülen problemler (pattern kartı)

**PROB-0001** · Q: Two Sum — pattern ve neden lookup-before-insert? — A: Hash single-pass `[value:index]`; önce complement'i ara sonra ekle → same-index koruması + duplicate handling bedava.

**PROB-0217** · Q: Contains Duplicate — neden Set, neden Dictionary değil? — A: Sadece "var mı" lazım, associated data yok → `Set<Int>` minimal doğru seçim.

**PROB-0242** · Q: Valid Anagram — veri yapısı? — A: `[Character: Int]` count map; artır-sonra-azalt veya iki map karşılaştır.

**PROB-0049** · Q: Group Anagrams — key nasıl seçilir? — A: Sorted string (veya char-count imzası) canonical key; `[String: [String]]` ile grupla.

---

## Nasıl büyütülür
- Yeni `concepts/NN-*.md` işlendiğinde → yeni `PREFIX-n` bölümü aç, ≥5 kart.
- Yeni problem çözülünce → `PROB-NNNN` kartı ekle (pattern + kritik insight).
- Kart **kısa** olmalı: bir soru, bir çekirdek cevap. Ansiklopedi değil, tetikleyici.
