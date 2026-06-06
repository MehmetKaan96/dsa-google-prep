# Scenario — Offline-First Sync & Conflict

> **Format:** Mobile system design (lite) · **CV bağlamı:** education app, localization, role-based workflows.

---

## Senaryo

Not/görev app'i. Kullanıcı **offline** not ekliyor/düzenliyor, bağlantı gelince **sunucuyla senkron** olmalı. İki cihazdan aynı not değişince **conflict**. iOS'ta offline-first sync nasıl?

---

## Cevap İskeleti

### 1. Clarify
- Sync senkron mu, background mı?
- Conflict politikası ürün tarafından belli mi?
- Aynı kullanıcı çok cihaz mı?
- Veri kritikliği (kayıp tolere edilir mi)?

### 2. Local persistence
- **Core Data** (mature, geniş cihaz desteği) veya **SwiftData** (modern, iOS 17+)
- Offline-first → **local source of truth**, sonra sync

### 3. Sync stratejisi — Change Tracking
- Her local değişikliğe **dirty flag / pending queue (outbox)**
- Bağlantı gelince outbox gönderilir
- **Idempotency** — aynı değişiklik iki kez gitmesin

### 4. Conflict Resolution (isimlendir)
| Strateji | Açıklama |
|----------|----------|
| **LWW (Last-Write-Wins)** | Basit, ama veri kaybı |
| **Server-wins / Client-wins** | Politika belli |
| **Merge** | Alan bazında birleştir — en iyi UX, en karmaşık |
| **(Advanced)** version vector / CRDT | Overkill çoğu app'te |

> *"LWW ile başlar, kullanıcı verisi kritikse merge'e geçerim."*

### 5. Trade-off
*"SwiftData modern ama iOS 17+; geniş destek gereken prod'da Core Data daha güvenli."*

---

## Related
- [architecture.md](../architecture.md) · [05-scenario-payment-idempotency.md](05-scenario-payment-idempotency.md) (idempotency)
