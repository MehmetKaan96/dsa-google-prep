# Scenario — Live Search (Debounce + Out-of-Order)

> **Format:** Mobile system design (lite) · **Kavram ailesi:** debounce + stale-response guard.

---

## Senaryo

E-ticaret arama. Kullanıcı yazdıkça **canlı** sonuç. Her tuşta API isteği → sunucu yükü + **sonuçlar karışık sırada** (eski istek geç dönüp yeniyi eziyor). iOS'ta nasıl?

---

## Cevap İskeleti

### 1. Clarify
- Sonuçlar paginated mı (infinite scroll)?
- Local cache var mı (tekrar arama → ağ atla)?
- Arama server-side mı client-side mı?

### 2. Her tuşta istek → Debounce
`DispatchWorkItem` + `asyncAfter` (200-300ms); yeni tuşta öncekini `cancel()`.

### 3. Out-of-order response (iki katman)
- **Cancel:** yeni aramada önceki `dataTask.cancel()`
- **Latest-query guard:** response'ta "bu hâlâ en güncel arama mı?" — değilse ignore (image list `currentURL` guard ile aynı aile)

### 4. Performans + UX
- Min karakter (örn. ≥ 3)
- Loading indicator, empty state ("sonuç yok")
- Sık aramalar için kısa TTL local cache

### 5. Trade-off
*"200-300ms debounce + cancel + latest-query guard. Tekrar aramalar için kısa TTL cache; ama stale risk dengelenir."*

---

## Stale-Response Pattern (aile)
Image list, messaging, search → hepsi: **async sonuç geç gelir, en güncel olanı doğrula/iptal et.**

## Related
- [concurrency-gcd.md](../concurrency-gcd.md) (debounce) · [04-scenario-image-list.md](04-scenario-image-list.md)
