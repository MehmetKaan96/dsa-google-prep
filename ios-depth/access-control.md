# Swift Access Control + Inheritance Surface

> **Trendyol technical interview alignment:** projede **code review / bug fix** senaryolarında sık çıkan topic'ler — `open` vs `public`, encapsulation, delegate cycle, thread-safety ile **memory/callback** riskleri.
> **Session:** 2026-04-30 (Format D Extended + code review drills)

---

## TL;DR

- **Module:** Her Xcode/Swift **target** ayrı bir module'dür (`import` ile bridge edilir).
- **Framework:** Module'ün **paketleme formatı** — her framework bir module'dur, her module framework değildir.
- **`public`:** Module dışından **use** edilebilir, `open` olmayan member'lar **override edilemez** (dış module'dan).
- **`open`:** Module dışından **subclass + override** için **explicit opt-in** — library author güvenliği.
- **Class `open` ≠ method `open`:** Method-level inheritance ayrı karar.
- **`private` (Swift 4+):** Aynı type + **aynı dosyadaki extension'lar** erişir — `fileprivate` sıkça gereksizleşir.
- **`private(set)`:** Dışarı **read**, içeri **write** — `public var` smell'i azaltır; genelde cache gibi state için `private var` daha strict.
- **`final`:** Subclass yasak + **devirtualization** (vtable bypass → direct call).
- **Escaping network completion:** `self` strong capture → **stale UI update riski** + **gereksiz lifetime extension** — `[weak self]` + cancellation / staleness guard.

---

## 1. Declaration Scope

**Declaration scope = `{ }` bloğu** içinde tanımlanan şeyin yaşadığı lexical region.

```swift
class Foo {
    private var x = 0

    func bar() {
        let local = 1
        x += local                    // ✅ same type body
    }
}

extension Foo {
    func extra() {
        x += 1                        // ✅ Swift 4+: same-file extension of same type
    }
}
```

---

## 2. Module vs Framework

| Kavram | Anlam |
|--------|-------|
| **Module** | Derleme / dağıtım birimi — app target, framework, Swift Package hepsi ayrı module |
| **Framework** | `.framework` / `.xcframework` olarak paketlenmiş **module** |
| **`import`** | Başka module'ün `public`/`open` API'sini görünür kılar |

**Kural — effective visibility:** Member `public` yazılsa bile, containing type `internal` ise **dış module practical olarak erişilemez** — type'a zaten erişemiyorsun. Bu "compile ama dead intent" smell'idir.

---

## 3. Access Modifier Cheat Sheet

| Modifier | Scope |
|----------|-------|
| `private` | Declaration scope + same-file extensions of same type |
| `fileprivate` | Entire same **file** (all types / free functions) |
| `internal` | Same **module** (default) |
| `public` | All modules **see**; **cannot override** from outside unless `open` |
| `open` | All modules **see** + **can subclass/override** from outside (when applied) |

---

## 4. `open` vs `public` — THE Interview Question

### Mental model (tek satır)

> **`public` = "kullan ama extend etme" · `open` = "kullan ve extend et (bilinçli izin)"`**

### Two-level decision

```
Subclass edilebilir mi?     → class: open (outside module)
Method override edilebilir mi? → method: open

Class open + method public  → subclass OK, override on that method: NO (outside module)
```

### Why Swift split them (SE-0117)

Library author için **inheritance surface kontrolü** — dışarıdan arbitrary override, internal implementation değişince client'ları **Liskov** riskine sokar. `open` **explicit opt-in**.

---

## 5. `open` + `final` = Compile Error

```swift
open final class Foo { }   // ❌ contradiction: open says subclassable, final forbids it
```

**Verdict:** Derlenmez.

**Method-level `final` on `open` class:** subclass var ama specific method **frozen**:

```swift
open class Animal {
    open func breathe() { }
    public final func heartbeat() { }   // cannot override this method even if class is subclassed
}
```

---

## 6. `private(set)` — Encapsulation

**Pattern:** Public read API + write only internally.

```swift
public class User {
    public private(set) var loginCount = 0

    public func recordLogin() {
        loginCount += 1
    }
}
```

**Engineering judgment:** Public mutable `var` genelde smell. Cache / internal state için tercih çoğu zaman `private var`.

---

## 7. `final` — Intent + Performance

| Axis | Effect |
|------|--------|
| **Intent** | "This type is not designed for inheritance" |
| **Performance** | **Devirtualization** — compiler direct call + inlining opportunity |

**Interview phrase:**
> *"`final` enables devirtualization: calls don't go through dynamic dispatch if the implementation is known closed."*

---

## 8. Code Review Pattern — Network Completion + `self`

### Common mistake wording

❌ *"This is definitely a retain cycle."*  
✅ *"Strong `self` capture in an escaping completion can extend VC lifetime and cause **stale UI updates** after dismissal. Not always a cycle — often **lifetime extension**. Fix with `[weak self]` + guard + optional cancellation / URL token."*

### Thread-safety follow-up

`Dictionary` is **not thread-safe**. If network completions mutate cache concurrently → synchronize via serial queue, lock, actor, or use `NSCache` (different semantics).

---

## 9. Delegate Pattern — Retain Cycle

**Graph:**

```
CheckoutVC ──strong──▶ PaymentProcessor ──strong──▶ delegate ──▶ CheckoutVC
```

**Fix:** `weak var delegate: PaymentDelegate?`

**Why `AnyObject` on protocol:**
> `weak` applies only to **reference types**; `AnyObject` makes the protocol **class-only**, so `weak` compiles.

**Swift notu:** `protocol PaymentDelegate: AnyObject { }` → **class-only** protocol (Swift 2–5'te `protocol PaymentDelegate: class` syntax'ı da vardı).

---

## 10. Drills — Self-Check Prompts

1. `public class C { public func f() {} }` — can another module `override f()`? Why?
2. `internal class Foo { public var x }` — compiles? What's the effective access outside module?
3. `private` property accessed from same-file `extension` — allowed in Swift 4+?
4. Delegate holds **strong** reference to VC — cycle or not? Minimum fix?

---

## References

- Swift Evolution [SE-0117 — Allow distinguishing between public access and public overridability](https://github.com/apple/swift-evolution/blob/main/proposals/0117-non-public-subclassable-by-default.md)
- Apple — [Access Control](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/)
- Related repo doc: [memory-management.md](memory-management.md)
