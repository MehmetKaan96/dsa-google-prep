# UIKit View Controller Lifecycle

> **Session:** 2026-06-06 · Sık sorulan + timer/observer temizleme bağlamı.

---

## Sıralama + Tetikleyici

| Metot | Ne zaman | Sıklık |
|-------|----------|--------|
| `viewDidLoad` | View memory'e yüklenince, ilk kurulum | **Bir kez** |
| `viewWillAppear` | Ekrana gelmeden hemen önce | Her gelişte |
| `viewDidAppear` | Ekranda görününce | Her gelişte |
| `viewWillDisappear` | Ekrandan gitmeden hemen önce | Her gidişte |
| `viewDidDisappear` | Ekrandan gittikten sonra (memory'de olabilir) | Her gidişte |

**Anahtar:** `viewDidLoad` **bir kez**; appear/disappear **her geçişte**.

---

## Kritik Kavram Yanlışı (yakalanır)

> ❌ "viewWillDisappear = memory'den kaldırılma"

**Yanlış.** Disappear ≠ deallocation. View ekrandan gider ama **memory'de kalabilir** (navigation stack, tab switch). Deallocation **ARC** işidir, lifecycle event değil.

---

## Timer / Observer Başlat-Durdur

- **Başlat:** `viewWillAppear` / `viewDidAppear`
- **Durdur:** `viewWillDisappear` / `viewDidDisappear` → `timer.invalidate()`, observer remove

**Neden `deinit` değil?** Timer/RunLoop `self`'i tutarsa **`deinit` hiç çağrılmaz** → durduramazsın. Lifecycle simetrisi: appear'da başlat, disappear'da durdur.

(Bkz. Banner Timer drill — [memory-management.md](memory-management.md))

---

## References

- Apple — [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)
