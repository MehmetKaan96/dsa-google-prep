# Recognition Set 01 — Memory / ARC

> Protokol: [00-PROTOCOL.md](00-PROTOCOL.md) · Harita: [00-RECOGNITION-MAP.md](00-RECOGNITION-MAP.md)
> Kuralı hatırla: `<details>`'i **açmadan** önce 5-adım cevabını ver (isim → severity → failure → fix → trade-off). Hedef: isim <10 sn.

---

## Drill 1 — Stored closure 🟢

```swift
final class FeedViewController: UIViewController {
    private let loader = FeedLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.onData = { data in
            self.render(data)
        }
    }
    func render(_ data: [Item]) { /* ... */ }
}
```

**Soru:** Buradaki sorunu bul, severity ve fix'i trade-off'la açıkla.

<details>
<summary>Model cevap (önce kendin çöz)</summary>

1. **İsim:** Retain cycle. `VC → loader → onData (closure) → self (strong)` → `VC`.
2. **Severity:** 🔴 Critical — `FeedViewController` hiçbir zaman dealloc olmaz; ekran kapansa bile bellekte kalır.
3. **Failure mode:** Kullanıcı ekrana her girişte yeni bir VC sızar; loader/observer'lar birikir, bellek şişer.
4. **Fix:**
   ```swift
   loader.onData = { [weak self] data in
       self?.render(data)
   }
   ```
5. **Trade-off:** `weak self` cycle'ı kırar; callback geldiğinde VC gitmişse `self?` no-op olur (güvenli). `unowned` daha ucuz ama VC nil olabildiği için crash riski — burada `weak` doğru seçim.

</details>

---

## Drill 2 — Delegate 🟢

```swift
protocol DownloadDelegate {
    func didFinish(_ url: URL)
}

final class Downloader {
    var delegate: DownloadDelegate?
}

final class DetailVC: UIViewController, DownloadDelegate {
    let downloader = Downloader()
    override func viewDidLoad() {
        super.viewDidLoad()
        downloader.delegate = self
    }
    func didFinish(_ url: URL) { /* ... */ }
}
```

**Soru:** İki ayrı problem var. İkisini de bul.

<details>
<summary>Model cevap</summary>

1. **İsim:** (a) Delegate retain cycle — `VC → downloader → delegate(strong) → VC`. (b) Protokol `AnyObject` değil, o yüzden `weak` bile yapılamaz (value type olabilir).
2. **Severity:** 🔴 Critical — cycle + `weak` uygulanamazlığı.
3. **Failure mode:** VC dealloc olmaz; ayrıca protokol class-bound olmadığından delegate'i `weak` yapmaya çalışırsan derlenmez.
4. **Fix:**
   ```swift
   protocol DownloadDelegate: AnyObject { func didFinish(_ url: URL) }
   final class Downloader { weak var delegate: DownloadDelegate? }
   ```
5. **Trade-off:** Delegate geri-referanstır → daima `weak` + class-bound protokol. Value-type delegate isteniyorsa closure/callback modeli tercih edilir; ama klasik delegate pattern `AnyObject` + `weak` ister.

</details>

---

## Drill 3 — Timer 🟡

```swift
final class CountdownVC: UIViewController {
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
    func tick() { /* update label */ }
}
```

**Soru:** Sorun ne? `weak self` eklemek yeterli mi?

<details>
<summary>Model cevap</summary>

1. **İsim:** Retain cycle — closure `self`'i strong yakalıyor; ayrıca `Timer` invalidate edilmezse run loop tarafından da canlı tutulur.
2. **Severity:** 🔴 Critical — VC hiç dealloc olmaz, timer sonsuza dek ateşlenir.
3. **Failure mode:** Ekrandan çıkılsa bile her saniye `tick()` çalışır, VC ve bağlı kaynaklar sızar.
4. **Fix:** İki parça birden gerekir:
   ```swift
   timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
       self?.tick()
   }
   // ve:
   deinit { timer?.invalidate() }
   ```
5. **Trade-off:** Sadece `[weak self]` yetmez — timer'ın kendisi `self`'i değil ama run loop timer'ı tutar; `invalidate()` olmadan timer ateşlenmeye devam eder. İkisi birlikte: cycle kırılır + kaynak serbest bırakılır.

</details>

---

## Drill 4 — Tuzak: sorun YOK 🔴

```swift
final class ProfileVC: UIViewController {
    private let service = ProfileService()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.fetch { [weak self] profile in
            guard let self else { return }
            self.updateUI(profile)
        }
    }
    func updateUI(_ p: Profile) { /* ... */ }
}
```

**Soru:** Buradaki memory bug nedir?

<details>
<summary>Model cevap</summary>

1. **İsim:** **Bug yok.** `[weak self]` + `guard let self` doğru kullanılmış; cycle yok, güvenli erken çıkış var.
2. **Severity:** 🟢 — flag edilecek bir şey yok. (Nit düzeyinde: `fetch` main thread'e dönüyor mu diye sorulabilir — ama bu concurrency, verilen memory sorusu değil.)
3. **Failure mode:** Yok.
4. **Fix:** Gerekmiyor. **Over-flag etme** — sağlam kodu "düzeltmeye" çalışmak da negatif sinyaldir.
5. **Trade-off:** Doğru refleks: "Burada capture list doğru, cycle yok. İsterseniz `fetch`'in hangi thread'e döndüğünü netleştirebilirim." — false positive'den kaçınmak senior sinyalidir.

</details>

---

## Drill 5 — Gereksiz weak 🟡

```swift
func computeChecksum(of data: Data, completion: (String) -> Void) {
    // senkron, closure escaping DEĞİL
    let hash = data.sha256Hex()
    completion(hash)
}

final class UploaderVC: UIViewController {
    func start(_ data: Data) {
        computeChecksum(of: data) { [weak self] hash in
            self?.showChecksum(hash)
        }
    }
    func showChecksum(_ s: String) { /* ... */ }
}
```

**Soru:** `[weak self]` burada doğru mu?

<details>
<summary>Model cevap</summary>

1. **İsim:** Gereksiz `[weak self]` — closure **non-escaping** ve **senkron**; saklanmıyor, cycle imkânsız.
2. **Severity:** 🟢 Minor — bug değil ama yanlış mental model sinyali.
3. **Failure mode:** Fonksiyonel zarar yok; ama `self?` gereksiz opsiyonellik ve okuyucuya "burada async/cycle riski var" gibi yanlış sinyal verir.
4. **Fix:** Capture list'i kaldır:
   ```swift
   computeChecksum(of: data) { hash in self.showChecksum(hash) }
   ```
5. **Trade-off:** `weak` cycle içindir. Non-escaping, senkron closure'da `self` zaten çağrı bitmeden yaşar; `weak` sadece gürültü ekler. Kuralı bilerek uygulamak (her yere değil) senior sinyalidir.

</details>

---

## Drill 6 — NotificationCenter 🟡

```swift
final class BadgeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self, selector: #selector(refresh),
            name: .cartUpdated, object: nil
        )
    }
    @objc func refresh() { /* ... */ }
}
```

**Soru:** Modern iOS'ta bile bu kodda ne eksik/riskli?

<details>
<summary>Model cevap</summary>

1. **İsim:** Observer temizliği yok — selector-based `addObserver` için `removeObserver` gerekir (klasik davranış). (iOS 9+ otomatik remove olsa da `object`/lifecycle nüansları ve block-based API farkları için hâlâ dikkat gerektirir.)
2. **Severity:** 🟡 Important — zombie/dupe callback ve mantık hataları; her `viewDidLoad`'da tekrar eklenirse **çift observer**.
3. **Failure mode:** VC birden çok kez yaratılırsa `refresh` her bildiride 2-3 kez çağrılır; ya da eski notification'lar beklenmedik anda tetiklenir.
4. **Fix:** Block-based + token tercih et, deinit'te temizle:
   ```swift
   private var token: NSObjectProtocol?
   token = NotificationCenter.default.addObserver(forName: .cartUpdated, object: nil, queue: .main) { [weak self] _ in
       self?.refresh()
   }
   deinit { token.map(NotificationCenter.default.removeObserver) }
   ```
5. **Trade-off:** Block API `[weak self]` + token ile hem cycle'ı hem çift-kayıt riskini yönetir; selector API daha eski ama manuel remove disiplini ister. Modern kodda block+token varsayılan.

</details>

---

## Sonraki
Bu set'i akıcı geçince → Set 02 (Concurrency). Zorlanılan drill'ler [SCHEDULE.md](../../../retrieval/SCHEDULE.md)'de "Recognition-MemARC" satırında Kutu 1'e düşer.
