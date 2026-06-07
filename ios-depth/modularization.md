# iOS Modularization

> **Session:** 2026-06-07 PM · Mülakatçı (İhsan Kahramanoğlu, Mobile Software Architect) imza konusu + CV iddiası.

---

## TL;DR

- **Neden:** build time ↓ · team ownership · enforced boundaries · reusability · testability
- **Nasıl:** iki eksen — **feature** modülleri (dikey) + **core/shared** (yatay)
- **Bağımlılık:** tek yönlü; feature→feature **YASAK**, feature→core OK
- **Cross-feature:** routing/coordinator veya protocol (DI)
- **Circular dep:** build kırar + coupling → shared module veya DI ile kır
- **White-label (multi-country):** configuration-driven, hardcode yok
- **Granularity:** feature sınırı + ownership + reuse (judgment)

---

## 1. Neden Modularization?

1. **Build time ↓** — paralel derleme, sadece değişen module
2. **Team ownership** — 30+ dev, paralel çalışma, conflict ↓
3. **Enforced boundaries** — `public`/`internal` ile API yüzeyi kontrol
4. **Reusability** — module başka app'te kullanılır (ajans / multi-client)
5. **Testability** — izole test

---

## 2. Nasıl Bölünür — İki Eksen

```
┌─────────────────────────────────────┐
│  App (orchestrator + DI setup)       │
├─────────────────────────────────────┤
│  FEATURE (dikey)                     │
│  Home · ProductList · Cart · Payment │
├─────────────────────────────────────┤
│  CORE / SHARED (yatay)               │
│  Networking · DesignSystem ·         │
│  Analytics · Common/Utilities        │
└─────────────────────────────────────┘
```

| Tip | Sorumluluk |
|-----|------------|
| App | Orchestration, DI, her şeyi bağlar |
| Feature | Tek kullanıcı özelliği (UI + logic) |
| Core/Shared | Ortak kullanılan (Networking, DesignSystem) |
| Foundation/Common | Utility, extension (en alt) |

**Kural:** üst → alt bağımlı; alt → üst **asla**.

---

## 3. Bağımlılık Yönü (en kritik)

```
✅ Cart → Networking (core)
✅ Payment → Networking (core)
❌ Cart → Payment (feature → feature, doğrudan)
```

**Cross-feature geçiş** (Cart'tan Payment'a):
- **Routing/Coordinator** — Cart "payment'a git" der, Payment'ı import etmez; App bağlar
- **Protocol (DI)** — Cart `PaymentLauncher` protocol'üne bağımlı; somut Payment App'ten enjekte

→ circular dependency + tight coupling önlenir (SOLID-D).

---

## 4. Circular Dependency

**Tehlike:** (1) **build kırılır** (A, B'yi bekler; B, A'yı) (2) iki module tek düğüm olur, ayrı test/deploy edilemez.

**Kır:** ortak parçayı **shared module**'e çıkar VEYA **protocol abstraction** (biri protocol'e bağımlı, somut tip enjekte).

---

## 5. Shared Model

Birden fazla feature'da kullanılan model (örn. `User`) → **Core/Shared module**'de. Feature'lar core'u kullanır.

---

## 6. White-Label / Multi-Country (Loodos, 12 ülke)

Module **hardcode içermez**, **dışarıdan configure** edilir:
- **Localization** — string/asset enjekte (RTL dahil)
- **Configuration injection** — API URL, feature flag init/config'ten
- **Theming** — renk/font DesignSystem config'ten (her ülke kendi teması)
- **Feature flags** — ülkeye göre aç/kapa
- **Stable public API** — iç değişiklik client'ı bozmaz

> *"Configuration-driven module: aynı kod 12 ülkede farklı config'le — white-label."*

---

## 7. Granularity (engineering judgment)

- **Çok küçük:** micro-module enflasyonu, dependency cehennemi, build overhead
- **Çok büyük:** modularization faydası yok (monolith)
- **Doğru:** feature sınırı + team ownership + reuse — *"bağımsız geliştirilip test edilebilir + başka yerde kullanılır mı?"*

---

## 8. SPM vs CocoaPods

- **SPM:** Apple native, Xcode entegre, `Package.swift` → modern tercih
- **CocoaPods:** olgun, geniş ekosistem, Ruby/`Podfile`, legacy

---

## References

- Related: [access-control.md](access-control.md) (boundaries), [architecture.md](architecture.md) (SOLID-D, DI)
