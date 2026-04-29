# Array

> **Tam deep-dive:** `DSA.playground/Pages/01-Array.xcplaygroundpage/Contents.swift`
> Bu dosya hızlı referans özetidir. Playground'da çalıştırılabilir örnekler bulunur.

## TL;DR

Array = contiguous memory bloğu. `base + offset` aritmetiği ile O(1) random access sağlar.
Swift `Array` bir value type'tır; reference-counted heap buffer üzerinde Copy-on-Write ile çalışır.

## Temel Invariant'lar

- Contiguity — tüm elemanlar tek bir memory bloğunda
- Homogeneity — aynı tip, aynı stride
- Bounds — `index ∈ [0, count)`, ihlalde Swift trap atar
- Capacity ≥ count — allocate edilen ≥ kullanılan

## Big O

| Operation | Average | Worst |
|-----------|---------|-------|
| `arr[i]` | O(1) | O(1) |
| `append` | O(1) amortized | O(n) realloc |
| `insert(at:)` | O(n) | O(n) |
| `remove(at:)` | O(n) | O(n) |
| `contains` | O(n) | O(n) |
| Binary search (sorted) | O(log n) | O(log n) |
| `sort()` | O(n log n) | O(n log n) |
| CoW copy | O(1) | O(n) ilk mutation'da |

## Swift'e Özgü

- `Array<T>` Obj-C bridging destekler; `ContiguousArray<T>` desteklemez (~2x daha hızlı iteration)
- `ArraySlice` parent buffer'ı tamamen retain eder — uzun yaşıyorsa **gizli memory leak**
- CoW, `isKnownUniquelyReferenced == false` olduğunda **mutation** anında tetiklenir, **assignment'ta değil**
- Geometric growth (~2x) amortized O(1) append verir; `reserveCapacity` resize storm'unu engeller

## Karar Motoru

✅ Kullan:
- Read-heavy + random access
- Boyutu bilinen / bounded
- Cache-sensitive hot path
- Iteration-dominated algoritmalar

❌ Kaçın:
- Sık mid-insert / mid-delete
- O(1) key lookup gerekiyor → `Dictionary`
- İki uçtan büyüyen FIFO/LIFO → `Deque`

## Senior Sinyalleri / Bilinmesi Gereken Terimler

- Amortized analysis (banker's / potential method)
- Spatial / temporal locality
- Cache line, prefetching
- Stride vs size vs alignment
- Geometric growth factor
- Copy-on-Write, `isKnownUniquelyReferenced`
- Pointer chasing (LinkedList kontrastı)

## Yaygın Mülakat Problemleri

- [ ] Two Sum (Easy)
- [ ] Contains Duplicate (Easy)
- [ ] Best Time to Buy and Sell Stock (Easy)
- [ ] Product of Array Except Self (Medium)
- [ ] Maximum Subarray / Kadane's (Medium)
- [ ] Rotate Array (Medium)
- [ ] 3Sum (Medium)
- [ ] Container With Most Water (Medium)
- [ ] Trapping Rain Water (Hard)
