# iOS Depth

iOS'a özel mülakat topic'lerinin derin notları. Phase 2-3 (Ay 3-4) boyunca dolar.

**Code review drill bankası (Trendyol tarzı snippet'ler):** [drills/README.md](drills/README.md)

## Planlanan Topic'ler

### Swift Language Semantics
- [x] **Access Control — `open` / `public` / `internal` / `fileprivate` / `private` / `final` / `private(set)`** → [access-control.md](access-control.md)

### Memory Management
- [x] **ARC — retain/release** → [memory-management.md](memory-management.md)
- [x] **Strong / weak / unowned — hangisi ne zaman** → [memory-management.md](memory-management.md)
- [x] **Retain cycle'lar — closure'lar, delegate'ler, parent-child** → [memory-management.md](memory-management.md)
- [x] **Cycle vs lifetime extension vs RunLoop-rooted leak** → [memory-management.md](memory-management.md)
- [x] **Capture list'ler — `[weak self]` / `[unowned self]`** → [memory-management.md](memory-management.md)
- [ ] Autorelease pool — `@autoreleasepool` pattern'leri
- [ ] Instruments ile leak debugging (Leaks, Allocations) — pratik seans

### Concurrency
- [x] **GCD — queue'lar, DispatchGroup, barrier (reader-writer)** → [concurrency-gcd.md](concurrency-gcd.md)
- [x] **OperationQueue vs GCD (ne zaman hangisi)** → [concurrency-gcd.md](concurrency-gcd.md)
- [ ] Swift Concurrency — async/await, Task, TaskGroup
- [ ] Actor'lar & isolation
- [ ] Sendable & data-race safety (Swift 6)
- [ ] Priority inversion, cancellation

### UIKit & SwiftUI
- [ ] Run loop, main thread, responder chain
- [ ] View lifecycle, layout pass (layoutSubviews, setNeedsLayout)
- [ ] Auto Layout internals, constraint solver
- [ ] SwiftUI diffing, body recomputation
- [ ] @State / @Binding / @ObservedObject / @StateObject — ownership kuralları

### App Architecture
- [ ] MVC / MVVM / MVP / VIPER / TCA — trade-off'lar
- [ ] Dependency injection pattern'leri
- [ ] Coordinator pattern
- [ ] Reactive (Combine, RxSwift)

### Networking & Persistence
- [ ] URLSession, task'lar, delegate'ler
- [ ] Codable — custom decoder'lar, defensive decoding
- [ ] Caching strategy'leri (NSCache, disk, HTTP)
- [ ] Core Data / SwiftData / Realm trade-off'ları
- [ ] Offline-first sync pattern'leri

### App Lifecycle & Background
- [ ] Application state'leri (active / inactive / background / suspended)
- [ ] Background mode'lar (fetch, processing, audio, location)
- [ ] BGTaskScheduler

### Testing
- [ ] XCTest fundamentals
- [ ] Unit vs integration vs snapshot vs UI tests
- [ ] Testability için dependency injection
- [ ] Mocking, stubbing, protocol-based seam'ler

### Accessibility
- [ ] VoiceOver, accessibility label/trait/hint
- [ ] Dynamic Type
- [ ] Reduced motion, contrast adaptation'ları
