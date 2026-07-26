# 00 — PATTERN-TRIGGER MAP

> **Amaç:** Bir problemi okuyunca **hangi algoritmaya/veri yapısına** uzanacağını refleks hâline getirmek.
> Kullanım: problemdeki **sinyal cümlesini** yakala → sağdaki pattern'a git. "Just by looking at the problem."
> Bu dosya [00-MASTER-COMPLEXITY.md](00-MASTER-COMPLEXITY.md) ile birlikte çalışır: pattern'ı seç, complexity'yi oradan doğrula.

---

## 1. Sinyal → Pattern (ana tablo)

| Problemde görürsen... | Reach for | NEDEN / mekanizma |
|-----------------------|-----------|-------------------|
| "sorted array" + ara/çift | **Binary search** veya **Two pointers** | Sıralılık = O(n)→O(log n) veya tek geçiş |
| "pair / complement / bunu gördüm mü?" | **Hash map / Set** | O(1) lookup, tek geçiş |
| "contiguous subarray/substring" + optimize | **Sliding window** | Pencereyi kaydır, O(n²)→O(n) |
| "en fazla K / en az K farklı" pencere | **Sliding window (variable)** | Genişlet-daralt |
| "top K / K largest / K smallest / K closest" | **Heap (size K)** | O(n log k), tüm sort'a gerek yok |
| "median of stream / sürekli medyan" | **Two heaps** (max-heap + min-heap) | İki yarı dengede |
| "next greater / next smaller / span" | **Monotonic stack** | Artan/azalan stack, O(n) |
| "valid parentheses / matching / undo" | **Stack** | LIFO eşleştirme |
| "level by level / en kısa adım (unweighted)" | **BFS** | Katman katman = mesafe |
| "all paths / does path exist / connected components" | **DFS** | Derine git, backtrack |
| "shortest path + weights (non-negative)" | **Dijkstra** | Min-heap ile greedy |
| "shortest path + negatif weight" | **Bellman-Ford** | V-1 relaxation |
| "groups / islands / connectivity / cycle (undirected)" | **Union-Find** veya **DFS/BFS flood** | Bileşen birleştirme |
| "dependency / ordering / prerequisite" (DAG) | **Topological sort** | Kahn / DFS |
| "all combinations / permutations / subsets / generate all" | **Backtracking** | Karar ağacı, geri al |
| "count ways / min-max cost / can you reach" + overlapping | **Dynamic Programming** | Alt problemleri sakla |
| "prefix / kelime arama / autocomplete" | **Trie** | Prefix paylaşımı |
| "in-place, O(1) space, linked list ortası/döngü" | **Fast & slow pointers** | Floyd cycle, orta nokta |
| "reverse / palindrome / iki uçtan" | **Two pointers (converging)** | low↑ high↓ |
| "range sum / immutable diziye tekrar sorgu" | **Prefix sum** | O(1) range query |
| "interval / meeting rooms / merge / overlap" | **Sort by start + sweep** | Sırala, tara |
| "kth element unsorted, sort gereksiz" | **Quickselect** | Avg O(n) partition |

---

## 2. Constraint sinyali → complexity hedefi

> Input boyutu, algoritmayı **eleyen** en güçlü ipuçtur. Detay: MASTER-COMPLEXITY §B.

| Constraint | Mesaj |
|------------|-------|
| n ≤ 20 | Exponential OK → **backtracking / bitmask DP** |
| n ≤ 100–500 | O(n³) OK → 3 loop / Floyd-Warshall |
| n ≤ 1.000–2.000 | O(n²) OK → nested loop / basit DP |
| n ≤ 10⁵ | O(n log n) gerek → **sort / heap / binary search** |
| n ≥ 10⁶ | O(n) veya O(log n) gerek → **hash / two pointer / matematik** |
| "very large" / 10⁹ | O(log n)/O(1) → binary search on answer / formül |

**"Binary search on the answer"** sinyali: *"minimum/maximum X öyle ki koşul sağlansın"* + monotonic feasibility → cevabı ikiye bölerek ara.

---

## 3. Karar akışı (hızlı triyaj)

```
Problem geldi
│
├─ Sıralı mı / sıralayabilir miyim?  → Binary search / Two pointers
├─ "Daha önce gördüm mü / eşi var mı?" → Hash map / Set
├─ Contiguous window + optimize?       → Sliding window
├─ En iyi K / stream medyan?           → Heap(ler)
├─ Next greater/smaller, matching?     → (Monotonic) Stack
├─ Graf/grid + en kısa (unweighted)?   → BFS
├─ Graf/grid + tüm yollar/bileşen?     → DFS / Union-Find
├─ Graf + ağırlıklı en kısa?           → Dijkstra / Bellman-Ford
├─ "Tümünü üret" (subset/perm/comb)?   → Backtracking
├─ "Kaç yol / min-max" + örtüşen alt?  → DP
└─ Hiçbiri? → Brute force'u yaz, sonra darboğazı bir pattern'la kır
```

---

## 4. Sık karışan ikililer (ayırt etme)

| Karar | Kural |
|-------|-------|
| **BFS vs DFS** | En kısa/level → BFS. Var mı/tüm yollar/bellek dar → DFS |
| **Two pointers vs Sliding window** | Pencere boyutu/toplamı önemliyse window; iki uçtan yakınsama ise two pointers |
| **Hash map vs Set** | Yanında veri (index/count/payload) lazımsa map; sadece "var mı" ise Set |
| **Heap vs Sort** | Sadece top-K veya sürekli min/max → heap (O(n log k)). Tüm sıra lazımsa sort |
| **DP vs Backtracking** | Örtüşen alt problem + optimal/sayım → DP. Tümünü listele/kısıt karmaşık → backtracking |
| **Dijkstra vs BFS** | Ağırlıklar eşit/yok → BFS. Farklı pozitif ağırlık → Dijkstra |
| **Array vs Linked List** | Random access/iterasyon → Array. Sık uç ekleme-silme, bilinen node → Linked List |

---

## Cross-links
- Complexity doğrulama: [00-MASTER-COMPLEXITY.md](00-MASTER-COMPLEXITY.md)
- Her pattern'ın problem örnekleri ilgili `concepts/NN-*.md` ve `problems/` altında
- Recall: [../retrieval/DECK.md](../retrieval/DECK.md)
