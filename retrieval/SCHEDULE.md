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
| Array (ARR) | 2 | 2026-08-02 | 2026-08-05 | Recall güçlü: erişim/shift/Move Zeroes doğru ✓ |
| HashTable (HASH) | 2 | 2026-08-04 | 2026-08-07 | Recall doğru (worst O(n) = tek bucket lineer) ✓ |
| Longest Consecutive (0128) | 2 | 2026-08-09 | 2026-08-12 | ✅ **COLD SOLVE TAM** (4 gün aradan sonra, ipucusuz) — while yürüyüşü dahil |
| ZAYIF NOKTA: while-walk kalıbı | 2 | 2026-08-09 | 2026-08-12 | ✅ Aşıldı: #128'de `number` (ilerleyen) doğru kullanıldı |
| ZAYIF NOKTA: değişken scope/ömür | 2 | 2026-08-09 | 2026-08-12 | ✅ #485'te ilk denemede dışarıda tanımlandı. Kalan: rol ayrımı (current vs longest) |
| Max Consecutive Ones (0485) | 2 | 2026-08-09 | 2026-08-12 | Cold: scope ✓, rol karışıklığı (1 düzeltme) → çözdü |
| Stack & Queue mekaniği (SQ) | 1 | 2026-08-09 | 2026-08-10 | Deep dive: LIFO/FIFO, removeFirst O(n) tuzağı, 2-stack amortized |
| Valid Parentheses (0020) | 1 | 2026-08-09 | 2026-08-12 | Sözel 4/4 ✓; kodda "sessiz yutma" 2 kez + rewrite tuzağı |
| ⚠️ CODE-1: minimal fix > rewrite | 1 | 2026-08-09 | 2026-08-10 | %90 doğru kodu baştan yazma; her if'in her dalını belirt |
| Two Sum II (0167) | 1 | 2026-08-04 | 2026-08-07 | İlk denemede bug'sız ✓; +3g re-solve ≤5dk |
| Two Pointers pattern (TP) | 2 | 2026-08-05 | 2026-08-08 | Recall doğru ✓ (O(1) space ekseni) |
| String mekaniği (STR) | 2 | 2026-08-05 | 2026-08-08 | Recall doğru ✓ (stride mantığıyla açıkladı) |
| Valid Palindrome (0125) | 1 | 2026-08-04 | 2026-08-07 | 2 versiyon (Array + String.Index); +3g re-solve. Bug: De Morgan |
| Two Sum (0001) | 1 | 2026-07-26 | 2026-07-27 | Cold re-solve hedefi ≤10dk |
| Contains Duplicate (0217) | 1 | 2026-07-26 | 2026-07-27 | |
| Valid Anagram (0242) | 1 | 2026-07-26 | 2026-07-27 | |
| Group Anagrams (0049) | 1 | 2026-07-26 | 2026-07-27 | |
| Pattern triggers (PAT) | 2 | 2026-08-01 | 2026-08-04 | Cold recall: "pair/complement→hash" doğru ✓ |
| Recognition-MemARC (iOS drills 01) | 1 | 2026-07-26 | 2026-07-27 | Timed: isim <10sn, cevap <90sn |
| Recognition-Concurrency (iOS drills 02) | 1 | 2026-07-26 | 2026-07-27 | Refleks: main? shared state? bir kez tamamlanma? |
| Move Zeroes (0283) | 3 | 2026-08-05 | 2026-08-12 | Recall doğru (brute O(n²) sebebi) ✓ |
| Array mekaniği: erişim + shift | 2 | 2026-08-02 | 2026-08-05 | Recall doğru ✓ |
| Array mekaniği: AMORTIZED | 2 | 2026-08-04 | 2026-08-07 | Re-drill DOĞRU ✓ (2n/3n→O(1); +1→O(n²)). Zayıftı, oturdu. |

> Not: Uzun aradan (token/iş) sonra restart — hepsi Kutu 1'e resetlendi. Bilinçli karar: temelden sağlamlaştırma.

---

---

## 📌 Sonraki seans — buradan başla

**Yeni seans yapısı** (2026-08-09 geri bildirimi): kısa mekanik anlatım → **arka arkaya 2-3 problem**, Medium oranı yüksek. Az doküman, çok pratik.

1. **Warm-up sweep** — birikmiş kartlar (aşağıdaki tablo, çoğu gecikmiş): Two Sum · Contains Duplicate · Valid Anagram · Group Anagrams (27 Tem'den) · Two Sum II · Valid Palindrome · Array/HashTable/String/TP mekanikleri
2. **Stack merdiveni (kaldığımız yer):**
   - **#232 Implement Queue using Stacks** ← başlanacak (iki-stack, kavramı işlendi)
   - **#155 Min Stack** (yardımcı stack, O(1) min)
   - **#739 Daily Temperatures** (monotonic stack — yeni pattern)
3. Sonra → **Linked List** (konu 05)

**iOS Recognition Drills — programa eklendi:** her 2-3 DSA seansında bir, seans başında **1-2 drill** (5-10 dk), canlı. Protokol: [00-PROTOCOL](../ios-depth/drills/recognition/00-PROTOCOL.md) — 5 adımlı cevap (isim→severity→failure→fix→trade-off).
- ✅ 2026-08-09: UIKit cell-reuse drill yapıldı — baskın bug (stale image) bulundu ✓; severity kalibrasyonu geliştirilecek (`as!` = nit, her crash riski 🔴 değil); kaçırılanlar: `[weak self]`, thread sözleşmesi
- Sırada: SwiftUI drill (Set 03 — henüz dosyalanmadı, canlı yapılıyor)

---

## Yeni konu ekleme
Bir `concepts/NN-*.md` bitince: buraya satır ekle, Kutu 1, `Next Due` = ertesi gün.

## Aylık Cold Rebuild (Kutu 5 kontrolü)
Ayda bir, boş sayfadan:
1. [00-MASTER-COMPLEXITY.md](../concepts/00-MASTER-COMPLEXITY.md) tablolarını ezberden yeniden üret.
2. Eksik/yanlış çıkan her konu → Kutu 1'e düşür.
3. Bu, "1 ay ara verdim, unuttum mu?" sorusunun objektif cevabıdır.
