# iOS Memory Management — ARC Deep-Dive

> **Kapsam:** ARC mekanizması, garbage collection karşılaştırması, strong/weak/unowned, retain cycle çeşitleri, closure capture lists, lifetime extension, RunLoop-rooted leak'ler, gerçek dünya pratik örnekleri.
>
> **Hedef:** Trendyol iOS phone screen + Google iOS L3 hazırlık.

---

## 1. ARC Nedir?

**Automatic Reference Counting** — Swift compiler her reference type için bir **reference count** (refCount) tutar. Compile time'da otomatik insert edilen `retain` ve `release` çağrılarıyla yönetilir. Count `0`'a düştüğünde instance deallocate edilir ve `deinit` çağrılır.

### Önemli Detaylar

- ARC sadece **reference types**'ta çalışır: `class`, `closure`, `actor`
- **Value types** (`struct`, `enum`, primitives) ARC dışıdır — copy semantics
- Compile-time'da `retain` / `release` çağrıları otomatik insert edilir
- Çalışması **deterministic** — pause time yok

### Örnek

```swift
class Person {
    let name: String
    init(_ n: String) { name = n }
    deinit { print("\(name) deinit") }
}

let a = Person("Mehmet")  // refCount = 1
let b = a                 // refCount = 2 (strong reference shared)
let c = a                 // refCount = 3
// Scope ends → refCount: 3 → 2 → 1 → 0 → "Mehmet deinit"
```

---

## 2. ARC vs Garbage Collection

| Özellik | **ARC (Swift, ObjC)** | **Tracing GC (Java, JS, Go)** |
|---------|----------------------|-------------------------------|
| Ne zaman çalışır? | Compile time, deterministic | Runtime, non-deterministic |
| Performance overhead | Her ref atamada count++/-- | Periyodik scan + pause |
| Pauses (stop-the-world) | YOK | VAR |
| Memory predictability | Object exact zamanda free | "Bir gün toplanır" |
| Cycle handling | Manuel (`weak`/`unowned`) | Otomatik (cycle detection) |
| Real-time uygunluğu | Mobil için ideal | Game / mobile için risk |
| Code complexity | Daha çok dikkat | Daha az |

### Senior Cümlesi (Memorize)

> *"ARC is deterministic and compile-time — predictable lifetimes, no pause times, ideal for mobile. The trade-off is manual cycle management with `weak` and `unowned`. GC handles cycles automatically but introduces non-deterministic pauses, which is unacceptable for real-time UI work."*

### Apple Neden ARC Seçti?

1. **Predictable performance** — UI thread'de pause yok
2. **Memory efficiency** — instance ölür ölmez free, peak memory düşük
3. **Real-time guarantees** — animasyon, gesture, audio için kritik
4. **Battery** — periyodik GC scan'i battery'yi yer

---

## 3. RefCount Storage — Internals

```
┌─────────────────────────────────┐
│       HeapObject (header)        │
├─────────────────────────────────┤
│  isa pointer (type metadata)     │  ← class type'ı
│  refCount bits (INLINE)          │  ← strong + unowned + flags
├─────────────────────────────────┤
│  ... actual properties ...       │
└─────────────────────────────────┘
```

- **Primary:** Strong refCount **inline**, object header'da → cache-friendly
- **Side table:** Sadece **lazy** oluşturulur şu durumlarda:
  - Object'e bir **weak reference** atanırsa (zeroing bookkeeping için)
  - Inline counter **overflow** ederse (çok nadir)
  - **Unowned** ref tracking ile deinit sonrası

### Senior Cümlesi

> *"Strong reference counts are stored inline in the object header for cache locality. Swift lazily allocates a 'side table' only when weak references appear, since weak refs need extra bookkeeping to be zeroed-out on deinit."*

---

## 4. Strong / Weak / Unowned — Reference Çeşitleri

### A) Strong Reference (Default)

```swift
var person: Person = Person("Ali")  // implicit STRONG
```

- RefCount **+1** atamada
- RefCount **-1** scope çıkışında / nil atamada
- **Default**, yazmazsan strong
- Object'i **alive tutar**

**Use case:** Default. Owner-owned ilişkisi (Parent → Child).

---

### B) Weak Reference

```swift
weak var delegate: SomeDelegate?  // MUST be optional + var
```

- RefCount'u **artırmaz** (object'i alive tutmaz)
- Target deinit olursa → **otomatik `nil`** olur (zeroing weak reference)
- **Optional olmak ZORUNDA** — runtime'da nil olabilir
- **`var` olmak ZORUNDA** — değişebilmesi lazım
- Side table burada devreye girer

**Use case:**
- Geri yönlü referans (Child → Parent)
- Delegate pattern
- Observer pattern

```swift
class ViewController {
    var childView: ChildView?           // strong (parent owns child)
}
class ChildView {
    weak var parent: ViewController?    // weak (child observes parent)
}
```

---

### C) Unowned Reference

```swift
unowned let owner: Owner  // NON-optional, can be let
```

- RefCount'u **artırmaz**
- Target deinit olsa bile **nil OLMAZ** → **dangling pointer**
- Erişim → **CRASH** (`EXC_BAD_ACCESS`)
- **Non-optional** olabilir
- **`let` olabilir** (immutable)

**Use case:** Target'ın self'ten **GUARANTEED uzun yaşadığı** durumlar.

```swift
class Customer {
    var card: CreditCard?
}
class CreditCard {
    unowned let owner: Customer    // card cannot exist without owner
    init(owner: Customer) { self.owner = owner }
}
```

---

### Decision Tree (EZBERLE)

```
Reference cycle riski var mı?
│
├─ YOK → strong (default)
│
└─ VAR → Target self'ten uzun yaşar mı?
         │
         ├─ HAYIR (kısa yaşayabilir, nil olabilir) → weak
         │
         └─ EVET (her zaman alive) → unowned
```

**Pratik kural:** **Tereddüt edersen `weak` kullan.** Crash riski yok, sadece nil-check yap. `unowned` performance avantajı marjinal — risk büyük.

### Senior Cümlesi

> *"I default to `weak` because it's safe — automatically nilled and forces me to handle the absence. I only use `unowned` when there's a guaranteed lifetime relationship — like when the target is a parent that strictly outlives the child, and the performance cost of optional unwrapping is measurably significant. In doubt, `weak` always wins because dangling pointer crashes are far worse than an extra optional check."*

---

## 5. Retain Cycle Çeşitleri

### A) Class-Class Mutual Strong

```swift
class A { var b: B? }
class B { var a: A? }   // ← strong, mutual

var a: A? = A()         // a refCount = 1
var b: B? = B()         // b refCount = 1
a?.b = b                // b refCount = 2
b?.a = a                // a refCount = 2

a = nil                 // a refCount = 1 (b hala tutuyor)
b = nil                 // b refCount = 1 (a hala tutuyor)

// Hiçbiri 0'a düşmez → MEMORY LEAK
// deinit ASLA ÇAĞRILMAZ
```

**Fix:**

```swift
class B {
    weak var a: A?      // cycle kırıldı
}
```

---

### B) Closure-Class Cycle (En Sık)

```swift
class ViewModel {
    var name: String = "Mehmet"
    var onComplete: (() -> Void)?

    init() {
        onComplete = {
            print(self.name)   // ← self'i strong capture
        }
    }
}

var vm: ViewModel? = ViewModel()
vm = nil
// vm DEALLOCATE OLMAZ → LEAK
```

**Cycle Analizi:**

```
ViewModel ──strong──> closure (onComplete property)
   ▲                      │
   └──── strong (capture)─┘
```

**Fix — Capture List:**

```swift
init() {
    onComplete = { [weak self] in
        guard let self else { return }
        print(self.name)
    }
}
```

---

### C) Önemli Kural — Weak Cycle'ı Sadece İçinde Bulunduğu Kenarda Kırar

> **"Weak references cannot fix cycles they're not part of."**

`weak var vm: ViewModel? = ViewModel()` retain cycle'ı **çözmez** çünkü:

1. Cycle **internal** (ViewModel ↔ closure arasında), dışarıdaki ref alakasız
2. Weak references **sole owner olamaz** — yoksa object doğum anında ölür
3. Doğru fix her zaman **cycle'ın olduğu kenarda** olmalı (capture list)

---

## 6. Capture List Mekaniği

```swift
{ [weak self, unowned service, value = self.value] in
   //  ↑↑↑↑↑↑↑↑↑↑  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑   ↑↑↑↑↑↑↑↑↑↑↑↑↑
   //  weak ref     unowned ref      capture by VALUE (snapshot)
}
```

**Kritik kural:** Capture list **closure tanımlandığında** evaluate edilir.

```swift
var counter = 0
let snapshot = { [counter] in
    print(counter)         // SNAPSHOT: 0
}
let referenced = {
    print(counter)         // REFERENCE: current value
}
counter = 100
snapshot()                 // 0
referenced()               // 100
```

---

## 7. `[weak self]` Kullanım Kuralları

### Ne Zaman Gerekir?

Closure self'i capture ediyorsa **VE** closure escape ediyorsa (yani çağrıldıktan sonra hala alive kalabilirse):

- Network callback (URLSession completion)
- Combine subscription (`sink`)
- Timer (`Timer.scheduledTimer { ... }`)
- NotificationCenter block-based observer
- DispatchQueue async
- Long-running async/await Task

### Ne Zaman Gerekmez?

1. **Closure self capture etmiyor**
2. **Synchronous closure** — `map`, `filter`, `forEach` (anında çalışır)
3. **Non-escaping closures** — function scope'tan çıkmaz

### Modern Idiom (Swift 5.7+)

```swift
{ [weak self] in
    guard let self else { return }
    self.doSomething()
    self.updateUI()
}
```

---

## 8. Cycle ≠ Lifetime Extension ≠ RunLoop-Rooted Leak

Bu üç leak tipi **mülakatta ayırt edilmesi kritik**.

| Tip | Tanım | Süre | Örnek |
|-----|-------|------|-------|
| **Retain Cycle** | Object'ler birbirini tutuyor, sonsuza kadar yaşar | Permanent | A↔B mutual strong, ViewModel↔closure |
| **Lifetime Extension** | Closure self'i tutar, async iş bitince serbest bırakır | Temporary | URLSession completion, GCD async |
| **RunLoop-Rooted Leak** | RunLoop bir nesneyi süresiz tutar, zincirleme self alive kalır | Permanent (invalidate'e kadar) | Timer, RunLoop sources |

### Senior Cümlesi (Lifetime Extension için)

> *"This isn't a retain cycle — there's no permanent leak because the closure isn't stored. It's a temporary strong reference held by GCD until the async work completes. The risk isn't a leak; it's lifetime extension and stale callbacks. We use `[weak self]` to allow earlier deallocation and prevent operating on a dying instance."*

### Senior Cümlesi (RunLoop-Rooted Leak için)

> *"This isn't a retain cycle — there's no closed loop. The leak is a RunLoop-rooted strong chain: the RunLoop strongly retains the Timer, the Timer retains the closure, and the closure captures self. Without invalidation, the RunLoop never releases the Timer, so self stays alive permanently."*

---

## 9. Struct'larda Cycle Olur mu?

**Hayır.** Sebep:

1. Struct **value type** → ARC dışı → refCount yok
2. Struct'a closure property koyulabilir, **AMA** closure self'i capture ederse value-by-copy alır
3. Cycle için iki **reference-counted node** gerekir → struct'ta yok

```swift
struct Counter {
    var count = 0
    var increment: (() -> Void)?
    init() {
        increment = {
            print(self.count)   // self burada VALUE COPY, struct'ı tutmaz
        }
    }
}
```

### Edge Case

Struct **içinde class instance** varsa, o class üzerinden cycle hala oluşabilir:

```swift
struct Wrapper {
    let object: SomeClass    // ← REFERENCE inside value type
}
// Wrapper kendisi cycle yapamaz, ama object cycle'a girebilir.
```

---

## 10. Pratik Drill #1 — TableView Image Download

**Senaryo:** TableView'da 1000 cell var. Her cell'de bir image download ediliyor ve completion'da `self.imageView.image = result` set ediliyor.

```swift
class ImageCell: UITableViewCell {
    @IBOutlet weak var imageView: UIImageView!

    func configure(url: URL) {
        ImageDownloader.shared.download(url) { result in
            self.imageView.image = result    // ← strong capture
        }
    }
}
```

### İki Ayrı Problem

**Problem 1 — Memory (Lifetime Extension):**
- Closure self'i strong capture, network süresince cell alive
- Cycle değil, lifetime extension (URLSession completion'ı store etmiyor)
- 1000 cell × 2sn → memory peak

**Problem 2 — Correctness (Stale Callback):**
- Cell reuse pattern: `T=0` URL_A başlar → `T=1` cell reuse, URL_B başlar → `T=3` URL_A response gelir → **yanlış imaj**

### Tam Çözüm

```swift
class ImageCell: UITableViewCell {
    @IBOutlet weak var imageView: UIImageView!

    private var currentURL: URL?
    private var downloadTask: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()         // ① eski download'ı iptal
        downloadTask = nil
        imageView.image = nil          // ② placeholder reset
        currentURL = nil
    }

    func configure(url: URL) {
        currentURL = url
        downloadTask = ImageDownloader.shared.download(url) {
            [weak self] result in       // ③ memory: weak self
            guard let self else { return }
            guard self.currentURL == url else { return }   // ④ stale check
            self.imageView.image = result
        }
    }
}
```

### Senior Cevap (Trendyol için)

> *"İki ayrı problem var. Birincisi memory: closure self'i strong capture ediyor, network süresince cell alive kalıyor. Bu cycle değil, lifetime extension — fix `[weak self]`.*
>
> *İkincisi correctness, daha kritik: cell reuse pattern'inde aynı cell instance farklı URL'ler için yeniden konfigüre olur. Yavaş gelen bir A response, B konfigürasyonu zamanında self.imageView'a yazıp yanlış imajı gösterir.*
>
> *Çözüm üç katmanlı: `prepareForReuse`'da eski task'ı cancel et ve image'ı nil'le, `[weak self]` ile capture et, callback'te `currentURL == url` guard'ı ile cell hala bu URL'i mi istiyor kontrol et."*

---

## 11. Pratik Drill #2 — Banner Timer in ViewController

**Senaryo:** Home screen'de 3 saniyede bir banner değişen carousel.

```swift
class HomeViewController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView!
    var images: [UIImage] = ProductService.bannerImages
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.index = (self.index + 1) % self.images.count
            self.bannerImageView.image = self.images[self.index]
        }
    }
}
```

### Problem — RunLoop-Rooted Leak (CYCLE DEĞİL)

```
RunLoop ──strong──> Timer ──strong──> block ──strong──> self (HomeVC)
                                                          │
                                                          ✗ (kapanış yok)
```

**Cycle değil**, çünkü kapalı döngü yok. RunLoop kök, zincir self'te bitiyor. Ama `invalidate()` çağrılmazsa RunLoop Timer'ı sonsuza kadar tutar → self leak.

### TRAP — `deinit` İçinde `invalidate` ASLA Çalışmaz

```swift
deinit {
    timer?.invalidate()   // ← ÇAĞRILMAZ
}
```

**Neden:** Timer self'i tutuyor → self.refCount asla 0 olmaz → deinit asla tetiklenmez → invalidate asla çağrılmaz. Klasik **chicken-and-egg** problemi.

### Doğru Fix — Üç Katman

```swift
class HomeViewController: UIViewController {
    @IBOutlet weak var bannerImageView: UIImageView!
    var images: [UIImage] = ProductService.bannerImages
    var index = 0

    private var bannerTimer: Timer?    // ← ① property olarak STORE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBannerTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerTimer?.invalidate()      // ← ② screen kaybolurken durdur
        bannerTimer = nil
    }

    private func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {
            [weak self] timer in       // ← ③ weak self
            guard let self else {
                timer.invalidate()     // ← ④ self öldüyse self-cleanup
                return
            }
            self.index = (self.index + 1) % self.images.count
            self.bannerImageView.image = self.images[self.index]
        }
    }
}
```

### Genel Prensip

> **Cleanup'ı her zaman explicit lifecycle hook'a koy. `deinit`'i fallback olarak kullan, primary cleanup point DEĞİL.**

| Cleanup Point | Ne Zaman |
|---------------|----------|
| `prepareForReuse` (Cell) | Cell yeniden konfigüre edilirken |
| `viewWillDisappear` (VC) | Screen gizlenirken |
| `deinit` (Object) | Sadece son güvenlik ağı, asla primary cleanup |

---

## 12. Memory Leak Debug Araçları

### 1. Xcode Memory Graph Debugger

- Run sırasında `⏸ Pause` → Memory Graph icon
- Object graph görselleştirilir
- **Purple `!`** işareti → cycle warning
- Beklenmeyen instance count → leak işareti

### 2. Instruments → Leaks

- Long-running session'da accumulating leak'leri yakalar
- Allocation backtrace ile root cause'a iner

### 3. Smoke Test (Hızlı)

```swift
deinit {
    print("\(type(of: self)) deinit")
}
```

Senaryo sonunda print görünmüyorsa → leak.

### Workflow

1. **Smoke test** → şüpheli class'a print koy
2. **Memory Graph** → cycle var mı görselleştir
3. **Capture list fix** → cycle'ı kır
4. **Tekrar test** → deinit print'i artık görünmeli

---

## 13. Trendyol-Likely Interview Soruları

### Q1: "ARC nedir?"

> *"Automatic Reference Counting'in kısaltması. Swift compiler her reference type için bir reference count tutar; bu değer compile time'da otomatik insert edilen retain/release çağrılarıyla yönetilir. Count sıfıra düştüğünde instance deallocate edilir ve `deinit` çağrılır.*
>
> *Garbage collection'dan en büyük farkı **deterministic** olması — instance ne zaman öldüğünü kesin bilirim, pause time yok. Bu mobile UI için kritik. Trade-off: cycle'ları manual yönetmek zorundayım, `weak` ve `unowned` ile."*

### Q2: "Strong, weak, unowned arasındaki fark?"

> *"Strong default'tur, refCount'u +1 yapar, object'i alive tutar.*
>
> *Weak refCount'u artırmaz, target deinit olunca otomatik nil olur. Optional ve var olmak zorunda. Delegate pattern'de, parent-child ilişkisinde child'dan parent'a bakmak için kullanırım.*
>
> *Unowned da refCount'u artırmaz ama auto-nil değil — target ölürse dangling pointer, erişim crash. Non-optional, let olabilir. Sadece target'in self'ten guaranteed uzun yaşadığı durumda kullanırım, mesela CreditCard → Customer ilişkisi.*
>
> *Pratik olarak tereddüt edersem `weak` seçerim — crash riski yok, sadece bir nil-check."*

### Q3: "Retain cycle ne demek? Nasıl debug edersin?"

> *"İki object'in birbirini strong tuttuğu durum. Hiçbiri refCount sıfıra düşemez, deinit hiç çağrılmaz, memory leak.*
>
> *En klasik örnek closure-class: bir class closure property tutar, closure içinde `self` strong capture edilir. Cycle.*
>
> *Debug için Xcode Memory Graph kullanırım — runtime'da object graph'ı görselleştirir, leak'leri purple `!` ile işaretler. Instruments'taki Leaks instrument allocation timeline ile cycle'ları yakalar. Bir alternatif: deinit içine print koyup ekrandan çıktığında çağrılıyor mu kontrol etmek — quick smoke test."*

### Q4: "[weak self] ne zaman kullanırsın, ne zaman gerekmez?"

> *"Closure self'i capture ediyorsa ve bu closure escape ediyorsa — yani çağrıldıktan sonra hala alive kalabilirse — `[weak self]` kullanırım. En sık: network callback, Combine subscription, Timer, NotificationCenter, GCD async.*
>
> *Gerek olmayan durumlar: closure self capture etmiyorsa, synchronous closure (map, filter, forEach), non-escaping closures.*
>
> *Önemli detay: `[weak self]` ile başlarken `guard let self else { return }` koyarım — clean code, ardışık `self?.` zincirinden kaçınmak için."*

### Q5: "Memory leak'i nasıl bulursun?"

> *"Üç araç: Memory Graph Debugger, Instruments Leaks, smoke test (deinit print).*
>
> *Workflow: önce smoke test, leak doğrulanırsa Memory Graph ile cycle'ı görselleştir, fix capture list'le."*

### Q6: "Value type ile reference type arasındaki fark? ARC açısından?"

> *"Value types — struct, enum, primitives — her atamada kopyalanır. ARC'a tabi değiller. Çoğunlukla stack'te yaşarlar.*
>
> *Reference types — class, closure, actor — pointer üzerinden paylaşılır. Atama refCount artırır, ARC yönetir, heap'te yaşar.*
>
> *Praktik karar: identity (eşsizlik) lazımsa, inheritance / polymorphism lazımsa class. Onun dışı struct — Apple'ın 'value type by default' tavsiyesi. Performans olarak da küçük struct'lar daha hızlı çünkü heap allocation yok, refCount overhead yok."*

---

## 14. Bu Session'da Yapılan Hatalar (Lessons Learned)

| # | Hata | Düzeltme |
|---|------|----------|
| 1 | "Unowned crash → target self'ten **uzun** yaşıyor" dedim | TERS: target **kısa** yaşıyor (erken ölüyor), söz bozuluyor |
| 2 | "[unowned self] target = view controller, self = closure'in bulunduğu class" | `[unowned self]`'te self **closure'ın yakaladığı** class'tır |
| 3 | URLSession async closure için "retain cycle var" dedim | CYCLE değil, **lifetime extension** (closure store edilmiyor) |
| 4 | "Closure'lar struct'larda çalışmaz" dedim | Çalışır, ama struct value type olduğu için **cycle yapamaz** |
| 5 | Timer drill'inde "retain cycle" dedim | CYCLE değil, **RunLoop-rooted leak** (kapanış yok, düz zincir) |
| 6 | Timer cleanup için `deinit`'te `invalidate` önerdim | TRAP: deinit asla çağrılmaz → `viewWillDisappear` doğru yer |
| 7 | İlk drill'de stale callback / cell reuse problem'ini gözden kaçırdım | İki ayrı problem var: memory + correctness |

### Reusable Patterns (İleride Kullanmak İçin)

1. **Cycle vs lifetime extension vs RunLoop leak** — terminoloji ayrımını yap, fix benzer ama isimlendirme önemli
2. **Cleanup → lifecycle hook** — `deinit` primary cleanup değil, fallback
3. **Cell reuse → prepareForReuse + currentURL guard** — memory + correctness ikisi birden
4. **Timer → property olarak store + viewWillAppear/Disappear** — start/stop cycle
5. **`[weak self]` + `guard let self else { return }`** — modern idiom

---

## 15. Re-solve Protocol (Spaced Repetition)

Bu doc'u **kapatmadan tekrarla**:

- **+1 gün:** Section 4 (Strong/Weak/Unowned) + Section 5 (Cycle çeşitleri) — 5 dk recall
- **+3 gün:** Section 8 (Cycle vs Lifetime ext vs RunLoop) + Section 14 (hatalar) — 10 dk
- **+1 hafta:** Drill 1 + Drill 2 cold solve — 15 dk
- **+2 hafta:** Tüm doc + Section 13 (interview soruları) — 30 dk
- **+1 ay:** Cold mock — herhangi bir leak senaryosu

---

## 16. Follow-up Topics (İleride)

- [ ] **Autorelease pools** — `@autoreleasepool` ne zaman gerekli (image loop, batch processing)
- [ ] **Swift Concurrency + actors** — `Task` capture rules, Sendable
- [ ] **Combine retain cycles** — `sink` / `assign(to:)` / `AnyCancellable` ownership
- [ ] **NotificationCenter** — block-based observer leak'leri
- [ ] **Delegates** — neden `weak var delegate` zorunlu (custom protocol class-bound `: AnyObject`)
- [ ] **Background tasks + lifecycle** — UIApplication lifecycle ile memory yönetimi
- [ ] **Swift 6 strict concurrency** — `@MainActor`, isolated state, capture semantics
