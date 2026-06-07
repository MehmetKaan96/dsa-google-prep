# Scenario — White-Label App, Multi-Country

> **Format:** Mobile system design (lite) · **CV bağlamı:** RTL/Arabic localization, modularization.
> **Mülakatçı bağlamı:** İhsan — 12 ülkede module (Vodafone/Loodos).

---

## Senaryo

Banka müşterisi için iOS app — **3 ülke** (TR, UK, BAE): farklı dil (Arapça **RTL**), farklı tema, bazı ülkede **olmayan** feature'lar. Aynı kod tabanından 3 app nasıl çıkarılır?

---

## Cevap İskeleti

### 1. Clarify
- Ülkeler arası **ortak feature oranı**?
- Feature aç/kapa **config'ten mi module'den mi**?
- Backend ülke başına ayrı mı, tek mi?

### 2. Strateji — White-Label / Configuration-Driven
- **Tek kod tabanı + ortak module'ler** (core + feature)
- Ülke başına **target / config** (`.xcconfig`, build setting, remote config)
- Module'ler **hardcode içermez** → değerler **dışarıdan enjekte**

### 3. Olmayan feature'lar
- **Feature flags** — ülkede yoksa kapalı
- Feature modüler → flag ile aç/kapa; kod ortak kalır

### 4. RTL + Tema + Dil (somut iOS)
- **Dil:** `Localizable.strings` per language
- **RTL:** Auto Layout **leading/trailing** (left/right değil), `semanticContentAttribute` → otomatik mirror
- **Tema:** `DesignSystem` module'ünde renk/font **protocol/config** ile; her ülke kendi temasını enjekte; Asset Catalog named colors
- **Config:** API URL / flag → xcconfig / remote config

### 5. Trade-off
*"Tek kod tabanı + config: bakım kolay, tekrar yok ama config karmaşıklığı + regression riski (bir değişiklik tüm ülkeleri etkiler). Alternatif ülke başına fork → basit ama bakım cehennemi. White-label + iyi test doğru ölçeklenir."*

---

## Net Kart
**Multi-country = white-label: tek kod, configuration injection + feature flags, RTL için leading/trailing.**

## Related
- [modularization.md](../modularization.md) (white-label) · [uikit-deep.md](../uikit-deep.md) (Auto Layout RTL)
