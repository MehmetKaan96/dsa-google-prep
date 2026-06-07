# SwiftUI — Temel Mental Model + Property Wrappers

> **Session:** 2026-06-07 · **CV bağlamı:** "SwiftUI yeni entegre ediliyor"

---

## TL;DR

- **Declarative:** "state şu ise UI şöyle" — framework diff ile günceller (UIKit imperative'in tersi)
- **Single source of truth:** state değişince view otomatik yeniden hesaplanır
- **Property wrapper ownership** — en kritik konu

---

## 1. Declarative vs Imperative

- **UIKit (imperative):** "şunu yap, sonra şunu güncelle" — adım adım
- **SwiftUI (declarative):** "state X ise UI Y" — state değişince **otomatik** re-render (diffing)

---

## 2. Property Wrappers — Ownership (kritik)

| Wrapper | Sahiplik / kullanım |
|---------|---------------------|
| `@State` | View'in **local** value state (Bool, Int). View sahibi. |
| `@Binding` | Başka state'e **iki yönlü bağ** (parent `@State` → child `@Binding`). Sahibi değil. |
| `@StateObject` | View'in **sahip olduğu** ObservableObject — **bir kez yaratılır**, re-render'da korunur. |
| `@ObservedObject` | **Dışarıdan verilen** ObservableObject — view sahibi değil, sadece gözlemler. |

### En kritik fark (sınav sorusu)
- **`@StateObject`** = sahiplik + yaşam garantisi (yaratır, tutar)
- **`@ObservedObject`** = dışarıdan enjekte (tutmaz)
- Yanlış kullanım → object beklenmedik yeniden yaratılır / state kaybı

---

## 3. View = struct (value type)

- SwiftUI `View` **struct** — value type, stack, **ucuz**
- UIKit `UIView` = **class**, reference, heap, **pahalı**
- SwiftUI view'ı **atıp yeniden yaratabilir** (maliyeti düşük); render edilen şey değil, bir **tarif (description)**

> *"UIKit view = nesne (pahalı, manuel güncelleme). SwiftUI view = struct tarifi (ucuz, sürekli yeniden hesaplanır)."*

## 4. body & re-computation

State değişince SwiftUI ilgili view'ın **`body`'sini yeniden çağırır** → **diff** → sadece **değişen** UI'ı günceller. Bu yüzden `body` **saf + hızlı** olmalı (yan etki / ağır iş yok).

## 5. Identity & diffing

SwiftUI view'ları **identity** ile takip eder. `ForEach`'te **stable `id`** (Hashable) şart — yanlışsa yanlış view güncellenir / animasyon bozulur.

## 6. State akışı — single source of truth

```
@State / @StateObject  ← source of truth
        │ (tek yön: state → UI)
        ▼
       View
        │ (@Binding ile geri yaz)
        ▼
   child view
```

Her UI parçasının **tek** source of truth'u olmalı.

## 7. UIKit ↔ SwiftUI köprüsü

- UIKit → SwiftUI: **`UIViewRepresentable`** (view) / **`UIViewControllerRepresentable`** (VC)
- SwiftUI → UIKit: **`UIHostingController`**
- Migration gerçeği: çoğu app **hibrit** — bu köprüler "UIKit ağırlık + SwiftUI yeni" hikâyesiyle birebir.

## 8. EnvironmentObject (bonus)

Derin hiyerarşide parametre **drilling** yapmadan paylaşılan object enjeksiyonu — DI'ın SwiftUI hali.

---

## 9. CV Framing (dürüst)

> *"Projelerimiz ağırlıklı UIKit'ti; yeni feature'ları hızlı çıkmak için SwiftUI entegre etmeye başladık. Temel mental model (declarative, state-driven, property wrapper ownership) bende oturdu, prod deneyimini artırıyorum."*

---

## References

- Apple — [SwiftUI](https://developer.apple.com/documentation/swiftui)
