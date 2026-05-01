# GCD & Queue Fundamentals — Interview Cheat Sheet

> **Session:** 2026-05-01 (Format A extension — main/global, groups, barrier, debounce)
> **Trendyol alignment:** project-based **code review** — thread safety, `main.async`, `weak self` in completions, cache mutation

---

## TL;DR

- **Main queue:** UIKit / SwiftUI UI updates → `DispatchQueue.main.async { }`
- **Global queues:** CPU / IO work → `DispatchQueue.global(qos:).async { }`
- **`async` vs `sync`:** async = enqueue and return; sync = wait for block → **`main.sync` from main = deadlock**
- **Serial vs concurrent:** serial = FIFO one-at-a-time; concurrent = multiple blocks may run in parallel
- **URLSession completion:** **not guaranteed on main** → parse background, **state/UI on main**; **`[weak self]`** to avoid stale updates / extended lifetime
- **`Dictionary` + concurrent writes:** not thread-safe → **barrier write** on concurrent queue, or **actor**, or lock
- **`DispatchGroup`:** `enter` / `leave` balanced → `notify(queue:)` when all done — use **`defer { group.leave() }`**
- **Debounce vs throttle:** debounce = fire after quiet window; throttle = cap max frequency

---

## 1. Mental Model

**Thread** = OS execution lane. **Queue** = closure work list (FIFO submission). GCD maps queued work to threads.

---

## 2. Main Queue

```swift
DispatchQueue.main.async {
    // UI updates
}
```

- Single serial queue bound to **main thread**
- Never: `DispatchQueue.main.sync { }` **from main** → deadlock

---

## 3. Global Queues

```swift
DispatchQueue.global(qos: .userInitiated).async {
    // heavy work
}
```

QoS hints: `.userInteractive` … `.background`

---

## 4. Custom Queues

```swift
let serial = DispatchQueue(label: "com.app.work")
let concurrent = DispatchQueue(label: "com.app.readwrite", attributes: .concurrent)
```

---

## 5. Reader–Writer (Barrier)

Concurrent reads, exclusive write:

```swift
private let q = DispatchQueue(label: "cache", attributes: .concurrent)
private var cache: [URL: Data] = [:]

func read(_ url: URL) -> Data? {
    q.sync { cache[url] }
}

func write(_ url: URL, _ data: Data) {
    q.async(flags: .barrier) {
        cache[url] = data
    }
}
```

---

## 6. DispatchGroup

```swift
let group = DispatchGroup()

group.enter()
worker.async {
    defer { group.leave() }
    // fetch A
}

group.enter()
worker.async {
    defer { group.leave() }
    // fetch B
}

group.notify(queue: .main) {
    // both finished
}
```

**Risk:** unmatched `enter`/`leave` → `notify` never fires or wrong semantics.

---

## 7. GCD vs OperationQueue

| Use GCD | Use OperationQueue |
|---------|---------------------|
| Simple `async` background work | Dependencies between operations |
| One-off closures | Cancellation (`cancel()`), complex pipelines |
| `DispatchGroup` for “all done” | `maxConcurrentOperationCount`, QoS chains |

**Phrase:** *“Simple work → GCD; dependencies + cancel → OperationQueue.”*

---

## 8. Debounce & Throttle

**Debounce:** wait for pause (search typing):

```swift
private var workItem: DispatchWorkItem?

func onChange() {
    workItem?.cancel()
    let item = DispatchWorkItem { [weak self] in self?.search() }
    workItem = item
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: item)
}
```

**Throttle:** cap rate (e.g. max 1 scroll event per 300ms).

---

## 9. Swift Concurrency (Preview)

- `async` / `await`, `Task { }`, `TaskGroup` — structured concurrency
- `actor` — isolated mutable state (alternative to barrier for cache)

**Honest line:** *“Strong in GCD + main-thread rules; Swift Concurrency used lightly in production — learning curve active.”*

---

## References

- Apple — [DispatchQueue](https://developer.apple.com/documentation/dispatch/dispatchqueue)
- Related: [memory-management.md](memory-management.md) (closure capture), [access-control.md](access-control.md)
