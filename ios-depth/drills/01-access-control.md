# Drills — Access Control

## Drill 1 — `public` method, dış module'da override

### Snippet

```swift
// Module: DesignKit
public class Theme {
    public func apply() {}
}

// Module: ShopApp
final class DarkTheme: Theme {
    override func apply() {
        super.apply()
    }
}
```

### Soru

Derlenir mi? Değilse neden? Minimum fix?

### Model cevap

- **Derlenmez** — `public` method dış module'dan **override edilemez**; `open class` yetmez, **`open func apply()`** gerekir.
- **Senior cümle:** *"Inheritance surface iki seviyededir: class `open`, override edilecek method da `open`."*

---

## Drill 2 — `public` class, instantiate + subclass (kontrast)

**Senaryo:** SDK'da `APIClient` dışarıdan **kullanılsın** ama **subclass edilmesin**.

### Model cevap

- `public class APIClient` (final değilse aynı module içinde subclass mümkün; dışarıdan subclass için `open` gerekir — istemiyorsan `public final class`).

---

## Ek kaynak

- [access-control.md](../access-control.md)
