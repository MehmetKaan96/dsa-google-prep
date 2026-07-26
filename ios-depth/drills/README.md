# Code Review Drills

Trendyol tarzı mülakat pratiği: **kısa Swift snippet** → bug / risk → **minimum fix** → **1–2 cümle savunma**.

Theory için ana notlar: [access-control.md](../access-control.md), [memory-management.md](../memory-management.md), [concurrency-gcd.md](../concurrency-gcd.md).

---

## Kategoriler

| # | Kategori | Dosya |
|---|----------|-------|
| 1 | **Access control** — `open` / `public`, method-level `open`, module boundary | [01-access-control.md](01-access-control.md) |
| 2 | **GCD** — `main.async` vs `main.sync`, `DispatchGroup` `enter` / `leave` | [02-gcd-dispatch-group.md](02-gcd-dispatch-group.md) |
| 3 | **Closures & memory** — `[weak self]`, cycle vs lifetime extension, delegate | [03-closures-delegates-memory.md](03-closures-delegates-memory.md) |
| 4 | **Scenario** — large list image loading | [04-scenario-image-list.md](04-scenario-image-list.md) |
| 5 | **Scenario** — payment flow & double charge (idempotency) | [05-scenario-payment-idempotency.md](05-scenario-payment-idempotency.md) |
| 6 | **Scenario** — offline-first sync & conflict (LWW/merge) | [06-scenario-offline-sync.md](06-scenario-offline-sync.md) |
| 7 | **Scenario** — real-time messaging & delivery (WebSocket/APNs) | [07-scenario-realtime-messaging.md](07-scenario-realtime-messaging.md) |
| 8 | **Scenario** — live search (debounce + out-of-order) | [08-scenario-live-search.md](08-scenario-live-search.md) |
| 9 | **Scenario** — background video upload (URLSession background config) | [09-scenario-background-upload.md](09-scenario-background-upload.md) |
| 10 | **Scenario** — analytics tracking at scale (batching + persistence) | [10-scenario-analytics-batching.md](10-scenario-analytics-batching.md) |
| 11 | **Scenario** — white-label multi-country app (config-driven, RTL) | [11-scenario-white-label-multicountry.md](11-scenario-white-label-multicountry.md) |

## Recognition drills (hız + sinyal) — `recognition/`

Mülakatçı kod gösterir → **saniyeler içinde** bug'ı tanı + trade-off'la açıkla. Cevaplar `<details>` altında gizli (gerçek self-test).

- [recognition/00-RECOGNITION-MAP.md](recognition/00-RECOGNITION-MAP.md) — "tell → refleks teşhis → severity → fix → trade-off" haritası (6 kategori)
- [recognition/00-PROTOCOL.md](recognition/00-PROTOCOL.md) — timed drill protokolü + 5-adım cevap iskeleti
- [recognition/01-memory-arc.md](recognition/01-memory-arc.md) — Set 01 (seed, 6 drill) ✅ · Set 02-06 planlı (concurrency, swiftui, architecture, networking, safety/perf)

---

### Senaryo cevap iskeleti (genel)

`Clarify → Data model → Katmanlar → Concurrency → Failure modes → Trade-off`

### Clarify — 4 eksen şablonu (boş kalma)
1. **Scale** — hacim, kullanıcı, frekans
2. **Criticality** — kayıp/hata toleransı (genelde **en pahalı varsayım** burada)
3. **Constraints** — network, batarya, offline, platform
4. **Contract** — backend ne destekliyor (bulk, range, webhook)

### Tekrarlayan hero kavramlar
- **idempotency** — retry safety + dedupe
- **outbox + ACK + retry** — at-least-once delivery
- **batching + persistent queue** — yüksek frekans + dayanıklılık
- **LWW / merge** — conflict resolution
- **stale-response guard / cancel** — en güncel olanı al (image/search/messaging)
- **downsampling + background decode** — liste performansı
- **URLSession background config** — app suspend/kill'de süren transfer

### İki büyük dağıtık pattern (sentez)
1. **Stale-response guard** — async sonuç geç gelir, en güncel olanı al/iptal et
2. **Persistent outbox + batch + idempotency** — kaybetme, mükerrer sayma

---

## Oturum logu

| Tarih | Drill set |
|-------|-----------|
| 2026-05-01 | Mixed A–E (üç kategoriye dağıtıldı) |

Yeni oturum eklerken ilgili kategori dosyasına **yeni başlık** aç veya `sessions/YYYY-MM-DD.md` pattern'i eklenebilir.
