# iOS Testing — Unit / UI / DI

> **Session:** 2026-06-07 · **CV bağlamı:** "Unit/UI Testing (XCTest, XCUI)"

---

## TL;DR

- **Unit test:** business logic / ViewModel — hızlı, izole
- **UI test:** ekran component'leri + akış (XCUI) — yavaş, e2e
- **AAA:** Arrange → Act → Assert
- **DI + mock:** test edilebilirliğin anahtarı (SOLID-D)
- **Coverage:** sinyal, hedef değil

---

## 1. Unit vs UI

| | Unit | UI (XCUI) |
|--|------|-----------|
| Test eder | Logic, ViewModel, fonksiyon | Ekran + kullanıcı akışı |
| Hız | Hızlı | Yavaş |
| Kırılganlık | Düşük | Yüksek (UI değişince kırılır) |

---

## 2. AAA Yapısı

```
Arrange: mock service + ViewModel kur
Act:     vm.login()
Assert:  XCTAssertEqual(vm.state, .success)
```

---

## 3. DI + Mock (test edilebilirlik)

ViewModel somut servise değil **protocol**'e bağımlı; **init'ten enjekte**:

```swift
final class LoginViewModel {
    private let service: AuthServiceProtocol
    init(service: AuthServiceProtocol) { self.service = service }
}
```

Test'te **mock**, prod'da **gerçek**. → SOLID-D ile birebir.

> *"DI sayesinde test izole, hızlı, deterministik."*

---

## 4. Code Coverage

Test'lerin kodun **% kaçını çalıştırdığı**. **%100 ≠ iyi test:**
- Coverage satırın **çalıştığını** gösterir, **doğru assert edildiğini değil**
- Assert kalitesi + edge case > ham coverage

---

## References

- Apple — [XCTest](https://developer.apple.com/documentation/xctest)
- Related: [architecture.md](architecture.md) (SOLID-D, DI)
