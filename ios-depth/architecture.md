# iOS Architecture — MVVM / Clean / Modularization + SOLID

> **Session:** 2026-06-06 (Format D — Pazartesi teknik sohbet mülakatı prep)
> **CV bağlamı:** "Clean Architecture (MVVM/MVC), Modularization, SOLID" — bu iddiaların savunması.

---

## TL;DR

- **MVVM:** Model (data) · ViewModel (presentation logic + state) · View (render + user input)
- **Massive VC problemi:** MVC'de business logic VC'ye sızar → MVVM separation of concern + testability
- **Router/Coordinator:** navigation'ı View'den çıkarır
- **Modularization faydaları:** build time ↓ · team ownership · enforced API boundaries · testability/reusability
- **SOLID:** S(ingle responsibility) O(pen/closed) L(iskov) I(nterface segregation) D(ependency inversion)

---

## 1. MVVM

| Katman | Tek sorumluluk |
|--------|----------------|
| **Model** | API response decode + domain data |
| **ViewModel** | Presentation logic, state; View'e hazır veri sunar; UIKit import etmez |
| **View** | Render + user input; "ne göstereceğini" ViewModel'den alır |

**Binding (View ↔ ViewModel):** closure / delegate / Combine `@Published` / SwiftUI `@ObservedObject`.

**Test sinyali:** ViewModel **UI'dan bağımsız** olduğu için unit test edilir.

---

## 2. Massive View Controller → MVVM

MVC'de VC hem layout hem business logic taşır → binlerce satır, test edilemez. MVVM business logic'i **ViewModel'e** taşır:
- VC ince kalır (sadece binding + lifecycle)
- ViewModel pure/test edilebilir

---

## 3. Router / Coordinator (MVVM-R, Clean)

Navigation kararı **View'in işi değil**. Coordinator/Router:
- Ekran geçişlerini yönetir
- VC'leri birbirinden decouple eder (VC "sonraki ekranı" bilmez)
- Deep link / flow yönetimi tek yerde

---

## 4. Modularization — 4 Fayda (CV savunması)

1. **Build time ↓** — paralel derleme; değişen module yeniden derlenir
2. **Team ownership** — her takım kendi module'ü, conflict ↓
3. **Enforced boundaries** — `public`/`internal` ile API yüzeyi kontrol
4. **Testability + reusability** — bağımsız test, başka app'te kullanım

**Cümle:** *"Modularization'ı build time, team ownership ve enforced API boundaries için yaparım; yan fayda test + reuse."*

---

## 5. SOLID (her biri 1 cümle + iOS örnek)

| Harf | Prensip | iOS örnek |
|------|---------|-----------|
| **S** | Tek sorumluluk | VC layout, ViewModel logic — ayrı |
| **O** | Extension'a açık, modification'a kapalı | Yeni davranış: yeni protocol conformance, mevcut class'ı bozma |
| **L** | Subclass parent yerine geçebilmeli | Override davranışı bozmaz |
| **I** | Küçük odaklı protocol'ler | `UITableViewDataSource` + `Delegate` ayrı |
| **D** | High + low level **abstraction'a** bağımlı | ViewModel → `NetworkServiceProtocol` (somut servise değil) → test'te mock |

**D = DI bağlantısı:** ViewModel somut servise değil **protocol**'e bağımlı → mock enjekte edilir.

---

## References

- Apple — [Model-View-ViewModel](https://developer.apple.com/documentation/swiftui)
- Related: [access-control.md](access-control.md) (modularization boundaries), [concurrency-gcd.md](concurrency-gcd.md)
