# Trendyol iOS — Phone Screen (HR) Prep

> **Tarih:** 2026-04-27 Pazartesi
> **Format:** HR-style screening call, ~20-30 dk
> **Amaç:** Kalibrasyon — gerçek deneyim doğrulaması, communication kontrolü, kültürel uyum
> **Sonuç:** Geçerse → HR + iOS Technical (2. round)

---

## 0. Genel Felsefe — DÜRÜSTLÜK + FRAMING

**Yapma:**
- ❌ Bilmediğin şeye "biliyorum" deme — eleyen çoğunluk burada
- ❌ Ders kitabı tonunda ezbere konuşma — sahte gelir
- ❌ "Asistanlar bana yardım etti" izlenimi verme — kendi sözlerin

**Yap:**
- ✅ Yaptıklarını **somut proje + somut katkı** ile anlat
- ✅ Yapmadıklarını **dürüstçe söyle + ilgili deneyime köprü kur**
- ✅ "Biliyorum" yerine **"Şu projede şöyle kullandım"** de
- ✅ 60-90 saniye içinde özet → daha fazla isterlerse derinleştir

### Power Phrases (Buying Time)

Düşünmek için zaman kazanmak istersen:
- *"Güzel soru, kısa düşüneyim..."*
- *"Bu konuda şöyle bir deneyimim var..."*
- *"Net hatırlamıyorum ama prensip şöyle..."*
- *"Pratik kullanımı şöyle, theoretical kısmını sıkı çalıştığımı söyleyemem..."*

---

## 1. KENDİNDEN BAHSET (Self-Introduction)

### Soru Varyasyonları

- *"Kendinden bahseder misin?"*
- *"Biraz kendini tanıtır mısın?"*
- *"Geçmiş deneyimlerinden bahseder misin?"*

### Hedef

**60-90 saniyelik elevator pitch.** Yapı: **Şimdi → Geçmiş → Etki → Motivation**.

### Senin Cevabın (Türkçe — Memorize)

> *"Merhaba, ben Mehmet Kaan. 2.5 yıldır iOS Developer olarak çalışıyorum. Şu an FMSS Bilişim Teknolojilerinde iOS Developer'ım, yaklaşık 2 yıldır buradayım.*
>
> *FMSS'te Lukoil firmasının B2B ve B2C uygulamalarında full-lifecycle çalıştım — payment flows, MapKit ile fleet management ve real-time sync üzerinde owner'lık yaptım. Her iki uygulama da App Store'da yayında, milyonlarca kullanıcıya hizmet veriyor. Şu an global bir online education projesinde aktifim — RTL/Arabic localization ve role-based workflows implement ettim. Bu ürünü Londra'da BETT UK fuarında uluslararası stakeholder'lara live demo ile sundum.*
>
> *FMSS'ten önce Neon Apps'te yaklaşık 8 ay çalıştım, Atomic: Routine Habits ve Yaya Middle East gibi consumer uygulamalar geliştirdim. UI'ı tamamen programmatic, UIKit + SnapKit ile yazıyorduk. Bunun yanında Flight Tracker adında kendi App Store'da yayınlanmış bir kişisel projem var — uçuş takibi yapan, end-to-end kendim geliştirdiğim uygulama.*
>
> *Stack olarak Swift, UIKit, MVVM/MVC, Clean Architecture, MapKit, REST APIs, Firebase aktif kullandığım teknolojiler. SwiftUI'yı son projelerde entegre etmeye başladık. Trendyol gibi yüksek ölçekli, milyonlarca kullanıcılı bir üründe çalışmak teknik olarak beni geliştirir, kariyerimde bir sonraki adım olarak hedefliyorum."*

### Süre Kontrolü

```
Şu an:        ~10-15 saniye
Geçmiş:       ~25-30 saniye
Etki + impact: ~15-20 saniye
Motivation:    ~10 saniye
─────────────────────────────
TOPLAM:       ~75-85 saniye  ✅
```

### Pratik Tavsiye

- **Ses kaydet, dinle.** Akıcılık + tonlama önemli.
- **Tekleme noktalarını işaretle** — özellikle "FMSS Bilişim Teknolojilerinde" gibi kurumsal isimleri net söyle.
- **Heyecanlı tonla aç, sakinle**. Açılış enerji belirler.

---

## 2. VIPER

### Soru Varyasyonları

- *"VIPER biliyor musun?"*
- *"VIPER ile çalıştın mı?"*
- *"Şu an çalıştığın projede architecture nedir? VIPER mı?"*

### Strateji

VIPER'ı **kullanmadın**. Yalan söyleme. Ama:
1. 5 katmanı **bil**
2. Şu an kullandığın MVVM-R'ı **somut anlat**
3. Architectural awareness'ı **göster** — "When + Why" trade-off

### Senin Cevabın (Türkçe)

> *"VIPER üzerinde production'da çalışmadım. Ama 5 katmanını biliyorum: View, Interactor, Presenter, Entity, Router. Mantığı katmanlar arası katı separation of concerns ve testability — özellikle büyük takımlar için.*
>
> *Şu an FMSS'te kullandığımız architecture MVVM-R, yani MVVM + Coordinator/Router. Burada View ve Coordinator işin navigation kısmını ayırıyor, ViewModel iş mantığını taşıyor, Model katmanı saf data. Geçmişte MVC ile de çalıştım — orada özellikle Massive View Controller problemleri yaşadığımı, MVVM'in bu pattern'i nasıl çözdüğünü gözlemledim.*
>
> *VIPER ile MVVM-R arasında trade-off şöyle: VIPER daha katı separation sunar, takım büyüdükçe ve modül sayısı arttıkça avantajlı. Ama küçük-orta projelerde overhead yaratabilir, boilerplate çoğalır. Trendyol gibi büyük bir takımdaysa VIPER'ın hızlı öğrenilebilir bir pattern olduğunu düşünüyorum, ihtiyaç olursa adapte olurum."*

### Anahtar Noktalar

| Söyle | Söyleme |
|-------|---------|
| "VIPER kullanmadım ama 5 katmanı biliyorum" | "VIPER'ı çok iyi bilirim" (yalan) |
| "MVVM-R kullanıyorum, separation of concerns sağlıyor" | "Architecture umurumda değil, ne deseler yazarım" |
| "Trade-off var: VIPER overhead vs scalability" | (sessizlik) |

### VIPER Kısa Hatırlatma

```
View         — UI gösterimi (UIViewController)
Interactor   — Business logic, data manipulation
Presenter    — Mediator: View ↔ Interactor, format eder
Entity       — Pure data model
Router       — Navigation, screen transitions
```

**Hareket akışı:** View → Presenter → Interactor → Entity (data) → ... → Presenter → View

---

## 3. TESTING

### Soru Varyasyonları

- *"Test yazdın mı?"*
- *"Hangi tür testler yazdın?"*
- *"Coverage'a önem verir misin?"*
- *"TDD yapar mısın?"*

### Strateji

Production'da test yazmıyorsun, ama:
1. **Pazarama Bootcamp**'te formal training aldın
2. **Flight Tracker**'da kendi initiative'inle test yazdın
3. XCTest **biliyorsun**, theoretical olarak unit / integration / UI test farkını anlatabilirsin
4. TDD ve coverage konusunda **dürüst** ol

### Senin Cevabın (Türkçe)

> *"Test konusunda mixed bir deneyimim var. Şu an çalıştığım projelerde testler yazılmıyor maalesef — daha çok feature delivery odaklı bir ekip dinamiği var. Ama test yazmaya ilgim ve temelim var.*
>
> *Pazarama iOS Bootcamp'te formal test yazma eğitimi aldım — orada XCTest framework'ünü öğrendim, unit test yazma pratiklerini gördük. Bu eğitimden sonra kendi kişisel projem olan Flight Tracker'da unit testler yazdım. Özellikle API response parsing ve view model logic'i için test coverage oluşturdum.*
>
> *Coverage metric'i ile detaylı çalışmadım, TDD pratik etmedim — bunu dürüstçe söyleyeyim. Ama testing'in production'da neden kritik olduğunu anlıyorum: regression önler, refactoring güvenliği sağlar, dokümantasyon görevi görür. Trendyol gibi kritik bir üründe test culture'una adapte olmak isterim — bu benim için bir gelişim alanı."*

### Backup Cevap (Daha Detay İsterlerse)

**Test çeşitleri:**
- **Unit Test**: Tek bir fonksiyon/method'u izole test eder. XCTest ile `XCTAssertEqual`, `XCTAssertTrue` gibi assertions
- **Integration Test**: Birden fazla component birlikte çalışırken test eder. Mesela network + parser + cache zinciri
- **UI Test**: XCUITest ile gerçek UI flow'u test eder. Button tap, navigation, etc.
- **Snapshot Test**: UI'ın görsel halini kaydeder, regresyon kontrolü yapar (3rd party: SnapshotTesting library)

**Mocking:**
- Protocol-based dependency injection ile mock object'ler kullanılır
- Network layer'ı protocol'e bağlayıp test'te `MockNetworkService` ile değiştirilir

### Anahtar Noktalar

| Söyle | Söyleme |
|-------|---------|
| "Production'da yazmıyoruz, kendi projelerimde yazdım" | "Çok test yazıyorum" (abartı) |
| "Coverage / TDD pratiği yok" (dürüst) | "TDD uzmanıyım" (yalan) |
| "Test culture'a adapte olmak isterim — gelişim alanı" | (savunmacı tepki) |

---

## 4. DEPENDENCY INJECTION (DI)

### Soru Varyasyonları

- *"Dependency Injection nedir?"*
- *"DI kullanır mısın?"*
- *"Hangi DI yöntemlerini biliyorsun?"*

### Strateji

Theory zayıf ama pratik var. Strateji: **pratiği önce anlat, theory'i de pratikten türet**.

### Senin Cevabın (Türkçe)

> *"Dependency Injection — bir class'ın ihtiyaç duyduğu bağımlılıkları kendi içinde yaratmak yerine, dışarıdan almasıdır. Amaç decoupling: class kendi bağımlılığını üretmesin, kullanıcısı tarafından enjekte edilsin. Bu testability'i artırır, modülerliği güçlendirir.*
>
> *Pratik olarak en çok **Initializer Injection** kullandım. Mesela bir ViewModel'a NetworkService'i constructor üzerinden veriyorum:*
>
> ```swift
> class ProfileViewModel {
>     private let networkService: NetworkServiceProtocol
>     init(networkService: NetworkServiceProtocol) {
>         self.networkService = networkService
>     }
> }
> ```
>
> *Bu yaklaşımın avantajı: ViewModel artık NetworkService'in concrete implementasyonunu bilmiyor, sadece protocol'e bağlı. Production'da gerçek service, test'te mock service inject edebilirim.*
>
> *DI container kullanmadım — Swinject veya Resolver gibi. Şu an projemde manuel initializer injection yeterli geliyor, ama büyük ölçekli takımlarda container yararlı olabilir."*

### DI Yöntemleri (Hızlı Bil)

| Yöntem | Açıklama | Örnek |
|--------|---------|-------|
| **Initializer Injection** | Constructor'dan geç | `init(service:)` ✅ Senin kullandığın |
| **Property Injection** | Property olarak set et | `vm.service = ...` |
| **Method Injection** | Method parametresinden geç | `vm.load(with:)` |
| **Container** | Centralized dependency registry | Swinject, Resolver |

### Anahtar Noktalar

| Söyle | Söyleme |
|-------|---------|
| "Initializer injection en çok kullandığım, protocol-based" | "DI container expert'iyim" (yalan) |
| "Decoupling + testability sağlıyor" | (theory'siz pratik anlatmak) |
| "Container kullanmadım ama prensibi biliyorum" | (susmak) |

---

## 5. SOLID

### Soru Varyasyonları

- *"SOLID prensiplerini biliyor musun?"*
- *"5 prensibi sayabilir misin?"*
- *"En çok hangi prensibi kullanıyorsun?"*

### EKSİK — Interface Segregation Principle

Önceki cevabında 4'te kaldın, **I**'yi unuttun. Şimdi tekrar **EZBERLE**:

```
S — Single Responsibility Principle
O — Open/Closed Principle
L — Liskov Substitution Principle
I — Interface Segregation Principle    ← BU EKSİKTİ
D — Dependency Inversion Principle
```

### Senin Cevabın (Türkçe)

> *"Tabii. SOLID 5 prensipten oluşuyor:*
>
> *S — Single Responsibility: Bir class'ın tek bir sorumluluğu olmalı, değişme nedeni tek olmalı. Mesela bir ViewController hem network çağrısı yapmamalı, hem business logic taşımamalı, hem UI render etmemeli — bu klasik Massive View Controller anti-pattern.*
>
> *O — Open/Closed: Class'lar genişletilmeye açık, modifikasyona kapalı olmalı. Yeni feature eklerken mevcut kodu değiştirmek yerine extension veya inheritance ile genişletmek.*
>
> *L — Liskov Substitution: Bir subclass, parent class yerine kullanılabilir olmalı, davranışı bozmamalı.*
>
> *I — Interface Segregation: Bir client kullanmadığı interface method'larına bağımlı olmamalı. Büyük protokoller yerine küçük, fokuslu protokoller kullanılmalı.*
>
> *D — Dependency Inversion: High-level module'lar low-level module'lara değil, abstraction'lara bağımlı olmalı. Bu prensip Dependency Injection'ın temelini oluşturuyor.*
>
> *Pratikte en çok **Single Responsibility** ve **Dependency Inversion** uyguladığımı görüyorum. Massive View Controller'dan kaçınmak için ViewModel'a iş mantığını ayırırım, NetworkService'i protocol arkasına alırım. Liskov ve Open/Closed daha çok inheritance-heavy senaryolarda devreye giriyor — Swift'te struct + protocol composition ile genelde bu prensipleri zaten yapısal olarak elde ediyorum."*

### Hızlı Hatırlatma — Her Prensip için Pratik Örnek

```
S: ViewController network + parsing + UI render YAPMASIN
O: Yeni payment method eklerken if-else'e satır ekleme,
   PaymentMethod protocol'üne yeni implementer ekle
L: Bir Bird subclass'ı fly() çağrısında crash etmemeli
   (Penguin Bird'e Liskov ihlali)
I: UITableViewDelegate'in 30 method'undan sadece kullandığını
   yaz — protocol composition ile parçala
D: ViewModel ↔ NetworkServiceProtocol (concrete'e değil)
```

### Anahtar Noktalar

| Söyle | Söyleme |
|-------|---------|
| 5 prensibi **akıcı** say | Sırayı karıştırma, tekleme |
| Pratik örnek ver | Sadece theory, "biliyorum" |
| "En çok S ve D uyguluyorum" | "Hepsini her gün uyguluyorum" |

---

## 6. BONUS — IK Sorabilir

### Q: "Neden Trendyol?"

> *"Üç sebep var. Birincisi ölçek: Trendyol Türkiye'nin en büyük e-commerce platformu, milyonlarca kullanıcılı. Lukoil'de payment flows ve fleet management gibi kritik sistemlerle çalıştım, scale ile uğraşmayı seviyorum — Trendyol bir sonraki seviye.*
>
> *İkincisi: e-commerce ve payment system tecrübem var, bu domain'i konfor zonu olarak görüyorum, ama Trendyol'un mühendislik kültürü ve teknoloji yatırımı bana yeni şeyler öğretecek diye düşünüyorum.*
>
> *Üçüncüsü uzun vadeli: çıktıkça katma değer yaratan, technical depth gelişimi olan bir kariyer hedefliyorum, Trendyol bunu sağlayan firma."*

### Q: "Neden iş arıyorsun?" / "Neden değişiklik?"

> *"Mevcut firmamda 2 yıldır çalışıyorum, çok şey öğrendim — payment, fleet management, international product (BETT UK demo gibi). Ama artık daha büyük ölçekli, daha fazla mühendislik challenge'ı olan bir ortamda kendimi geliştirmek istiyorum. Trendyol bunu sağlayan en güçlü adres."*

### Q: "Maaş beklentin?"

> *"Pozisyonun gerektirdiği seviyeye ve ekibinizin sunduğu paket yapısına göre konuşabiliriz. Net beklentimi sürecin ileri aşamasında, pozisyonu daha iyi anladıktan sonra paylaşırım."*

(Eğer ısrar ederse: market rate'i araştır + %10-15 üstünü söyle.)

### Q: "Güçlü yanın?"

> *"Production sahiplenme — Lukoil B2B/B2C'de ownership'i kendim aldım, sadece coding değil, App Store deploy süreci, Jenkins CI/CD, hata takibi de dahil. Bir feature'ı baştan sona götürebiliyorum."*

### Q: "Zayıf yanın?"

> *"Test culture'ı henüz tam oturtamadım — bunu kabul ediyorum. Bootcamp ve kişisel projemde XCTest ile başladım, ama production'da test yazma alışkanlığı kazanmadım. Trendyol'da bu kültüre adapte olmayı kişisel hedef olarak görüyorum."*

(Bu cevap iyi: zayıflık + farkındalık + plan. Junior tuzağı: "Çok mükemmeliyetçiyim" deme.)

### Q: "Sorun var mı? Bize bir sorun?"

**Hazır 2-3 soru olsun:**
1. *"Şu an iOS ekibinin teknik öncelikleri ne yönde — yeni feature'lar mı, performance / scale mı, mimari modernizasyon mu?"*
2. *"Code review ve testing kültürü nasıl işliyor ekibinizde?"*
3. *"İlk 90 günde benden ne bekliyorsunuz?"* (proaktif sinyali)

---

## 6.5 ARKADAŞ INTEL'İ — Trendyol'da Sıkça Sorulan 4 Ek Soru

> Bu sorular, bir önceki Trendyol iOS mülakatında bizzat sorulmuş. Üstüne hazırlık yapılmazsa eler.

### Q: "İngilizce seviyen nedir?" (5-10 saniye)

> *"İngilizce'm professional working proficiency seviyesinde. Teknik konuları rahat okuyup yazıyorum, dokümantasyon ve kod review İngilizce yapabiliyorum. Konuşma tarafında — özellikle Londra'daki BETT UK fuarında uluslararası stakeholder'larla live demo yaptım, milli eğitim bakanları ve okul yöneticilerine ürünü İngilizce sundum. Akıcı seviyede konuşmaktan çekinmem."*

**Anahtar:** BETT UK = LIVE proof of English. Bu detayı **mutlaka** zikret. Jenerik "iyi" cevabı zayıf — concrete proof = strong.

---

### Q: "Trendyol'da çalışan tanıdığın var mı?" (10 saniye)

> *"Evet, [İSİM SOYİSİM], yaklaşık 1 ay önce Trendyol'a Android Developer olarak geçti. Aynı şirkette, aynı eğitim projesinde birlikte çalıştık. Bana ekibin teknik kültürü ve süreçleri hakkında genel intiba paylaştı."*

**Pre-interview yapılacak:** İsim soyisim'i **net** söyle. "Hatırlamıyorum" = tanıdık yok izlenimi verir.

---

### Q: "SwiftUI biliyor musun? UIKit biliyor musun?" (15-20 saniye)

> *"UIKit'i 2.5 yıllık production deneyimim boyunca aktif kullandım — programmatic UI dahil, SnapKit ile constraint yönetimi, MapKit entegrasyonu, custom view'lar gibi tüm seviyelerinde rahatım.*
>
> *SwiftUI'yı şu an çalıştığım eğitim projesinde son birkaç aydır aktif kullanıyoruz, küçük modülleri SwiftUI ile yazıp UIKit'e entegre ediyoruz. Declarative syntax'ına ve State / Binding mantığına aşinayım. UIKit kadar yıllık deneyimim yok ama yatırım yapıyorum, kişisel çalışmalarımda da deneme projeleri yapıyorum."*

**Strateji:** UIKit = güçlü kart (yıllık prod). SwiftUI = gelişiyor (honest). İki framework'ü de bil + farklarını farket.

**SwiftUI key concepts (hatırlatıcı):**
- `@State` (local), `@Binding` (parent-child), `@ObservedObject` / `@StateObject` (external), `@EnvironmentObject` (global)
- Declarative vs imperative
- View body recomputation
- UIKit interop: `UIViewRepresentable`, `UIHostingController`

---

### Q: "CI/CD süreçlerini biliyor musun?" (20-30 saniye)

> *"FMSS'te projelerimizin release süreçleri Jenkins ile otomatize. Ben günlük olarak pipeline'ı tetikleyip build'leri başlatıyorum, build hatalarını takip ediyorum. Pipeline'ın yapılandırılması ekibimizdeki DevOps'tan sorumlu kişi tarafından yönetiliyor — kendim Jenkins config yazma deneyimim yok ama mevcut yapıyı okuyup anlayabilir, gerekli değişiklikleri yapabilirim. Süreç Bitbucket entegrasyonu, build automation ve App Store Connect submission adımlarını içeriyor."*

**Strateji:**
- ✅ "Kullanıyorum" — gerçek
- ✅ "Yazma deneyimim yok" — dürüst
- ✅ "Okuyup anlayabilirim, değişiklik yapabilirim" — adapte olabileceğini göster

**CI/CD genel kavramlar (hatırlatıcı):**
- **CI (Continuous Integration):** Kod commit'i → otomatik build + test
- **CD (Continuous Delivery / Deployment):** Build → otomatik deploy (test / staging / production)
- iOS pipeline ortak adımları: clone → install pods/SPM → build → unit test → archive → sign → upload to TestFlight / App Store
- Tools: **Jenkins**, **GitHub Actions**, **Bitrise**, **CircleCI**, **Xcode Cloud**, **Fastlane** (deploy automation)

---

## 7. DON'T-DO LIST

```
❌ "Bilmiyorum" → "Bu konuda bilgim sınırlı, ama yakın deneyim..."
❌ "Çok iyi bilirim" (yalan) → eleyici
❌ Yarıda kesilmiş, dağınık cevap → soruyu netleştir, sonra başla
❌ Şu anki firmayı kötülemek → "Daha büyük ölçek arıyorum" yeterli
❌ Mülakatta gergin tonla başlamak → 2-3 derin nefes, gülümseyerek aç
❌ Maaşı erken konuşmak → "Süreç ilerlerken konuşalım"
❌ Soru hazırlamamak → mutlaka 2-3 soru hazır olsun
```

---

## 8. GÜN ÖNCESİ + GÜNÜ CHECKLIST

### Pazar Akşamı (26 Nisan)

- [ ] Self-introduction'ı **3 kez** sesli oku (kronometre: 75-90 sn)
- [ ] SOLID 5 prensibini **akıcı** sayana kadar tekrarla
- [ ] CV'yi tekrar gözden geçir — projelerinin tarihleri, sayıları
- [ ] Trendyol hakkında **3 nokta** öğren: app size, user count, recent news
- [ ] 22:30 → SLEEP

### Pazartesi Sabah (27 Nisan)

- [ ] Erken kalk, kahvaltı yap
- [ ] Sessiz, network sağlam bir yer hazırla
- [ ] Telefon **şarjlı**, kulaklık hazır
- [ ] CV'yi yanına al — tarihler hatırlamak için
- [ ] Bu doc'u son **5 dakikada** scan et — özellikle Don't-Do list
- [ ] **2 dakika sessiz nefes** (calm down)
- [ ] Görüşmeden 5 dk önce: hafif gülümseyerek, **dik otur**

### Mülakat Sırasında

- [ ] **İlk 10 saniye**: net selam, gülümseme tonu
- [ ] **Soru gelince**: 1-2 saniye düşün, sonra başla
- [ ] **Kesin cevap bilmiyorsan**: "Bu konuda kısa düşüneyim" ile zaman kazan
- [ ] **Cevap sonu**: net bir şekilde bitir, "Bu konuda ek detay ister misiniz?" diye topu at

### Mülakat Sonrası

- [ ] 24 saat içinde kısa bir **teşekkür e-mail'i** (LinkedIn üzerinden de olur)
- [ ] Aklında kalan soruları kaydet — 2. round için pratik olur
- [ ] Bu doc'a bir **debrief section** ekle (ne sordular, ne iyi gitti, ne gitmedi)

---

## 9. POST-INTERVIEW DEBRIEF (Mülakattan Sonra Doldur)

| Alan | Detay |
|------|-------|
| Görüşme süresi | _______ dakika |
| IK temsilcisi | _______ |
| Sorulan sorular | (liste) |
| Bu doc'tan kaçı geldi? | _______ / 5 |
| Beklenmeyen soru | _______ |
| Hangi cevap güçlü gitti? | _______ |
| Hangi cevap zayıf gitti? | _______ |
| Özgüven hissi (1-10) | _______ |
| Sıradaki adım (söylediler mi?) | _______ |

---

## 10. Hızlı Reference Kart (Mülakat Sırasında Yanında)

```
┌─────────────────────────────────────────────────────┐
│ SOLID:  S - Single Responsibility                   │
│         O - Open/Closed                             │
│         L - Liskov Substitution                     │
│         I - Interface Segregation                   │
│         D - Dependency Inversion                    │
├─────────────────────────────────────────────────────┤
│ VIPER:  View - Interactor - Presenter -             │
│         Entity - Router                             │
├─────────────────────────────────────────────────────┤
│ DI:     Initializer | Property | Method | Container │
├─────────────────────────────────────────────────────┤
│ Test:   Unit (XCTest) | UI (XCUITest) |             │
│         Integration | Snapshot                      │
├─────────────────────────────────────────────────────┤
│ ARKADAŞ INTEL — Hatırla:                            │
│  • İngilizce → BETT UK demo örneği VER             │
│  • Trendyol Tanıdığı → İSİM SOYİSİM net söyle      │
│  • SwiftUI/UIKit → UIKit 2.5y prod, SwiftUI yeni   │
│  • CI/CD → Jenkins kullanım var, yazma yok         │
├─────────────────────────────────────────────────────┤
│ MIMO:   Bilmediğine "yakın deneyim var" köprü kur   │
│         Yapmadığına "yapmadım ama prensibi" de      │
└─────────────────────────────────────────────────────┘
```

Print et veya yan ekrana al. Tekleme önler.

---

## 11. SONRAKİ ADIM — 2. ROUND (Eğer Geçersen)

HR + iOS Technical olarak gelir. Bu round'da:
- Memory management ve ARC (bugün hazırladığımız `ios-depth/memory-management.md` **altın değer**)
- Concurrency (GCD, async/await, actor)
- Architecture deep-dive (MVVM detay, navigation patterns)
- Codable / networking
- Belki canlı bir mini-task / pseudocode

**Bu round için ayrı doc** açacağız 1. round geçince. Şimdilik **Pazartesi'ne odak**.
