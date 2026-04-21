# Mobile System Design

Populated during Phase 4 (Month 5).

## Planned Problems

- [ ] Design Instagram / Photo Feed
- [ ] Design Google Photos — offline sync & upload pipeline
- [ ] Design Push Notification pipeline
- [ ] Design a Real-time Chat client (iOS)
- [ ] Design an Image Caching & Prefetching system
- [ ] Design a Rate-Limited API client
- [ ] Design an Offline-first Todo sync
- [ ] Design a Video Player with adaptive bitrate

## Framework (Mobile System Design)

1. **Clarify requirements** — users, scale, platforms, offline support
2. **API contract** — REST/gRPC, request/response shapes
3. **Data model** — local persistence schema, invariants
4. **Component diagram** — layers: UI / ViewModel / Service / Repository / Network / Storage
5. **Sync strategy** — pull / push / bidirectional, conflict resolution
6. **Caching** — memory / disk, invalidation, TTL
7. **Failure modes** — network loss, backgrounding, low memory
8. **Observability** — metrics, logs, crash reporting
9. **Security** — keychain, encryption at rest, TLS
10. **Testing** — unit / integration / load
