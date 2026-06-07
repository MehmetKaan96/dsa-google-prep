# CI/CD for iOS

> **Session:** 2026-06-07 PM · Mülakatçı Vodafone CI/CD geçmişi + CV "Jenkins" iddiası.
> **Dürüstlük notu:** kullanıcı Jenkins'i operasyonel kullanıyor (build tetikleme), pipeline'ı sıfırdan kurmadı → framing önemli.

---

## TL;DR

- **CI:** her commit/PR'da otomatik **build + test** → kod sağlığı
- **CD:** build'i otomatik **dağıtım** (TestFlight / App Store)
- **Pipeline:** checkout → deps → build → test → lint → sign/archive → distribute
- **Fastlane:** iOS otomasyon standardı (build, test, TestFlight upload, signing)
- **Quality gate:** PR'da build+test+lint+coverage yeşil → merge izni

---

## 1. CI vs CD

| | Açılım | Ne yapar |
|--|--------|----------|
| **CI** | Continuous Integration | Her commit/PR'da otomatik build + test |
| **CD** | Continuous Delivery/Deployment | Build'i otomatik dağıtım hattına sokar |

> *"CI her commit'te build+test ile kodu sağlıklı tutar; CD dağıtımı otomatikleştirir."*

---

## 2. iOS Pipeline Adımları

```
1. push / PR
2. CI tetiklenir (Jenkins / GitHub Actions / Bitrise)
3. checkout + dependency (SPM/CocoaPods)
4. BUILD (xcodebuild)
5. TEST (unit + UI)
6. lint / static analysis (SwiftLint)
7. code signing + archive (.ipa)
8. distribute → TestFlight / Firebase App Distribution
9. (opsiyonel) App Store submit
```

---

## 3. Araçlar

- **Jenkins** — pipeline orchestrator ("sürüm seç → build" = bir Jenkins job tetikleme)
- **Fastlane** — iOS otomasyon: build/test/screenshot/TestFlight upload/signing (`match`) → standart
- **GitHub Actions / Bitrise / CircleCI** — alternatifler

---

## 4. PR Quality Gate

PR açılınca otomatik:
- ✅ build
- ✅ test
- ✅ lint (SwiftLint)
- ✅ coverage düşmemiş
→ hepsi yeşil → branch protection ile merge izni

---

## 5. Dürüst CV Framing (interview)

> *"Günlük akışta Jenkins üzerinden build/release tetikliyorum — pipeline'ın kullanıcısıyım, sürüm yönetimi yapıyorum. Pipeline'ı sıfırdan kurmaktan çok operasyonel kullanım + release management tarafındaydım. Adımları (build, test, signing, TestFlight) ve Fastlane'in rolünü biliyorum, bu tarafta derinleşmeye açığım."*

**Kural:** abartma + küçültme yok → operasyonel kullanıcı olarak net konumlan.

---

## References

- [Fastlane docs](https://docs.fastlane.tools) · [testing.md](testing.md) (quality gate)
