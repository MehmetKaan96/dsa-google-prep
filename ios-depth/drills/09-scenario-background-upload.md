# Scenario — Background Video Upload

> **Format:** Mobile system design (lite) · **CV bağlamı:** AVFoundation, performance.
> **Hero kavram:** `URLSessionConfiguration.background` (Task değil, configuration).

---

## Senaryo

Sosyal app, kullanıcı **video** yüklüyor. Uzun sürer; kullanıcı app'i **background**'a alır / kapatır. Yükleme **kesilmemeli**, **ilerleme** gösterilmeli, ağ koparsa **devam/retry**. iOS'ta nasıl?

---

## Cevap İskeleti

### 1. Clarify
- Dosya boyutu tipik ne (resume gerekli mi)?
- Server **resumable upload** (range) destekliyor mu?
- Aynı anda kaç upload (kuyruk)?
- Wi-Fi-only mu, cellular da mı?

### 2. Kritik: Task değil, CONFIGURATION

| Config | Davranış |
|--------|----------|
| `.default` | App suspend → task **ölür** |
| `.background(withIdentifier:)` | İş **sistem daemon'ına** devredilir; app kill olsa bile sürer |

`URLSessionUploadTask` tek başına yetmez → **`.background` configuration** şart.

### 3. Background session mekanizması
```
background session (unique id) → uploadTask (FILE URL'den, Data değil!)
→ app suspend → nsurlsessiond devralır → transfer biter
→ sistem app'i ARKA PLANDA UYANDIRIR
→ AppDelegate.handleEventsForBackgroundURLSession(identifier:completionHandler:)
→ aynı id ile session reconnect → URLSessionDelegate callback
```

**3 detay:**
1. **File URL, Data değil** — app ölünce RAM'deki Data kaybolur, dosya kalır
2. **handleEventsForBackgroundURLSession** — completionHandler'ı sakla, delegate bitince çağır
3. **Delegate zorunlu** — background session closure-based completion kabul etmez

### 4. Retry / Resume (büyük dosya)
- Küçük dosya: retry + restart
- Büyük video: **chunked + resumable upload** (server `Content-Range` / tus), kopunca kaldığı chunk'tan
- **Idempotency:** her chunk'a ID → tekrar gönderim iki kez işlenmez

### 5. Trade-off
*"Alamofire foreground upload'u sadeleştirir; ama background upload yine `URLSession background config` + `handleEventsForBackgroundURLSession` bilmeyi gerektirir — kütüphane app-relaunch sorumluluğunu kaldırmaz."*

---

## Net Kart
**"Background'da iş" = `URLSessionConfiguration.background` + file URL + delegate + handleEvents.** Büyük dosya → chunked + resumable + idempotency.

## Related
- [concurrency-gcd.md](../concurrency-gcd.md) · [05-scenario-payment-idempotency.md](05-scenario-payment-idempotency.md)
