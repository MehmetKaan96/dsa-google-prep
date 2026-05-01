# Drills — GCD & DispatchGroup

## Drill 1 — `main.sync` deadlock

### Snippet

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    DispatchQueue.main.sync {
        self.title = "Hi"
    }
}
```

### Soru

`viewDidLoad` (main thread) içinde ne risk var?

### Model cevap

- **Deadlock:** main, sync ile kendi queue'sunda blok bekler; blok çalışması için main serbest olmalı → **kilit**.
- **Fix:** `DispatchQueue.main.async { self.title = "Hi" }` — `viewDidLoad` içinde `[weak self]` şart değil (kısa öneri).

---

## Drill 2 — `DispatchGroup` unbalanced `leave`

### Snippet

```swift
group.enter()
network.fetch { response in
    guard response.ok else { return }
    group.leave()
}
```

### Soru

Risk? Fix?

### Model cevap

- **Early return** → `leave` çağrılmaz → `notify` asla tetiklenmez veya grup asılı kalır.
- **Fix:** `defer { group.leave() }` completion başında (veya her branch'te dengeli `leave`).

---

## Drill 3 (ek) — URLSession completion + thread

### Snippet (özet)

`URLSession` completion içinde doğrudan `self.property = ...` ve `onUpdated?()` — UI tetikleniyor.

### Model cevap

- Completion **main garantisi yok** → state/UI **`DispatchQueue.main.async`**.
- **`[weak self]`** — stale update + gereksiz lifetime için (cycle her zaman değil).

---

## Ek kaynak

- [concurrency-gcd.md](../concurrency-gcd.md)
