# Swift Concurrency — async/await (GCD üstüne)

> **Session:** 2026-06-06 · **CV bağlamı:** "Concurrency (Async/Await)" iddiasının savunması.

---

## TL;DR

- **Problem:** GCD completion handler nesting → "pyramid of doom", dağınık error handling
- **async/await:** async kodu senkron gibi okutur, error `try` ile `do/catch`'e bağlanır
- **`await` thread'i bloklamaz** → suspend olur, thread başka işe gider, sonuç gelince devam
- **`Task {}`** = senkron → async köprüsü
- **`actor`** = mutable state izolasyonu (barrier'ın modern hali)
- **`@MainActor`** = garantili main thread (UI)

---

## 1. Neden var?

```swift
// GCD — nested
fetchUser { user in
    fetchPosts(user) { posts in
        fetchComments(posts) { comments in /* ... */ }
    }
}

// async/await — düz
let user = try await fetchUser()
let posts = try await fetchPosts(user)
let comments = try await fetchComments(posts)
```

---

## 2. Anahtar Kelimeler

| Kelime | Anlam |
|--------|-------|
| `async` | Fonksiyon suspend edilebilir |
| `await` | Suspend ol, sonuç gelince devam — **thread bloklanmaz** |
| `Task { }` | Senkron dünyadan async'e giriş |
| `actor` | Mutable state'i data race'ten izole eder |
| `@MainActor` | Garantili main thread (UI) |

**Kritik:** `await` ≠ GCD `sync`. `sync` thread'i **bloklar**; `await` **suspend** eder (bloklamaz).

---

## 3. actor — data race çözümü

Actor reference type; **kendi mutable state'ine erişimi serialize eder** (aynı anda tek task). Dışarıdan erişim `await` ile.

> *"Actor mutable state'i izole eder; erişim await üzerinden serialize olur, data race compile-time engellenir."*

GCD karşılığı: **barrier reader-writer** → actor.

---

## 4. @MainActor (UI)

```swift
@MainActor func updateUI() { label.text = "Hi" }
```

GCD'deki `DispatchQueue.main.async` modern karşılığı.

---

## 5. CV Framing (dürüst + güçlü)

> *"Projede ağırlık GCD'ydi. Async/await'i yeni feature'larda — hem UIKit hem SwiftUI tarafında — kullanmaya başladık; legacy completion handler'ları kademeli migrate ediyoruz. Structured concurrency, suspend/resume, Task ve actor ile state isolation mantığını biliyorum."*

**Tuzak:** async/await ≠ SwiftUI'ye özel. İkisi bağımsız.

---

## References

- Apple — [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/)
- Related: [concurrency-gcd.md](concurrency-gcd.md)
