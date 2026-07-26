# 00 — RECOGNITION DRILL PROTOCOL

> Bu drill'ler **hız + sinyal** antrenmanıdır: mülakatçı kod gösterir, sen bug'ı hızlı yakalar ve **trade-off'la** açıklarsın.
> Doctrine bağlantısı: **#1 PR Auditor** (2-3 yüksek-sinyalli yorum) + **#3 Signaling** (hire-worthy özet).

---

## Nasıl çalıştırılır (timed)

1. Snippet'i aç. **Model cevabı `<details>` altında — açma.**
2. Saat başlat. Hedefler:
   - **< 10 sn:** bug'ı **isimlendir** (bir cümle).
   - **< 90 sn:** tam sinyal cevabı ver (aşağıdaki 5 adım).
3. Sözel/yazılı cevabını ver, sonra `<details>`'i aç, karşılaştır.
4. **Kaçırdıysan veya yavaşsan** → ilgili konu [SCHEDULE.md](../../../retrieval/SCHEDULE.md)'de Kutu 1'e düşer.

## Cevap iskeleti (5 adım — her seferinde aynı)

1. **İsimlendir:** "Bu bir `<retain cycle / data race / off-main UI / ...>`."
2. **Severity:** 🔴 Critical / 🟡 Important / 🟢 Minor + tek cümle gerekçe.
3. **Failure mode:** Ne zaman, nasıl patlar? (somut senaryo — "zayıf ağda", "hızlı tap'te", "reorder'da")
4. **Minimal fix:** En küçük doğru düzeltme (overkill değil — doctrine #14).
5. **Trade-off / savunma:** Neden bu fix, alternatifi neden değil? (1-2 cümle, hire-worthy)

> **Brutal mode (doctrine #15):** "Activate Protocol 15" dersen — tek kaçırılan sinyal bile "no-hire" sayılır, Tier-1 bar.

## Drill kart formatı (yeni drill yazarken kopyala)

```markdown
## Drill <N> — <kısa başlık>

\`\`\`swift
<snippet — gerçekçi, 5-20 satır, tek net problem (bazen tuzak: sorun yok)>
\`\`\`

**Soru:** <"Buradaki sorunu bul ve trade-off'ları açıkla" / spesifik soru>

<details>
<summary>Model cevap (önce kendin çöz)</summary>

1. **İsim:** ...
2. **Severity:** ...
3. **Failure mode:** ...
4. **Fix:** ... (kod)
5. **Trade-off:** ...

</details>
```

## Kalite kuralları (drill üretirken)
- **Gerçekçi kod.** Yapay değil; prod'da görülebilecek biçimde.
- **Bazı drill'lerde bilerek SORUN YOK** — "burada bir şey yok, over-flag etme" refleksi de eğitilir (false-positive kontrolü).
- **Tek baskın problem** per snippet (recognition için); "çoklu" drill'ler ayrıca işaretlenir.
- **Severity dürüst** — her şey 🔴 değil; kalibrasyon sinyaldir.
- Zorluk etiketi: 🟢 tanıması kolay · 🟡 orta · 🔴 ince/tuzaklı.

## Set indeksi

| Set | Kategori | Dosya | Durum |
|-----|----------|-------|-------|
| 01 | Memory / ARC | [01-memory-arc.md](01-memory-arc.md) | ✅ seed |
| 02 | Concurrency | [02-concurrency.md](02-concurrency.md) | ✅ 6 drill |
| 03 | SwiftUI | (planlı) | ⏳ |
| 04 | Architecture | (planlı) | ⏳ |
| 05 | Networking / API | (planlı) | ⏳ |
| 06 | Safety / Performance | (planlı) | ⏳ |
