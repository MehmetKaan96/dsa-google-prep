# iOS Depth

Deep notes on iOS-specific interview topics. Populated during Phase 2-3 (Months 3-4).

## Planned Topics

### Memory Management
- [ ] ARC — retain/release, autorelease pools
- [ ] Strong / weak / unowned — when to use each
- [ ] Retain cycles — closures, delegates, parent-child
- [ ] Debugging leaks with Instruments (Leaks, Allocations)

### Concurrency
- [ ] GCD — queues, dispatch groups, barriers
- [ ] OperationQueue vs GCD
- [ ] Swift Concurrency — async/await, Task, TaskGroup
- [ ] Actors & isolation
- [ ] Sendable & data-race safety (Swift 6)
- [ ] Priority inversion, cancellation

### UIKit & SwiftUI
- [ ] Run loop, main thread, responder chain
- [ ] View lifecycle, layout pass (layoutSubviews, setNeedsLayout)
- [ ] Auto Layout internals, constraint solver
- [ ] SwiftUI diffing, body recomputation
- [ ] @State / @Binding / @ObservedObject / @StateObject — ownership rules

### App Architecture
- [ ] MVC / MVVM / MVP / VIPER / TCA — trade-offs
- [ ] Dependency injection patterns
- [ ] Coordinator pattern
- [ ] Reactive (Combine, RxSwift)

### Networking & Persistence
- [ ] URLSession, tasks, delegates
- [ ] Codable — custom decoders, defensive decoding
- [ ] Caching strategies (NSCache, disk, HTTP)
- [ ] Core Data / SwiftData / Realm trade-offs
- [ ] Offline-first sync patterns

### App Lifecycle & Background
- [ ] Application states (active / inactive / background / suspended)
- [ ] Background modes (fetch, processing, audio, location)
- [ ] BGTaskScheduler

### Testing
- [ ] XCTest fundamentals
- [ ] Unit vs integration vs snapshot vs UI tests
- [ ] Dependency injection for testability
- [ ] Mocking, stubbing, protocol-based seams

### Accessibility
- [ ] VoiceOver, accessibility labels/traits/hints
- [ ] Dynamic Type
- [ ] Reduced motion, contrast adaptations
