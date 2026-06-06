# Scenario — Real-Time Messaging & Delivery

> **Format:** Mobile system design (lite) · **CV bağlamı:** real-time messaging, push notifications.
> **Not:** Networking — kullanıcının zayıf alanı, tekrar et.

---

## Senaryo

Mesajlaşma app'i. Mesajlar **anında** görünmeli, app **background**'dayken bildirim gelmeli. Kötü ağda mesaj **kaybolmamalı** / **iki kez gitmemeli**. iOS'ta nasıl?

---

## Cevap İskeleti

### 1. Clarify
- Delivery guarantee (at-least-once)?
- Ordering korunmalı mı?
- Presence (online/offline) göstergesi? Scale?

### 2. Real-time transport
| Araç | Ne için |
|------|---------|
| **WebSocket** | Çift yönlü anlık mesaj (foreground, bağlantı açık) |
| **APNs (push)** | App background/kapalı bildirim |
| **Polling** | Fallback (basit, gecikmeli, batarya) |

> *"Foreground WebSocket, background APNs."*

### 3. Background bildirim
- **APNs remote push**
- Sessiz veri için **silent push** (`content-available`)

### 4. Kaybolmama + iki kez gitmeme
- **Kaybolmama:** local **outbox queue** → gönder, **ACK** bekle, yoksa **retry** (at-least-once)
- **İki kez gitmeme:** **idempotency / message ID dedupe** — unique ID, aynı ID iki kez işlenmez

> *"At-least-once delivery + dedupe = exactly-once efekti."*

### 5. Trade-off
*"WebSocket real-time ama bağlantı + batarya yönetimi ister; düşük trafikte push + polling daha basit/ucuz."*

---

## Related
- [05-scenario-payment-idempotency.md](05-scenario-payment-idempotency.md) (idempotency tekrarı)
- [concurrency-gcd.md](../concurrency-gcd.md)
