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
| 4 | **Scenario** — large list image loading (mobile system design lite) | [04-scenario-image-list.md](04-scenario-image-list.md) |

---

## Oturum logu

| Tarih | Drill set |
|-------|-----------|
| 2026-05-01 | Mixed A–E (üç kategoriye dağıtıldı) |

Yeni oturum eklerken ilgili kategori dosyasına **yeni başlık** aç veya `sessions/YYYY-MM-DD.md` pattern'i eklenebilir.
