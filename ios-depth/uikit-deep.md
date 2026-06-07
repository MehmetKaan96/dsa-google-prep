# UIKit Deep-Dive — Layout, Responder, Auto Layout, Cell Reuse

> **Session:** 2026-06-07 PM · Teknik sohbet mülakatı prep (UIKit ↔ SwiftUI).

---

## TL;DR

- **Cell reuse:** sabit sayıda cell havuzu → bellek; `prepareForReuse`'da stale state temizle
- **Layout cycle:** `setNeedsLayout` (invalidate, async) · `layoutIfNeeded` (force, sync) · `layoutSubviews` (asıl hesap, override)
- **frame vs bounds:** frame parent koordinatında; bounds kendi koordinatında
- **Responder chain:** hit-test → view → superview → VC → window → application
- **Auto Layout:** constraint ilişkileri; `intrinsicContentSize` + hugging/compression; StackView
- **UIKit vs SwiftUI:** bağlama göre; prod'da hibrit (`UIHostingController`)

---

## 1. Cell Reuse

`UITableView`/`UICollectionView` ekrana sığan **sabit sayıda** cell tutar, scroll'da **yeniden kullanır** → milyonlarca satırda bellek patlamaz.

- `dequeueReusableCell` — havuzdan müsait cell verir (yoksa yaratır)
- `prepareForReuse` — cell yeniden kullanılmadan önce **stale state temizliği**: `imageView.image = nil`, devam eden async task **`cancel()`**, `currentURL = nil`

→ "Yanlış hücrede görsel" bug'ının çözümü burada (stale-response guard).

---

## 2. Layout Cycle

| Metot | Ne yapar | Kim |
|-------|----------|-----|
| `setNeedsLayout` | "Layout gerekiyor" işaretle — **async**, sonraki run loop | Sen çağırırsın |
| `layoutIfNeeded` | Bekleyen layout'u **senkron** zorla (animasyon bloğu) | Sen çağırırsın |
| `layoutSubviews` | Asıl layout hesabı — subview frame'leri | **Override edersin**, asla doğrudan çağırma |

```
setNeedsLayout (async invalidate)
   → sonraki run loop → layoutSubviews (sistem çağırır)
layoutIfNeeded → şimdi senkron zorla
```

**Animasyon pattern:** constraint değiştir → `layoutIfNeeded` animasyon bloğunda.

---

## 3. frame vs bounds

- **frame:** view'in **parent (superview)** koordinatındaki konum + boyut
- **bounds:** view'in **kendi** koordinatındaki boyut (origin genelde 0,0)
- **`transform`** (rotate/scale): **frame "anlamsızlaşır"** (warped), bounds **değişmez** — transform'da bounds güvenilir referans

---

## 4. Responder Chain

```
hit-test → en derin UIView
   ↑ işlemezse
superview(ler) → UIViewController → UIWindow → UIApplication → AppDelegate
   ↑ hiçbiri işlemezse → event DROP
```

- `UIView`, `UIViewController`, `UIApplication` hepsi **`UIResponder`**
- `next` property → bir sonraki halka
- `target: nil` action → chain'de uygun handler aranır

---

## 5. Auto Layout

- **Constraint-based:** sabit frame yerine **ilişkiler** (Cassowary solver)
- **Avantaj:** çok ekran boyutu + dinamik içerik (örn. **RTL/Arabic** lokalizasyon) + rotation/split
- **`intrinsicContentSize`:** view'in içeriğe göre doğal boyutu (UILabel metne, UIButton title'a göre)
- **Content Hugging** (büyümeye direnç) + **Compression Resistance** (küçülmeye direnç) → çakışmada kim esner
- **`UIStackView`:** constraint boilerplate'ini kaldırır; axis/spacing/distribution/alignment ile otomatik dizilim

---

## 6. UIKit vs SwiftUI (dengeli cevap)

> *"Seçim bağlama bağlı. **SwiftUI:** hızlı geliştirme, az kod, declarative, modern — yeni feature'da tercih. **UIKit:** olgun, tam kontrol, karmaşık custom UI/animasyon, legacy, iOS 13 öncesi. Prod'da **hibrit** — `UIHostingController` ile SwiftUI'yi UIKit'e gömerim. UIKit'te derinim, SwiftUI'yi yeni feature'larda aktif kullanıyorum."*

**Kural:** tek taraf seçmek tuzak → trade-off + kendi pozisyonun.

---

## References

- Apple — [UIView](https://developer.apple.com/documentation/uikit/uiview), [Auto Layout Guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/)
- Related: [uikit-lifecycle.md](uikit-lifecycle.md) · [swiftui-basics.md](swiftui-basics.md) · [04-scenario-image-list.md](drills/04-scenario-image-list.md)
