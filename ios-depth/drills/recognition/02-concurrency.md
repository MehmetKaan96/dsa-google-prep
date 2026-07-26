# Recognition Set 02 — Concurrency

> Protokol: [00-PROTOCOL.md](00-PROTOCOL.md) · Harita: [00-RECOGNITION-MAP.md](00-RECOGNITION-MAP.md)
> `<details>`'i açmadan 5-adım cevabını ver (isim → severity → failure → fix → trade-off). Hedef: isim <10 sn.
> Concurrency drill'lerinde altın refleks: **(1) UI main'de mi? (2) shared mutable state var mı? (3) her async path bir kez mi tamamlanıyor?**

---

## Drill 1 — Completion içinde UI 🟢

```swift
func loadUser(id: String, completion: @escaping (User) -> Void) {
    URLSession.shared.dataTask(with: url(id)) { data, _, _ in
        let user = try! JSONDecoder().decode(User.self, from: data!)
        completion(user)
    }.resume()
}

// çağıran:
loadUser(id: "42") { user in
    self.nameLabel.text = user.name
}
```

**Soru:** Concurrency açısından baskın sorun ne? (Bonus: başka ne göze çarpıyor?)

<details>
<summary>Model cevap</summary>

1. **İsim:** UI güncellemesi main thread dışında. `URLSession` completion **arka plan** queue'sunda çağrılır; `nameLabel.text = ...` orada çalışıyor.
2. **Severity:** 🔴 Critical — UIKit main-thread-only; görünmez bozulma, ara sıra crash, "Main Thread Checker" uyarısı.
3. **Failure mode:** Bazen çalışır (yarış), bazen UI güncellenmez / çakışır; reproduce edilmesi zor prod bug.
4. **Fix:** Completion'ı main'e hop'la (kaynağında en temiz):
   ```swift
   let user = ...
   DispatchQueue.main.async { completion(user) }
   ```
   veya çağıran tarafta `DispatchQueue.main.async { self.nameLabel.text = ... }`.
5. **Trade-off:** Main hop'unu **API sınırında** yapmak (completion'ı hep main'de çağırmak) her çağıranın hatırlamasını gerektirmez → daha az hata. Alternatif `@MainActor` closure/async-await ile compiler'a zorlatmak. (Bonus 🔴: `try!` + `data!` — ilk hatalı response'ta crash; defensive decode gerekir.)

</details>

---

## Drill 2 — main.sync 🟡

```swift
@IBAction func saveTapped() {
    DispatchQueue.main.sync {
        self.showSpinner()
    }
    persist()
}
```

**Soru:** Ne olur bu kod çalışınca?

<details>
<summary>Model cevap</summary>

1. **İsim:** Deadlock. `saveTapped` zaten main thread'te (IBAction); `main.sync` main'in kendini beklemesine yol açar.
2. **Severity:** 🔴 Critical — anında kilitlenme, UI donar.
3. **Failure mode:** Buton tıklanır tıklanmaz uygulama tamamen kilitlenir (main queue kendini bekler, asla dönmez).
4. **Fix:** Zaten main'deyiz — sarmalamaya gerek yok:
   ```swift
   showSpinner()
   persist()
   ```
   Farklı bir thread'ten çağrılıyorsa `main.async` kullan, asla `main.sync` (aynı queue'dan).
5. **Trade-off:** `sync` aynı serial queue üzerinden çağrılırsa daima deadlock. `async` bloklamaz. Kural: **bir queue'dan kendi üstüne `sync` atma.**

</details>

---

## Drill 3 — Data race 🔴

```swift
final class ImageCache {
    private var store: [String: UIImage] = [:]

    func image(for key: String) -> UIImage? { store[key] }
    func insert(_ image: UIImage, for key: String) { store[key] = image }
}

// birden çok cell, birden çok arka plan thread'inden:
DispatchQueue.global().async { cache.insert(img, for: url) }
```

**Soru:** `ImageCache` prod'da neyi garanti etmiyor?

<details>
<summary>Model cevap</summary>

1. **İsim:** Data race — `store` (Swift `Dictionary`) birden çok thread'ten eşzamanlı okunuyor/yazılıyor; thread-safe değil.
2. **Severity:** 🔴 Critical — undefined behavior: bozuk bellek, ara sıra crash, kaybolan entry'ler.
3. **Failure mode:** Aynı anda iki thread `insert` ederse iç buffer/rehash yarışır → crash veya sessiz veri bozulması. Reproduce zor, prod'da patlar.
4. **Fix:** Erişimi serialize et:
   ```swift
   private let queue = DispatchQueue(label: "cache", attributes: .concurrent)
   func image(for key: String) -> UIImage? { queue.sync { store[key] } }
   func insert(_ image: UIImage, for key: String) {
       queue.async(flags: .barrier) { self.store[key] = image }
   }
   ```
   veya modern: `actor ImageCache`.
5. **Trade-off:** Concurrent queue + barrier → paralel okuma, seri yazma (reader-writer). `actor` daha temiz ama call-site'ı `await`'e zorlar. Basit `NSLock` da olur ama okuma paralelliğini kaybeder. Trade-off: okuma-ağırlıklı cache'te barrier/actor kazanır.

</details>

---

## Drill 4 — DispatchGroup enter/leave 🔴

```swift
func loadAll(_ ids: [String], completion: @escaping ([Item]) -> Void) {
    let group = DispatchGroup()
    var items: [Item] = []
    for id in ids {
        group.enter()
        api.fetch(id) { result in
            switch result {
            case .success(let item):
                items.append(item)
                group.leave()
            case .failure:
                return   // <-
            }
        }
    }
    group.notify(queue: .main) { completion(items) }
}
```

**Soru:** İki problem var. Bul.

<details>
<summary>Model cevap</summary>

1. **İsim:** (a) `enter()/leave()` dengesizliği — `.failure` path'inde `leave()` yok, dolayısıyla bir istek bile başarısız olursa `notify` **hiç** çalışmaz. (b) `items.append` birden çok thread'ten → data race.
2. **Severity:** 🔴 Critical — completion hiç çağrılmaz (asılı kalır) + array corruption.
3. **Failure mode:** Bir fetch fail edince ekran sonsuz "yükleniyor"da kalır; ayrıca eşzamanlı append crash edebilir.
4. **Fix:**
   ```swift
   let lock = NSLock()
   api.fetch(id) { result in
       defer { group.leave() }               // her path'te leave
       if case .success(let item) = result {
           lock.lock(); items.append(item); lock.unlock()
       }
   }
   ```
5. **Trade-off:** `defer { leave() }` her çıkış yolunda dengeyi garanti eder — enter/leave için en güvenli idiom. Append'i lock/serial queue ile koru. (Modern alternatif: `withTaskGroup` — enter/leave book-keeping'i tamamen ortadan kaldırır.)

</details>

---

## Drill 5 — Task cancellation 🟡

```swift
final class SearchViewModel: ObservableObject {
    @Published var results: [Result] = []

    func search(_ query: String) {
        Task {
            let hits = try await api.search(query)
            self.results = hits
        }
    }
}
```

**Soru:** Kullanıcı hızlı yazarken ne ters gider?

<details>
<summary>Model cevap</summary>

1. **İsim:** İptal edilmeyen Task → **out-of-order / stale response**. Her tuş yeni Task başlatır; önceki iptal edilmez, geç dönen eski sorgu sonucu ekranı ezebilir. (Ayrıca `self.results` main actor'da mı? `@MainActor` yoksa UI-off-main riski.)
2. **Severity:** 🟡 Important — yanlış/eski sonuç gösterimi; UX bug.
3. **Failure mode:** "swift" yazarken "sw" sorgusu en son dönerse, "swift" sonuçları "sw" ile değiştirilir. Klasik live-search hatası.
4. **Fix:** Önceki task'ı sakla ve iptal et (+ MainActor):
   ```swift
   @MainActor final class SearchViewModel: ObservableObject {
       private var task: Task<Void, Never>?
       func search(_ query: String) {
           task?.cancel()
           task = Task {
               guard let hits = try? await api.search(query), !Task.isCancelled else { return }
               self.results = hits
           }
       }
   }
   ```
5. **Trade-off:** Cancel + `Task.isCancelled` guard en güncel sorguyu garanti eder. Alternatif: debounce (gereksiz istek azaltır) — ikisi birlikte idealdir. `@MainActor` UI hop'unu compiler'a zorlatır.

</details>

---

## Drill 6 — Tuzak: sorun YOK 🔴

```swift
func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
    api.request(.profile) { result in
        DispatchQueue.main.async { completion(result) }
    }
}

// çağıran:
fetchProfile { [weak self] result in
    guard let self else { return }
    switch result {
    case .success(let p): self.render(p)
    case .failure(let e): self.showError(e)
    }
}
```

**Soru:** Concurrency bug'ı nerede?

<details>
<summary>Model cevap</summary>

1. **İsim:** **Bug yok.** Completion main'e hop'lanmış (UI güvenli), `[weak self]` + `guard let self` doğru, hem success hem failure handle edilmiş.
2. **Severity:** 🟢 — flag edilecek concurrency sorunu yok.
3. **Failure mode:** Yok.
4. **Fix:** Gerekmiyor. Over-flag etme.
5. **Trade-off:** Doğru refleks: "Completion API sınırında main'e dönüyor, capture doğru, iki path de kapalı — burada bir şey görmüyorum. İsterseniz `api.request`'in retry/timeout davranışını konuşabiliriz." Sağlam kodu onaylayıp bir sonraki katmana geçmek senior sinyali.

</details>

---

## Sonraki
Set 02 akıcı geçince → Set 03 (SwiftUI). Zorlanılan drill → [SCHEDULE.md](../../../retrieval/SCHEDULE.md) "Recognition-Concurrency" Kutu 1.
