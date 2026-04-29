# Mobile System Design

Phase 4 (Ay 5) boyunca dolar.

## Planlanan Problemler

- [ ] Design Instagram / Photo Feed
- [ ] Design Google Photos — offline sync & upload pipeline
- [ ] Design Push Notification pipeline
- [ ] Design a Real-time Chat client (iOS)
- [ ] Design an Image Caching & Prefetching system
- [ ] Design a Rate-Limited API client
- [ ] Design an Offline-first Todo sync
- [ ] Design a Video Player with adaptive bitrate

## Framework (Mobile System Design)

1. **Requirement clarify** — kullanıcı, scale, platform, offline support
2. **API contract** — REST/gRPC, request/response shape'leri
3. **Data model** — local persistence schema, invariant'lar
4. **Component diagram** — katman'lar: UI / ViewModel / Service / Repository / Network / Storage
5. **Sync strategy** — pull / push / bidirectional, conflict resolution
6. **Caching** — memory / disk, invalidation, TTL
7. **Failure mode'lar** — network kaybı, backgrounding, low memory
8. **Observability** — metric'ler, log'lar, crash reporting
9. **Security** — keychain, encryption at rest, TLS
10. **Testing** — unit / integration / load
