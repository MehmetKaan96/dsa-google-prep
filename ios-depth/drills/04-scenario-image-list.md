# Scenario — Image Loading in a Large List

> **Format:** Mobile system design (lite) — açık uçlu "milyonlarca kullanıcı, nasıl yaparsın?" sorusu.
> **CV bağlamı:** high-traffic apps, 99.9% crash-free.

---

## Senaryo

E-ticaret app, ürün listesi, her ürün görselli, hızlı scroll. Bazen **yanlış hücrede görsel**, bazen **scroll takılıyor**. iOS'ta nasıl tasarlarsın?

---

## Cevap İskeleti (Clarify → Çözüm → Bug → Performans → Trade-off)

### 1. Clarify
- Pagination var mı?
- Backend thumbnail mı, full-res mi veriyor? (downsampling kararı)
- Cache beklentisi (offline, TTL)?
- Görseller CDN'de mi (aynı URL tekrar → cache hit)?

### 2. Image loading + caching
- `prepareForReuse`: `imageView.image = nil`, devam eden task **`cancel()`**, `currentURL = nil`
- Memory cache (`NSCache`) + disk cache
- Completion'da **`guard url == currentURL else { return }`**

### 3. "Yanlış hücre" bug'ı
**Sebep:** Cell reuse + stale completion. Hücre yeniden kullanılır, önceki async image completion **geç gelir** ve yeni hücreye eski görseli yazar.
**Fix:** `prepareForReuse`'da cancel + completion'da `currentURL` guard.

### 4. Scroll performansı (jank)
1. **Downsampling** — görseli hücre boyutuna indir (`CGImageSourceCreateThumbnailAtIndex`); full-res decode = ana jank sebebi
2. **Background decode** — main'de decode etme; sadece `image` atamasını main'de
3. **Prefetching** — `UITableViewDataSourcePrefetching` ile görünmeden yükle

> *"Jank'ın ana sebebi main thread'de full-res decode. Downsampling + background decode + prefetch ile 60fps."*

### 5. Trade-off — kütüphane vs kendi
- **Kingfisher/SDWebImage:** cache + cancellation + downsampling hazır, battle-tested → **prod'da default**
- **Kendi:** tam kontrol ama cache eviction + thread-safety + cancellation senin sorumluluğun → bug riski

> *"Prod'da Kingfisher tercih ederim; image caching çözülmüş problem. Kendi çözümü ancak özel constraint (binary size, custom pipeline) varsa."*

### SwiftUI notu
- `AsyncImage` (iOS 15+) built-in, placeholder destekli; ama cache/cancellation zayıf → prod'da Kingfisher'ın SwiftUI API'si.

---

## Related
- [memory-management.md](../memory-management.md) — lifetime extension, stale callback
- [concurrency-gcd.md](../concurrency-gcd.md) — thread-safety, main.async
