# Scenario — Analytics / Event Tracking at Scale

> **Format:** Mobile system design (lite) · **CV bağlamı:** high-traffic, millions of users.
> **Hero pattern:** Persistent Queue + Batching + Idempotency.

---

## Senaryo

Milyonlarca kullanıcılı app. Her ekran/tıklama/scroll bir **event** (kullanıcı başına yüzlerce/gün). Her event'i anında göndermek **ağ + batarya + sunucu** yakar; offline'da **kaybolur**; sıra + duplicate sorunu. iOS'ta tracking nasıl?

---

## Çakışan 3 kuvvet
Hacim (saniyede onlarca) · Maliyet (her event = 1 istek → patlar) · Dayanıklılık (kaybolmamalı)

---

## Cevap İskeleti

### 1. Clarify (4 eksen: Scale / Criticality / Constraints / Contract)
- **Event kayıp toleransı?** (kritik event var mı — purchase funnel) ← en pahalı varsayım
- Hacim (event/sn)?
- Sıra (ordering) önemli mi?
- Backend **bulk endpoint** destekliyor mu?
- Wi-Fi-only mu? PII/GDPR?

### 2. Batching (anahtar)
Anında gönderme → **buffer'da biriktir**, flush tetikleyici:
1. **Boyut** (50 event)
2. **Zaman** (30 sn timer)
3. **Lifecycle** (background'a geçerken hemen)

> ~50x network/batarya tasarrufu.

### 3. Persistence (offline + crash)
Buffer RAM'de olursa crash'te kaybolur → **disk'e persist** (SQLite/Core Data, FIFO).
```
event → DISK'e yaz → batch flush → ACK → disk'ten sil
```
Crash olsa disk'te durur → sonraki launch'ta gönderilir. **UserDefaults kullanma.**

### 4. App kapanırsa
- `applicationDidEnterBackground` / `scenePhase` → flush
- `beginBackgroundTask` ile birkaç saniye iste
- Crash → zaten diskte, kayıp yok

### 5. Sıra + duplicate
- **Sıra:** FIFO + timestamp/sequence
- **Duplicate:** ACK'siz ölüm → retry → **idempotency** (event id, backend dedupe)
- At-least-once + dedupe = **exactly-once efekti**

### 6. Trade-off
*"Batch boyutu/aralığı = freshness vs verimlilik. 30sn/50-event + background flush iyi denge. Çoğu prod kendi yazmak yerine Firebase Analytics / Amplitude kullanır — batching+offline+retry hazır."*

---

## Net Kart — 2 büyük dağıtık pattern
1. **Stale-response guard** (image/search/messaging — en güncel olanı al/iptal et)
2. **Persistent outbox + batch + idempotency** (payment/messaging/analytics — kaybetme, mükerrer sayma)

## Related
- [07-scenario-realtime-messaging.md](07-scenario-realtime-messaging.md) · [05-scenario-payment-idempotency.md](05-scenario-payment-idempotency.md)
