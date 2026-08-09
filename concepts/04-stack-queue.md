# Stack & Queue

> Referans özet. Mekanik = retention'ın kalbi (bkz [00-TEMPLATE](00-TEMPLATE.md)).

## TL;DR

İkisi de **kısıtlanmış erişimli** koleksiyon: Array'de her index'e erişebilirsin, bunlarda **sadece uçlara**. Kısıtlama zayıflık değil — doğru problemi doğal modelleme biçimi.

- **Stack (LIFO)** — aynı uçtan ekle/çıkar. *Tabak yığını.*
- **Queue (FIFO)** — bir uçtan ekle, **diğer** uçtan çıkar. *Market kuyruğu.*

## Mekanik (Under the Hood)

### Stack — Array'in sonu
```swift
var stack: [Int] = []
stack.append(x)            // push → O(1) amortized
stack.last                 // peek → O(1)  (boşta nil — crash yok)
stack.removeLast()         // pop  → O(1)  (boşta CRASH; popLast() → Optional)
```
**Neden O(1)?** Sondan ekleme/silme **kaydırma gerektirmez** (Array mekaniği). `append` amortized O(1) (2× growth), `removeLast` O(1).
**Swift'te ayrı `Stack` tipi yok** — `Array` zaten mükemmel bir stack.

### Queue — ve klasik O(n) tuzağı ⚠️
```swift
queue.append(x)            // enqueue → O(1) ✓
queue.removeFirst()        // dequeue → O(n) ❌ TUZAK
```
`removeFirst()` index 0'ı siler → sonraki **tüm elemanlar sola kayar** (bitişiklik). `n` dequeue → **O(n²)**. BFS'te bu hata algoritmayı gizlice O(n²) yapar.

**Çözümler:**
| Yöntem | Nasıl | Trade-off |
|--------|-------|-----------|
| **head index** ⭐ | Silme yok, `head` pointer'ı ilerlet | O(1); bellek hemen boşalmaz |
| Ring buffer | Sabit dizi, head/tail dairesel | O(1); kapasite yönetimi |
| İki stack | inbox+outbox; outbox boşsa inbox'ı ters boşalt | **Amortized O(1)** |
| `Deque` (swift-collections) | Hazır | Prod'da en temiz; harici paket |

**LeetCode/BFS refleksi (head index):**
```swift
var queue = [start]; var head = 0
while head < queue.count {
    let node = queue[head]; head += 1        // dequeue O(1)
    // komşuları queue.append(...)
}
```

### İki stack ile queue — neden çalışır, neden amortized O(1)?
**LIFO × LIFO = FIFO.** Transfer sırasında sıra tersine döner:
```
inbox [1,2,3] → pop/push → outbox [3,2,1] (tepe: 1) → pop = 1 ✓ FIFO
```
Kural: dequeue'da outbox doluysa direkt pop; **boşsa** önce tüm inbox'ı aktar.
**Amortized O(1) gerekçesi:** Bir eleman hayatı boyunca **en fazla bir kez** transfer edilir, geri asla taşınmaz → n eleman için toplam O(n) → işlem başına sabit.
> ⚠️ Bu, Array growth'un amortized'ından **farklı bir gerekçe** (orada 2× büyüme, burada "her eleman bir kez taşınır"). Aynı kavram, farklı ispat.

## Big O
| İşlem | Stack | Queue (doğru impl.) |
|-------|-------|---------------------|
| ekle | O(1) amortized | O(1) |
| çıkar | O(1) | O(1) |
| peek | O(1) | O(1) |
| arama | O(n) | O(n) |
| space | O(n) | O(n) |

## Karar Motoru
✅ **Stack:** "en son gördüğüme geri dön" · eşleştirme/parantez · undo · DFS · recursion · monotonic stack (next greater)
✅ **Queue:** "sırayla, katman katman" · BFS · level-order · en kısa yol (ağırlıksız) · iş kuyruğu
❌ **Kaçın:** ortadan erişim/arama gerekiyorsa (Array/Dictionary kullan)

> **Kilit sezgi:** Stack → **derinlik**. Queue → **genişlik**. Recursion **gizli bir stack'tir** (call stack) — konu 09'un temeli.

## Senior Sinyalleri / Terimler
- LIFO/FIFO · call stack · monotonic stack · ring buffer · amortized transfer · `removeFirst()` O(n) tuzağı · `popLast()` (Optional) vs `removeLast()` (crash)

## Pattern Bağlantısı
"next greater/smaller" → monotonic stack · "valid/matching" → stack · "level by level / en kısa adım" → BFS queue. Bkz [00-PATTERN-TRIGGERS](00-PATTERN-TRIGGERS.md).

## Yaygın Mülakat Problemleri
- [x] Valid Parentheses (20) — stack eşleştirme
- [ ] Min Stack (155) — yardımcı stack ile O(1) min
- [ ] Implement Queue using Stacks (232) — iki stack
- [ ] Daily Temperatures (739) — monotonic stack
- [ ] Next Greater Element I (496) — monotonic stack
- [ ] Evaluate RPN (150) — stack hesap
- [ ] Binary Tree Level Order (102) — BFS queue *(konu 06)*

## Self-Quiz (deck: SQ-*)
1. Q: Stack neden Array ile O(1)? → A: sondan ekle/sil, kaydırma yok.
2. Q: `queue.removeFirst()` neden tuzak? → A: O(n) kaydırma → n dequeue = O(n²). Çözüm: head index.
3. Q: İki stack ile queue neden FIFO verir? → A: transfer sırayı ters çevirir (LIFO×LIFO=FIFO).
4. Q: O amortized O(1)'in gerekçesi? → A: her eleman en fazla 1 kez transfer edilir.
5. Q: Stack mi queue mu — "next greater element"? → A: (monotonic) stack.
