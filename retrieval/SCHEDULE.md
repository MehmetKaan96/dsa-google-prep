# SPACED-REPETITION SCHEDULE

> **Unutmayı yenen takvim.** Leitner-kutu sistemi: her konu bir kutuda; doğru recall → bir üst kutu (daha seyrek); yanlış/eksik → Kutu 1'e düşer (yarın tekrar).
> Her seans başında: **bugünden önce `Next Due` gelmiş** satırlardan 3-5 kart çek ([DECK.md](DECK.md)).
> Tarih formatı: `YYYY-MM-DD`. Bugünkü tarih neyse ona göre "due mu?" bak.

## Kutu aralıkları (Leitner)

| Kutu | Aralık | Anlamı |
|------|--------|--------|
| 1 | +1 gün | Yeni veya yanlış cevaplanmış |
| 2 | +3 gün | Bir kez doğru |
| 3 | +1 hafta | Sağlamlaşıyor |
| 4 | +2 hafta | Neredeyse kalıcı |
| 5 | +1 ay | Uzun-dönem; aylık cold-check |

**Güncelleme kuralı:** Recall doğru+akıcı → kutu +1, `Next Due` = bugün + yeni aralık. Takılırsan/yanlışsa → Kutu 1, `Next Due` = yarın.

---

## Aktif konular

| Konu | Kutu | Last Reviewed | Next Due | Not |
|------|------|---------------|----------|-----|
| Array (ARR) | 1 | 2026-07-26 | 2026-07-27 | Restart — cold recall gerek |
| HashTable (HASH) | 1 | 2026-07-26 | 2026-07-27 | Restart — cold recall gerek |
| Two Sum (0001) | 1 | 2026-07-26 | 2026-07-27 | Cold re-solve hedefi ≤10dk |
| Contains Duplicate (0217) | 1 | 2026-07-26 | 2026-07-27 | |
| Valid Anagram (0242) | 1 | 2026-07-26 | 2026-07-27 | |
| Group Anagrams (0049) | 1 | 2026-07-26 | 2026-07-27 | |
| Pattern triggers (PAT) | 1 | 2026-07-26 | 2026-07-27 | Yeni deck bölümü |
| Recognition-MemARC (iOS drills 01) | 1 | 2026-07-26 | 2026-07-27 | Timed: isim <10sn, cevap <90sn |
| Recognition-Concurrency (iOS drills 02) | 1 | 2026-07-26 | 2026-07-27 | Refleks: main? shared state? bir kez tamamlanma? |

> Not: Uzun aradan (token/iş) sonra restart — hepsi Kutu 1'e resetlendi. Bilinçli karar: temelden sağlamlaştırma.

---

## Yeni konu ekleme
Bir `concepts/NN-*.md` bitince: buraya satır ekle, Kutu 1, `Next Due` = ertesi gün.

## Aylık Cold Rebuild (Kutu 5 kontrolü)
Ayda bir, boş sayfadan:
1. [00-MASTER-COMPLEXITY.md](../concepts/00-MASTER-COMPLEXITY.md) tablolarını ezberden yeniden üret.
2. Eksik/yanlış çıkan her konu → Kutu 1'e düşür.
3. Bu, "1 ay ara verdim, unuttum mu?" sorusunun objektif cevabıdır.
