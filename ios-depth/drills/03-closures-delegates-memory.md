# Drills — Closures, Delegates, Memory

## Drill 1 — `onDismiss` closure + ViewController

### Snippet

```swift
final class PaywallVM {
    var onDismiss: (() -> Void)?
    func close() { onDismiss?() }
}

final class PaywallVC: UIViewController {
    private let vm = PaywallVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
```

### Soru

`[weak self]` hangi riskleri yönetir?

### Model cevap

- **Strong capture olsaydı:** `VC` → `vm` → `closure` → **`self` strong** → **retain cycle** riski.
- **`weak self`:** cycle kesilir; ayrıca VC artık gerekmiyorsa **gereksiz tutma** azalır.
- **`self?` / `guard let self`** — dismiss anında nil ise **safe** kalır.

---

## Drill 2 — Kavram (sözel)

**İddia:** *"`[weak self]` retain cycle'ı her zaman keser."*

### Model cevap

- **Hayır.** Cycle **strong `self` capture** zincirinin parçasıysa `weak` **kırar**; cycle yoksa `weak` sadece **lifetime / stale callback** yönetir.

---

## Drill 3 (ek) — Delegate pattern

### Snippet özeti

```swift
class Processor {
    var delegate: SomeDelegate?  // strong
}
class VC: SomeDelegate {
    let processor = Processor()
    // viewDidLoad: processor.delegate = self
}
```

### Model cevap

- **Graph:** `VC` → `processor` **strong** → `delegate` **strong** → `VC` → **cycle**.
- **Fix:** `weak var delegate: SomeDelegate?` + protokol **`AnyObject`**.

---

## Drill 4 (ek) — ImageDownloader + cache (memory + concurrency)

TableView cell içinde network completion, `[weak self]` yok, cache **Dictionary** birden fazla thread'te — **stale callback**, **thread-safety**, **lifetime extension** ayrı ayrı düşünülür.

---

## Ek kaynak

- [memory-management.md](../memory-management.md)
- [access-control.md](../access-control.md) (delegate `AnyObject` notu)
