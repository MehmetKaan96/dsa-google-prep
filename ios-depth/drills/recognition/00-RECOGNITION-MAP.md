# 00 — CODE RECOGNITION MAP

> **Amaç:** Mülakatçı bir kod parçası gösterdiğinde **saniyeler içinde** "burada şu var" diyebilmek.
> DSA tarafındaki [00-PATTERN-TRIGGERS](../../../concepts/00-PATTERN-TRIGGERS.md)'in code-review karşılığı.
> Kullanım: kodu tararken **sol kolondaki "tell"i** ara → refleks teşhise git → severity + fix + trade-off cümlesi.
> Cevap iskeleti (her drill için): **1) İsimlendir (<10 sn) → 2) Severity → 3) Failure mode/neden → 4) Minimal fix → 5) Trade-off/savunma cümlesi.**

---

## Tarama refleksi — koda bakınca önce bunlara bak

1. **`self` bir escaping/stored closure içinde mi?** → capture list var mı?
2. **UI güncellemesi bir completion/async içinde mi?** → main thread mi?
3. **Paylaşılan mutable state (var dict/array) birden fazla thread'ten mi?** → data race?
4. **`!`, `try!`, `as!`** → force unwrap/crash yüzeyi
5. **`delegate` strong mu?** → cycle
6. **Network çağrısı** → timeout? retry? cancellation? error path?

---

## 1. Memory / ARC

| Tell (kodda gör) | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------------------|----------------|----------|-----|-------------------|
| Escaping/stored closure içinde `self.` , capture list yok | **Retain cycle** riski | 🔴 | `[weak self]` + `guard let self` | *"Closure'ı obje strong tutuyorsa cycle; weak ile kırıyorum."* |
| `var delegate: SomeDelegate?` (weak değil) | Delegate retain cycle | 🔴 | `weak var delegate` + protokol `: AnyObject` | *"Delegate geri-referans; weak olmalı yoksa iki taraf birbirini tutar."* |
| `Timer.scheduledTimer(... target: self ...)` | Timer `self`'i strong tutar | 🔴 | `[weak self]` block API / `invalidate()` deinit'te | *"Timer target'ı retain eder; VC hiç dealloc olmaz."* |
| `NotificationCenter.addObserver` + `removeObserver` yok | Observer leak / zombie callback | 🟡 | block API + token, veya deinit'te remove | *"Modern API token döndürür; eski selector API'de remove şart."* |
| Her yerde `[weak self]` (cycle yokken bile) | Gereksiz weak → erken nil, stale UI | 🟢 | Cycle yoksa strong bırak | *"Weak cycle içindir; olmayan yerde davranışı bozar."* |
| `ArraySlice` bir property'de saklanıyor | Parent buffer retain → gizli leak | 🟡 | `Array(slice)` ile kopyala | *"Slice büyük buffer'ı canlı tutar."* |

## 2. Concurrency

| Tell | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------|----------------|----------|-----|-------------------|
| Completion içinde `label.text = ...` / `tableView.reload` | **UI off main thread** | 🔴 | `DispatchQueue.main.async` / `@MainActor` | *"UIKit main-thread-only; değilse görünmez crash/UI bozulması."* |
| `DispatchQueue.main.sync { }` main thread'ten | **Deadlock** | 🔴 | `async`, veya zaten main ise direkt çalıştır | *"Main kendini bekler → kilitlenir."* |
| Shared `var dict/array` birden çok thread'ten yaz/oku | **Data race** | 🔴 | serial queue / actor / lock | *"Swift Dictionary thread-safe değil; concurrent mutation UB."* |
| `DispatchGroup` `enter()` var, `leave()` bir path'te yok | `notify` hiç gelmez / eksik gelir | 🔴 | Her exit path'te tam bir `leave()` (defer) | *"Enter/leave dengesi bozuksa grup asılı kalır."* |
| `async` closure, `[weak self]` yok, uzun iş | Lifetime extension / geç iş | 🟡 | `[weak self]` + iptal | *"İş bitene kadar obje canlı; iptal edilebilir olmalı."* |
| `Task { }` saklanmıyor / cancel edilmiyor | İptal edilemeyen iş, yarış | 🟡 | `let task = Task{}`; `deinit`/`onDisappear`'da `cancel()` | *"Structured concurrency'de iptal edilebilirlik ister."* |
| Completion handler iki path'te çağrılıyor / hiç çağrılmıyor | Double/never callback | 🔴 | Tek çıkış, `defer`/state guard | *"At-most/at-least-once garantisi net olmalı."* |

## 3. SwiftUI

| Tell | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------|----------------|----------|-----|-------------------|
| `body` içinde ağır hesap / sort / network | Her render'da tekrar → jank | 🔴 | Hesabı model/`onAppear`/cached'e taşı | *"body pure ve ucuz olmalı; sık ve öngörülemez çağrılır."* |
| `ForEach(items)` `id` yok, `Identifiable` değil | Yanlış diffing / state karışması | 🟡 | Stable `id` (index değil!) | *"Index id olursa reorder'da state yanlış cell'e yapışır."* |
| `@ObservedObject` bir view'ın kendi yarattığı VM | Recreate'de state kaybı | 🔴 | `@StateObject` (owner) | *"ObservedObject sahiplik varsaymaz; parent redraw'da VM sıfırlanır."* |
| Aynı state iki yerde (@State + parent binding kopyası) | Source of truth ihlali | 🟡 | Tek SoT, aşağı `Binding` | *"Tek yönlü akış; iki kaynak divergence yaratır."* |
| `index` kullanılıyor `id` olarak | Reorder/delete bug | 🟡 | Model'e stable id | *"Pozisyon kimlik değildir."* |

## 4. Architecture

| Tell | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------|----------------|----------|-----|-------------------|
| VC'de networking + parsing + business logic | **Massive View Controller** | 🟡 | VM/servis katmanına ayır | *"Test edilebilirlik + SRP; VC sadece view."* |
| `SomeManager.shared` her yerde, mutable global | Singleton overuse, gizli coupling | 🟡 | Dependency injection | *"Global mutable state test ve concurrency'yi zehirler."* |
| Somut tipe doğrudan bağımlılık (protokol yok) | Tight coupling | 🟢 | Protokol + inject | *"Sınırı protokolle çiz; mock'lanabilir olur."* |
| View → doğrudan `URLSession` | Katman ihlali | 🟡 | Repository/servis arası | *"View I/O bilmemeli."* |

## 5. Networking / API

| Tell | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------|----------------|----------|-----|-------------------|
| Request'te timeout yok | Askıda kalan istek | 🟡 | `timeoutInterval` / config | *"Zayıf ağda sonsuz bekleme UX'i öldürür."* |
| Retry var ama idempotency yok (POST) | Çift işlem (double charge) | 🔴 | Idempotency key + dedupe | *"Retry güvenliği idempotency ister."* |
| `try!`/`as!` ile decode | İlk şema değişiminde crash | 🔴 | `try?`/`Result`, defensive decode | *"N-1 uyumluluk; sunucu değişince patlamamalı."* |
| In-flight request iptal edilmiyor (search/typing) | **Out-of-order / stale response** | 🟡 | Cancel önceki / request id guard | *"En güncel cevabı al; eski geç gelirse görmezden gel."* |
| Response ana thread'e dönmeden UI | (bkz Concurrency) | 🔴 | main hop | — |

## 6. Safety / Performance

| Tell | Refleks teşhis | Severity | Fix | Trade-off cümlesi |
|------|----------------|----------|-----|-------------------|
| `!` force unwrap (özellikle optional chain sonu) | Crash yüzeyi | 🟡 | `guard let`/`if let`/`??` | *"Crash yerine kontrollü fallback."* |
| Döngü içinde `array.contains` / lineer arama | Gizli **O(n²)** | 🟡 | `Set`/`Dictionary` ile O(n) | *"Membership'i hash'e taşı."* |
| Main thread'te senkron disk/JSON/decode | UI freeze | 🟡 | Background queue | *"Ana thread render içindir, I/O değil."* |
| Büyük image `UIImage(named:)` downsample yok | Memory spike | 🟡 | Downsample + background decode | *"Görüntü boyutu ekran boyutuna göre."* |
| Integer overflow (toplam/çarpım) | Trap/yanlış sonuç | 🟢 | `addingReportingOverflow` / daha geniş tip | *"Sınırda taşmayı hesaba kat."* |

---

## Severity dili (mülakatta kullan)
- 🔴 **Critical** — crash, data corruption, para/veri kaybı, deadlock. "This must be fixed before merge."
- 🟡 **Important** — leak, UX bozulması, test edilemezlik, performans. "I'd flag this in review."
- 🟢 **Minor/style** — okunabilirlik, gereksiz karmaşıklık. "Nit."

## Cross-links
- Protokol & drill formatı: [00-PROTOCOL.md](00-PROTOCOL.md)
- Teori: [../../memory-management.md](../../memory-management.md) · [../../concurrency-gcd.md](../../concurrency-gcd.md) · [../../swiftui-basics.md](../../swiftui-basics.md) · [../../architecture.md](../../architecture.md)
- Recall: [../../../retrieval/DECK.md](../../../retrieval/DECK.md)
