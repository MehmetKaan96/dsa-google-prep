# 00 — MASTER COMPLEXITY SHEET

> **Tek doğruluk kaynağı (single source of truth).** Tüm data structure ve algoritmaların time/space complexity'si burada.
> **Amaç:** Bunu boş bir sayfaya / whiteboard'a **ezberden yeniden üretebilmek.** Aylık "cold rebuild" testi buradan yapılır.
> Her satırın yanında **NEDEN** o complexity — sayıyı ezberleme, türet.

---

## A. Büyüme Sınıfları (Growth Classes) — önce bunu içselleştir

Büyükten küçüğe **iyilik** sırası: `O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2ⁿ) < O(n!)`

| Sınıf | İsim | Tipik kaynak | Örnek |
|-------|------|--------------|-------|
| O(1) | Constant | Direct index, hash lookup | `arr[i]`, `dict[k]` |
| O(log n) | Logarithmic | Her adımda input yarıya | Binary search, balanced BST |
| O(n) | Linear | Tek geçiş | Array scan, linked list traverse |
| O(n log n) | Linearithmic | Böl-yönet sort | Merge/heap/quick sort |
| O(n²) | Quadratic | İç içe iki döngü | Nested loop, naive pair check |
| O(2ⁿ) | Exponential | Her elemanda 2 seçim | Subset üretme, naive Fibonacci |
| O(n!) | Factorial | Tüm permütasyonlar | Permutation üretme, brute TSP |

## B. Constraint → Hedef Complexity (mülakat kısayolu)

> Input boyutuna bakıp **çözülmesi gereken complexity'yi geriye doğru oku.** Bu, "problemin bize verdiği ipucu"dur.
> Kaba tavan: ~**10⁸ işlem/saniye**.

| n (input üst sınırı) | Kabul edilebilir complexity | Akla gelen yaklaşım |
|----------------------|-----------------------------|---------------------|
| n ≤ 10–12 | O(n!) | Permütasyon, brute backtracking |
| n ≤ 20 | O(2ⁿ) | Subset / bitmask DP |
| n ≤ 100 | O(n³) | 3 nested loop, Floyd-Warshall |
| n ≤ 1.000 | O(n²) | Nested loop, basit DP |
| n ≤ 100.000 (10⁵) | O(n log n) | Sort, heap, binary search |
| n ≤ 1.000.000 (10⁶) | O(n) | Tek geçiş, hash, two pointer |
| n ≥ 10⁸ veya çok büyük | O(log n) / O(1) | Binary search, matematiksel formül |

**Kullanım cümlesi (interview):** *"n is up to 10⁵, so an O(n²) solution (10¹⁰ ops) is too slow — I need O(n log n) or better."*

---

## C. Data Structure Operasyonları

> **avg = ortalama/amortized**, **worst = en kötü**. Boşluklar avg=worst demektir.

### Linear yapılar

| Yapı | Access | Search | Insert | Delete | Space | Kritik NEDEN |
|------|--------|--------|--------|--------|-------|--------------|
| **Array (static)** | O(1) | O(n) | — | — | O(n) | `base + i*stride` aritmetiği → O(1) access |
| **Dynamic Array (Swift `Array`)** | O(1) | O(n) | O(1)* / O(n) mid | O(1)* end / O(n) mid | O(n) | *append amortized O(1); mid-insert eleman kaydırır → O(n); geometric growth (~2x) → amortized O(1) |
| **Singly Linked List** | O(n) | O(n) | O(1)** | O(1)** | O(n) | **pointer'a sahipsen; ama pozisyona ulaşmak O(n). Access yok, pointer chasing |
| **Doubly Linked List** | O(n) | O(n) | O(1)** | O(1)** | O(n) | **prev pointer → O(1) delete (node elde varsa). LRU cache'in temeli |
| **Stack (LIFO)** | O(n) | O(n) | O(1) push | O(1) pop | O(n) | Sadece tepeden; array veya linked list ile |
| **Queue (FIFO)** | O(n) | O(n) | O(1) enqueue | O(1) dequeue | O(n) | İki uçtan; array baştan silmede O(n) tuzağı → ring buffer / iki-stack / index kaydır |
| **Deque** | O(1)*** | O(n) | O(1) iki uç | O(1) iki uç | O(n) | ***iki uçtan O(1); ortadan O(n). Swift'te `Deque` (swift-collections) |

### Hash tabanlı

| Yapı | Access | Search | Insert | Delete | Space | Kritik NEDEN |
|------|--------|--------|--------|--------|-------|--------------|
| **Hash Table (`Dictionary`)** | — | O(1) avg / O(n) worst | O(1) avg / O(n) worst | O(1) avg / O(n) worst | O(n) | `hash(key) % capacity` → bucket; collision worst O(n); load factor ~0.75'te rehash O(n) |
| **Set** | — | O(1) avg / O(n) | O(1) avg / O(n) | O(1) avg / O(n) | O(n) | Dictionary ile aynı motor; sadece membership |

### Hiyerarşik / ağaç

| Yapı | Access/Search | Insert | Delete | Space | Kritik NEDEN |
|------|---------------|--------|--------|-------|--------------|
| **BST (dengeli, AVL/Red-Black)** | O(log n) | O(log n) | O(log n) | O(n) | Her seviyede input yarıya; **denge şart** |
| **BST (dengesiz, worst)** | O(n) | O(n) | O(n) | O(n) | Sıralı insert → linked list'e dejenere olur |
| **Binary Heap (min/max)** | O(1) peek | O(log n) | O(log n) | O(n) | sift-up/down ağaç yüksekliği kadar = log n; peek = kök |
| **Trie (prefix tree)** | O(L) | O(L) | O(L) | O(Σ·N·L) | L = kelime uzunluğu; alfabe boyutundan bağımsız arama |

> Not: Heap'te **search = O(n)** (rastgele eleman arama), sadece min/max O(1). Heap sıralı değildir; sadece heap invariant tutar.

### Graph gösterimi

| Gösterim | Space | Edge var mı? | Komşuları gez | Ne zaman |
|----------|-------|--------------|---------------|----------|
| **Adjacency List** | O(V + E) | O(degree) | O(degree) | Sparse graph (çoğu gerçek problem) |
| **Adjacency Matrix** | O(V²) | O(1) | O(V) | Dense graph, sık edge sorgusu |

---

## D. Algoritma Complexity'leri

### Sorting

| Algoritma | Best | Average | Worst | Space | Stable? | Not |
|-----------|------|---------|-------|-------|---------|-----|
| Bubble | O(n) | O(n²) | O(n²) | O(1) | ✅ | Sadece pedagojik |
| Selection | O(n²) | O(n²) | O(n²) | O(1) | ❌ | Her zaman n² (early exit yok) |
| Insertion | O(n) | O(n²) | O(n²) | O(1) | ✅ | Küçük/neredeyse-sıralı input'ta hızlı |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | ✅ | Garantili n log n; extra space |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) | ❌ | Kötü pivot → n²; pratikte hızlı |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) | ❌ | Garantili + in-place |
| **Tim (Swift `sort`)** | O(n) | O(n log n) | O(n log n) | O(n) | ✅ | Merge+Insertion hibriti; Swift stdlib introsort tabanlı |
| Counting | O(n+k) | O(n+k) | O(n+k) | O(k) | ✅ | k = değer aralığı; comparison değil |
| Radix | O(d·(n+k)) | — | — | O(n+k) | ✅ | d = basamak sayısı |

> **Comparison-based sort'un teorik alt sınırı O(n log n).** Counting/Radix bunu ancak comparison yapmadığı için kırar.

### Searching

| Algoritma | Time | Space | Önkoşul |
|-----------|------|-------|---------|
| Linear search | O(n) | O(1) | Yok |
| Binary search | O(log n) | O(1) iterative / O(log n) recursive | **Sorted** input |

### Graph & Tree

| Algoritma | Time | Space | Ne için |
|-----------|------|-------|---------|
| **BFS** | O(V + E) | O(V) | Shortest path (unweighted), level order |
| **DFS** | O(V + E) | O(V) | Connectivity, cycle, topological, path exists |
| **Tree traversal** (in/pre/post) | O(n) | O(h) | h = yükseklik; recursion stack |
| **Dijkstra** (min-heap) | O((V+E) log V) | O(V) | Shortest path, **non-negative** weights |
| **Bellman-Ford** | O(V·E) | O(V) | Negatif edge; negatif cycle tespiti |
| **Floyd-Warshall** | O(V³) | O(V²) | All-pairs shortest path |
| **Topological sort** | O(V + E) | O(V) | DAG sıralama (Kahn / DFS) |
| **Union-Find** (path compression + rank) | ~O(α(n)) ≈ O(1) | O(V) | Connectivity, cycle, MST (Kruskal) |
| **Prim / Kruskal (MST)** | O(E log V) | O(V) | Minimum spanning tree |

### Recursion / Backtracking / DP

| Kategori | Tipik time | Space | Not |
|----------|-----------|-------|-----|
| Subsets | O(2ⁿ · n) | O(n) | Her eleman: al/alma |
| Permutations | O(n! · n) | O(n) | Tüm sıralamalar |
| Combinations | O(C(n,k) · k) | O(k) | |
| DP (1D) | O(n) – O(n²) | O(n) veya O(1) rolling | State × transition |
| DP (2D grid) | O(m·n) | O(m·n) veya O(n) rolling | |
| DP (knapsack) | O(n·W) | O(W) rolling | Pseudo-polynomial (W'ye bağlı) |

> **DP time formülü:** `#states × transition-cost`. Space: naive = #states; çoğu 1D DP **rolling array** ile O(1)/O(n)'e iner.

---

## E. Recurrence / Master Theorem (böl-yönet için)

`T(n) = a·T(n/b) + O(nᵈ)` biçimindeki böl-yönet için:

- `d > log_b(a)` → **O(nᵈ)** (üst iş baskın)
- `d = log_b(a)` → **O(nᵈ log n)** (dengeli)
- `d < log_b(a)` → **O(n^(log_b a))** (yaprak iş baskın)

**Örnekler:** Merge sort `T(n)=2T(n/2)+O(n)` → d=1=log₂2 → **O(n log n)**. Binary search `T(n)=T(n/2)+O(1)` → d=0=log₂1 → **O(log n)**.

---

## F. Space Complexity — sık unutulanlar

- **Recursion stack space'tir.** Derinlik h → O(h) space, "in-place" görünse bile.
- **Output space genelde sayılmaz** (auxiliary space konuşulur), ama sorulursa ayır.
- **CoW (Swift):** kopya O(1); ilk mutation'da O(n) buffer kopyası. Fonksiyona array geçmek kopya değildir.
- **Hash map O(n) space** — "O(1) time" bedava değil, hafızayla takas.

---

## Cross-links
- Detay için: [00-PATTERN-TRIGGERS.md](00-PATTERN-TRIGGERS.md) (hangi problemde hangisi)
- Şablon: [00-TEMPLATE.md](00-TEMPLATE.md)
- Recall: [../retrieval/DECK.md](../retrieval/DECK.md)
