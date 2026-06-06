# Scenario — Payment Flow & Double Charge

> **Format:** Mobile system design (lite) · **CV bağlamı:** secure payment flows, fintech.
> **Hero kavram:** Idempotency.

---

## Senaryo

Ödeme app'i. "Öde" butonu transaction başlatıyor. Kullanıcı **çift basıyor**, ağ **timeout** oluyor → **mükerrer ödeme (double charge)** şikayetleri. iOS'ta güvenli + doğru nasıl tasarlarsın?

---

## Cevap İskeleti

### 1. Clarify
- Ödeme sonucu senkron mu, yoksa webhook/polling ile mi dönüyor?
- Retry'ı client mı backend mi yönetiyor?
- Timeout süresi / kaç retry?
- Transaction state backend'de persist ediliyor mu?

### 2. Double tap (UI)
- Buton **disable** + loading animasyon
- Logic katmanında **`isProcessing` flag** (defense in depth)

### 3. Timeout + retry — IDEMPOTENCY (hero)
**Problem:** Timeout'ta retry → ilk istek backend'e ulaşmış olabilir (sadece cevap kayıp) → double charge.

**Çözüm — Idempotency Key:**
- Client her transaction için **unique key** (UUID) üretir → `Idempotency-Key` header
- Retry'da **aynı key** gönderilir
- Backend: "bu key'i işledim mi? → evet ise önceki sonucu dön, tekrar charge etme"

> *"Mükerrer ödemeyi idempotency key ile çözerim; retry'da aynı key → backend tekrar charge etmez → retry **safe** olur."*

### 4. Sorumluluk sınırı
Client: double-tap önleme + key üretimi + retry. Backend: key enforcement + asıl güvenlik. **Ortak sorumluluk.**

### 5. Failure UX
- Sonuç **belli** → success/failure popup
- Sonuç **belirsiz** (timeout) → "işlem alındı, kontrol ediliyor" + backend status **polling**; asla direkt "başarısız" deyip tekrar bastırma

---

## Related
- [concurrency-gcd.md](../concurrency-gcd.md) · Doctrine: Idempotency, Retry, Graceful Degradation
