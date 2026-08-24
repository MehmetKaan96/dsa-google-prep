# iOS / Swift Coverage Tracker

> DSA tarafındaki [Concept Coverage](../README.md#concept-coverage) tablosunun iOS karşılığı.
> **Amaç:** Beginner → Intermediate → Advanced sırasıyla, **"arkada nasıl çalışıyor"** seviyesinde öğrenmek — üstünkörü değil.
> Format **D** seanslarında buradan konu seçilir. Konu bitince ilgili satır güncellenir + [ios-depth/README](README.md) indeksine dosya eklenir.

## Durum Sözlüğü

| İşaret | Anlamı |
|--------|--------|
| ✅ | Tamam — mekanik seviyesinde işlendi |
| 🟡 | Kısmi — değinildi ama deep-dive değil |
| ⏳ | Yapılmadı |

**İki eksen:** *Deep-dive* = konunun mekaniği (nasıl çalışıyor). *Drill* = kod okuma / bug bulma / senaryo pratiği ([recognition drills](drills/recognition/00-PROTOCOL.md)).

## Seans Kuralı (değişmez)

Bu konular **Socratic** işlenir — DSA'daki gibi:
1. Mentor **önce sorar**, direkt cevap vermez.
2. Kullanıcı açıklamaya çalışır (yanlış olsa da).
3. Mentor doğrular / düzeltir / yönlendirir.
4. Sonunda: not güncellenir + [DECK](../retrieval/DECK.md)'e recall kartı + [SCHEDULE](../retrieval/SCHEDULE.md)'a satır.

Ezber değil **türetme** hedeflenir: "unutsam bile yeniden çıkarırım."

---

## 🟢 Beginner — Temeller

| # | Konu | Deep-dive | Drill | Not / Dosya |
|---|------|-----------|-------|-------------|
| B01 | **Value vs Reference types** — struct/class, kopyalama semantiği, CoW | ⏳ | ⏳ | CoW kısmen [concepts/01-array](../concepts/01-array.md)'de |
| B02 | **Optionals** — Optional bir enum, unwrapping yolları, `guard let` vs `if let`, optional chaining | ⏳ | ⏳ | |
| B03 | **Closures** — capture semantiği, escaping vs non-escaping, closure = referans tipi | 🟡 | ✅ | [drills/03](drills/03-closures-delegates-memory.md) |
| B04 | **UIKit view lifecycle** — `viewDidLoad` → `viewWillAppear` → ... , ne nerede yapılır | ✅ | ⏳ | [uikit-lifecycle.md](uikit-lifecycle.md) |
| B05 | **Auto Layout temelleri** — constraint, priority, intrinsic content size, layout pass | ✅ | ⏳ | [uikit-deep.md](uikit-deep.md) |
| B06 | **Delegate pattern** — protokol, `AnyObject`, neden `weak` | 🟡 | ✅ | [drills/03](drills/03-closures-delegates-memory.md) · [access-control.md](access-control.md) |
| B07 | **SwiftUI `@State` / `@Binding`** — value semantics, tek yönlü akış, source of truth | ✅ | ⏳ | [swiftui-basics.md](swiftui-basics.md) |
| B08 | **SwiftUI temel view'lar & modifier'lar** — modifier sırası neden önemli, view = değer | 🟡 | ⏳ | [swiftui-basics.md](swiftui-basics.md) |
| B09 | **Protocols & extensions** — protocol-oriented temel, default implementation | ⏳ | ⏳ | |
| B10 | **Error handling** — `throws`, `Result`, `do/catch`, defensive decoding girişi | ⏳ | ⏳ | |

---

## 🟡 Intermediate — Sistem Anlayışı

| # | Konu | Deep-dive | Drill | Not / Dosya |
|---|------|-----------|-------|-------------|
| I01 | **Property wrapper ownership** — `@StateObject` vs `@ObservedObject` vs `@EnvironmentObject`, kim sahip, ne zaman sıfırlanır | 🟡 | ⏳ | [swiftui-basics.md](swiftui-basics.md) — ownership kuralları detaylandırılacak |
| I02 | **SwiftUI layout system** — HStack/VStack/ZStack, `List` vs `ForEach`, Lazy stack'ler, layout müzakeresi (parent önerir/child seçer) | ⏳ | ⏳ | |
| I03 | **SwiftUI identity & diffing** — `id`, `Identifiable`, neden index id olmaz, body ne zaman yeniden çalışır | 🟡 | ⏳ | [swiftui-basics.md](swiftui-basics.md) |
| I04 | **ARC mekaniği** — retain/release, strong/weak/unowned seçimi | ✅ | ✅ | [memory-management.md](memory-management.md) · [drills/recognition/01](drills/recognition/01-memory-arc.md) |
| I05 | **Retain cycle'lar** — closure, delegate, parent-child; cycle vs lifetime extension | ✅ | ✅ | [memory-management.md](memory-management.md) · [drills/recognition/01](drills/recognition/01-memory-arc.md) |
| I06 | **GCD** — queue'lar, sync/async, DispatchGroup, barrier (reader-writer) | ✅ | ✅ | [concurrency-gcd.md](concurrency-gcd.md) · [drills/02](drills/02-gcd-dispatch-group.md) |
| I07 | **Swift Concurrency temelleri** — async/await, `Task`, suspension point, structured concurrency | ✅ | ✅ | [async-await.md](async-await.md) · [drills/recognition/02](drills/recognition/02-concurrency.md) |
| I08 | **Actor'lar & isolation** — actor nedir, reentrancy, `nonisolated` | 🟡 | 🟡 | [async-await.md](async-await.md) — reentrancy eksik |
| I09 | **UIKit cell reuse & performans** — `dequeueReusableCell`, `prepareForReuse`, stale response guard | 🟡 | ✅ | [uikit-deep.md](uikit-deep.md) · canlı drill 2026-08-09 |
| I10 | **Networking** — URLSession, timeout, cancellation, Codable & defensive decoding | 🟡 | ✅ | [drills/04](drills/04-scenario-image-list.md) · [drills/08](drills/08-scenario-live-search.md) |
| I11 | **Testing & DI** — unit/integration/snapshot, protokol seam, mock | ✅ | ⏳ | [testing.md](testing.md) |
| I12 | **Access control & modül sınırı** — `open`/`public`/`internal`, `final`, `private(set)` | ✅ | ✅ | [access-control.md](access-control.md) · [drills/01](drills/01-access-control.md) |

---

## 🔴 Advanced — Derinlik & Mimari

| # | Konu | Deep-dive | Drill | Not / Dosya |
|---|------|-----------|-------|-------------|
| A01 | **Macro'lar & `@Observable`** — Observation framework, `@Published`/ObservableObject'ten farkı, ne zaman hangisi | ⏳ | ⏳ | |
| A02 | **`@MainActor` derinlemesine** — actor isolation, global actor, `nonisolated`, isolation inheritance | ⏳ | ⏳ | |
| A03 | **Sendable & data-race safety (Swift 6)** — `Sendable`, `@unchecked`, strict concurrency | ⏳ | ⏳ | |
| A04 | **Custom `Layout` protokolü** — `sizeThatFits`, `placeSubviews`, ne zaman gerekir | ⏳ | ⏳ | |
| A05 | **SwiftUI performans** — gereksiz body recomputation, `Equatable` view, `@ViewBuilder` maliyeti, Instruments | ⏳ | ⏳ | |
| A06 | **UIKit performans** — offscreen rendering, rasterization, image downsampling, background decode | 🟡 | ✅ | [drills/04](drills/04-scenario-image-list.md) |
| A07 | **MVVM / Clean SwiftUI'da** — SwiftUI'ın kendisi zaten VM mi, nerede katman gerekir | 🟡 | ⏳ | [architecture.md](architecture.md) — SwiftUI'ya özel kısım eksik |
| A08 | **Combine & reactive** — Publisher/Subscriber, operator'lar, backpressure, async/await ile ne zaman hangisi | ⏳ | ⏳ | |
| A09 | **Modularization** — bağımlılık yönü, granularity, white-label, build süresi | ✅ | ✅ | [modularization.md](modularization.md) · [drills/11](drills/11-scenario-white-label-multicountry.md) |
| A10 | **CI/CD** — pipeline, Fastlane, quality gate | ✅ | ⏳ | [ci-cd.md](ci-cd.md) |
| A11 | **Instruments ile debugging** — Leaks, Allocations, Time Profiler; pratik seans | ⏳ | ⏳ | |
| A12 | **App lifecycle & background** — state'ler, background mode'lar, `BGTaskScheduler`, `URLSession` background config | 🟡 | ✅ | [drills/09](drills/09-scenario-background-upload.md) |

---

## Özet

| Seviye | Deep-dive ✅ | Kısmi 🟡 | Yapılmadı ⏳ | Toplam |
|--------|-------------|----------|-------------|--------|
| 🟢 Beginner | 3 | 3 | 4 | 10 |
| 🟡 Intermediate | 6 | 5 | 1 | 12 |
| 🔴 Advanced | 3 | 4 | 5 | 12 |
| **Toplam** | **12** | **12** | **10** | **34** |

> **Gözlem:** Intermediate güçlü (mülakat hazırlığı oradan başlamıştı), ama **Beginner'da boşluklar var** (value/reference, optionals, protocols) — bunlar "biliyorum" sanılan ama mekaniği sorulunca zorlayan konular. **Advanced** ise modern Swift (macro, Sendable, Observation) tarafında zayıf.

## Önerilen Sıra

1. **Beginner boşlukları kapat** (B01, B02, B09, B10) — temel sağlamlaşsın, hızlı gider.
2. **Intermediate'i tamamla** (I01, I02, I03 — SwiftUI ownership/layout/identity üçlüsü; I08 actor reentrancy).
3. **Advanced'e geç** (A01/A02/A03 modern concurrency + Observation; sonra A05/A08).

## Cross-links
- Konu indeksi: [ios-depth/README](README.md)
- Recognition drill protokolü: [drills/recognition/00-PROTOCOL](drills/recognition/00-PROTOCOL.md)
- Senaryo drill'leri: [drills/README](drills/README.md)
- Spaced repetition: [DECK](../retrieval/DECK.md) · [SCHEDULE](../retrieval/SCHEDULE.md)
