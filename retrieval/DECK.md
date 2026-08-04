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

**HASH-8** · Q: `dict[key]` arka planda nasıl doğru bucket'a gidiyor? — A: `index = hash(key) % capacity`. Hash büyük sayıyı üretir, `% capacity` geçerli bucket index'ine katlar; doğrudan zıplar, taramaz. (Array'in `base + i×stride` karşılığı.)

**HASH-9** · Q: Collision nasıl çözülür ve worst case erişim ne? — A: Chaining (bucket'ta liste) veya open addressing (sonraki boş slot, Swift). Hepsi tek bucket'a düşerse tek lookup O(n) — **O(n²) değil**.

**HASH-10** · Q: Load factor nedir, rehash ne zaman/nasıl, hangi array kavramına benzer? — A: α = count/capacity; α > ~0.75'te rehash → 2× büyüt + hepsini yeniden yerleştir (O(n) seyrek → amortized O(1)). Array growth'un aynısı.

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

**PROB-0283** · Q: Move Zeroes — pattern ve neden brute force O(n²)? — A: In-place write-pointer: `slow`'a non-zero'ları kompakla, kuyruğu 0 doldur (O(n)). Brute (`remove`+`firstIndex` döngü içinde) = O(n²). Kural: döngü içi remove/firstIndex = gizli O(n).

**PROB-0128** · Q: Longest Consecutive — nasıl O(n), sort olmadan? — A: `Set` (O(1) membership) + sadece "başlangıç"lardan (num-1 yoksa) sağa yürü. İç içe döngü ama tüm while adımları toplamı = n → O(n). Tuzak: while koşulu `current+1` (num değil, yoksa sonsuz döngü).

**PROB-0167** · Q: Two Sum II (sorted) — hangi teknik, neden hash değil? — A: Converging two pointers (L=0, R=n-1): sum>target→R--, sum<target→L++. O(n) time, **O(1) space**. Sorted olduğu için R-- toplamı kesin küçültür. Hash de çalışır ama O(n) space; sorted → two pointers daha iyi.

**TP-1** · Q: "Sorted dizi + iki-uçtan yakınsayan karar" (pair-sum, palindrome, container) → ? — A: Converging two pointers (`while left < right`). O(n)/O(1). Her tur bir uç içeri; mesafe 1 azalır → O(n).

**STR-1** · Q: Swift'te `str[5]` neden yasak, ne yaparsın? — A: Character = grapheme cluster, değişken byte, sabit stride yok → index O(n) olurdu. `Array(s)` (O(1) index, O(n) space) veya `String.Index`.

**STR-2** · Q: `str.count` neden O(n)? ve `Array(s)`'in bedeli? — A: Karakter sayısı için grapheme sınırlarını baştan yürümek gerekir → O(n). `Array(s)` = O(n) time + O(n) space, karşılığında O(1) index.

**STR-3** · Q: `String.Index` — `endIndex` nedir, tuzağı? — A: Son karakterin **bir sonrası** (past-the-end), okunamaz. Son karakter = `index(before: endIndex)`. Boş string'de crash → guard.

**PROB-0125** · Q: Valid Palindrome — pattern + ana bug? — A: Converging two pointers + non-alnum skip. Bug: "not alphanumeric" = `!isLetter && !isNumber` (De Morgan, `&&` — `||` değil, yoksa hepsini skip'ler). O(1) space için String.Index.

---

## Nasıl büyütülür
- Yeni `concepts/NN-*.md` işlendiğinde → yeni `PREFIX-n` bölümü aç, ≥5 kart.
- Yeni problem çözülünce → `PROB-NNNN` kartı ekle (pattern + kritik insight).
- Kart **kısa** olmalı: bir soru, bir çekirdek cevap. Ansiklopedi değil, tetikleyici.
