# Google iOS L3 — Interview Prep

**Hedef:** Software Engineer III, Mobile (iOS) — Google
**Süre:** 6 ay (sürdürülebilir ritim, 8-9 saat/hafta)
**Başlangıç:** 2026-04-21 (Salı)
**Başvuru Hedefi:** ~2026-10

---

## Progress Tracker

### Genel Durum

| Metric | Şu An | Hedef |
|--------|-------|-------|
| LeetCode problems solved | 4 | 150+ |
| Blind 75 completion | 4 / 75 | 75 / 75 |
| NeetCode 150 completion | 4 / 150 | 150 / 150 |
| Concept deep-dives done | 3 / 11 | 11 / 11 |
| iOS deep-dives done | 8 / 8 | 8 / 8 |
| Mock interviews done | 0 | 3-5 |
| Weeks completed | 0 / 24 | 24 / 24 |

### Phase Progression

- [ ] **Phase 1 — Fundamentals Review** (Ay 1-2)
- [ ] **Phase 2 — Medium LeetCode grind** (Ay 3-4)
- [ ] **Phase 3 — iOS Depth** (paralel, Ay 3-4)
- [ ] **Phase 4 — System Design** (Ay 5)
- [ ] **Phase 5 — Behavioral + Polish** (Ay 6)

### Concept Coverage

| # | Topic | Deep-dive | Çözülen Problem |
|---|-------|-----------|-----------------|
| 01 | Array | ✅ | 0 |
| 02 | HashTable / Dictionary | ✅ | 4 |
| 03 | String & Two Pointers | ⏳ | 0 |
| 04 | Stack & Queue | ⏳ | 0 |
| 05 | Linked List | ⏳ | 0 |
| 06 | Trees & BST | ⏳ | 0 |
| 07 | Heap / Priority Queue | ⏳ | 0 |
| 08 | Graphs (BFS, DFS) | ⏳ | 0 |
| 09 | Recursion & Backtracking | ⏳ | 0 |
| 10 | Dynamic Programming | ⏳ | 0 |
| 11 | Sorting & Searching | ⏳ | 0 |

---

## Folder Structure

```
dsa-google-prep/
├── README.md               ← bu dosya (master tracker)
├── concepts/               ← concept cheat sheet'leri (deep-dive'lar Xcode playground'da)
├── problems/               ← LeetCode çözümleri, topic'e göre organize
│   ├── arrays/
│   ├── hashmap/
│   ├── strings/
│   ├── linked-list/
│   ├── trees/
│   ├── graphs/
│   └── dp/
├── ios-depth/              ← iOS internals, memory, concurrency, architecture, code-review drills/
├── interviews/             ← mülakata özel hazırlık doc'ları (Trendyol, vb.)
├── system-design/          ← mobile system design notları
└── weekly-reviews/         ← haftalık retrospektif + Pazar planlama çıktısı
```

---

## Session Discipline Framework

### Time Boundaries

| Kural | Değer | Tip |
|-------|-------|-----|
| **Daily floor** | 1.5 saat | Non-negotiable minimum |
| **Daily ceiling** | 2.5 saat | Non-negotiable maximum |
| **Hard bedtime** | 22:30 | Non-negotiable (uyku = memory consolidation) |
| **Mandatory recovery** | 3 ardışık extended gün → 1 floor-only gün | Burnout prevention |
| **Weekly off-day** | 1 gün tam dinlenme | Sustainability |

### Weekly Bands

| Band | Saat/Hafta | Status |
|------|------------|--------|
| 🟢 Green | 8-10 | On track |
| 🟡 Yellow | 5-7 | Acceptable, momentum korundu |
| 🔴 Red | <5 | Recovery plan gerekli (Pazar ritüeli) |

Hedef: **6 ayda ≤ 2 Red hafta**.

---

## Energy-Matched Sessions

Session tipini enerji seviyesine eşle; HIGH iş'i LOW window'a zorlama.

| Energy | Süre | En İyi |
|--------|------|--------|
| 🔥 **HIGH** | 90-150 dk | Yeni concept, zor problem, mock interview |
| ⚡ **MEDIUM** | 60-90 dk | Medium problem, concept review, guided solve |
| 🪫 **LOW** | 20-40 dk | Warm-up recall, kolay re-solve, okuma |
| 🔋 **MICRO** | 10-15 dk | Flashcard, makale, podcast |

Güne göre tipik enerji:
- 🔥 HIGH: hafta sonu sabah, WFH akşam (taze)
- ⚡ MEDIUM: WFH hafta içi akşam
- 🪫 LOW: spor sonrası akşam, uzun iş günü
- 🔋 MICRO: commute, öğle arası

---

## Session Formats

Her seans 5 şekilden birini alır. Mentor önerir; kullanıcı başta confirm eder.

| Format | İsim | Süre | Ne Zaman |
|--------|------|------|----------|
| **A** | Concept Deep-Dive | 60-90 dk | Yeni data structure veya algoritma |
| **B** | Guided Problem | 45-60 dk | LeetCode mentor ile, hint'ler ihtiyaca göre |
| **C** | Solo Sprint | 30+20 dk | Timed solo solve + review |
| **D** | iOS Deep-Dive | 60 dk | iOS topic (Ay 3+) |
| **E** | Mock Interview | 60-90 dk | Tam simülasyon (Ay 5+) |

---

## Weekly Routine (Template)

### Rotation A — Office = Çar + Cum

```
PZT (WFH)       20:30-22:00   🔥 Yeni topic / guided problem
SAL (WFH)       20:30-22:00   ⚡ Solo problem (timed)
ÇAR (Off+Gym)   22:30-23:00   🪫 Preview / flashcard
PER (WFH)       20:30-22:00   ⚡ Topic deepening veya iOS
CUM (Off+Gym)   22:30-23:00   🪫 Light review
CMT             09:00-11:00   🔥 Deep work (zor problem)
PAZ             10:00-11:30   📊 Weekly Quiz + sonraki hafta planı
```

### Rotation B — Office = Pzt + Per

```
PZT (Off+Gym)   22:30-23:00   🪫 Preview / flashcard
SAL (WFH)       20:30-22:00   🔥 Yeni topic / guided problem
ÇAR (WFH)       20:30-22:00   ⚡ Solo problem (timed)
PER (Off+Gym)   22:30-23:00   🪫 Light review
CUM (WFH)       20:30-21:30   🔋 Flashcard günü (kısa)
CMT             09:00-11:00   🔥 Deep work
PAZ             10:00-11:30   📊 Weekly Quiz + sonraki hafta planı
```

**Meta-solution:** Her Pazar 11:15-11:30, plan gelen haftanın office rotation ve gym programına göre **sıfırdan** kurulur. Template'ler default'tur, smokin değil.

---

## Pazar Planlama Ritüeli (15 dk)

Her Pazar 11:15-11:30, weekly review sonu:

1. **Input:** Sonraki haftanın rotation'ı (A veya B)
2. **Input:** Spor günleri (kullanıcı 2-on-1-off, Salı'ları skip)
3. **Input:** Sabit yükümlülükler (toplantı, sosyal, seyahat)
4. **Output:** 7-günlük session plan; energy band, hedef ve beklenen problem/topic'ler ile

Çıktı `weekly-reviews/YYYY-Www-plan.md`'e gider.

---

## Daily Warm-Up Recall (3-5 dk, her seans başında)

Aktif retrieval > pasif okuma. Spaced repetition takvimi:
- Topic öğrendikten **1 gün** sonra
- **3 gün** sonra
- **1 hafta** sonra
- **2 hafta** sonra
- **1 ay** sonra

Mentor seans başına aktif deck'ten 3 recall sorusu rotate eder. Zayıf topic'ler daha sık yüzeye çıkar.

---

## English Integration (Aşamalı)

- **Şu an (Ay 1-2):** Problemler TR'de çözülür; problem description'lar EN okunur
- **Ay 3:** Haftalık problem özetleri EN yazılır
- **Ay 3+:** Mock mülakatlar EN yapılır

---

## Weekly Routine Kuralları

1. **Sustainability > intensity.** Bir gün kaçırmak ok; bir hafta kaçırmak recovery plan ister.
2. **Retrieval > re-reading.** Aktif recall pasif review'u yener.
3. **Explain before code.** Swift'ten önce sözel pseudocode + Big O.
4. **Timed solo solving.** Gerçek solve süresini track et — bu mülakat gap'idir.
5. **Pazar planlama kutsaldır.** 15 dk, non-negotiable. Olmazsa retention çöker.
6. **No guilt rule.** Kaçan seanslar telafi edilir, asla cezalandırılmaz.

---

## Resources

- [LeetCode](https://leetcode.com)
- [NeetCode.io Roadmap](https://neetcode.io/roadmap)
- [Blind 75 List](https://www.techinterviewhandbook.org/grind75)
- [Swift by Sundell](https://www.swiftbysundell.com)
- [objc.io](https://www.objc.io)
- [Pointfree.co](https://www.pointfree.co)

---

## Current Week

**Week 1 (2026-04-21 → 2026-04-27)** — Rotation A
- Sal: ✅ Planlama + setup (bu repo)
- Çar: ✅ Two Sum preview (Office + Gym)
- Per: ✅ Two Sum guided solve (Format B) → [0001-two-sum](problems/hashmap/0001-two-sum.md)
- Cum: 🪫 Light session (30-min Two Sum MD passive review)
- Cmt: ✅ Contains Duplicate solo (Format C) → [0217-contains-duplicate](problems/hashmap/0217-contains-duplicate.md)
- Paz: ✅ iOS Deep-Dive — ARC + Memory Management (Format D) → [memory-management](ios-depth/memory-management.md)
- Paz: ✅ Trendyol HR Screen Prep doc → [hr-screen-prep](interviews/2026-04-27-trendyol/hr-screen-prep.md)
- Paz PM: ✅ Cold mock re-solve (Two Sum + Contains Duplicate) + HR role-play
- Pzt: ✅ Trendyol HR Phone Screen — light review + Valid Anagram intro (Block A+B)
- Sal: ✅ Trendyol IK callback (Stage 1 passed, HR Manager'a escalate)
- Sal PM: ✅ Valid Anagram (Format C) → [0242-valid-anagram](problems/hashmap/0242-valid-anagram.md)

**Week 2 (2026-04-28 → 2026-05-04)** — Rotation A
- Çar: ✅ Repo MD çeviri (commute reading) + Trendyol teknik mülakat intel (project-based code review)
- Per PM: ✅ iOS Deep-Dive — Access Control + code review drills (Format D) → [access-control](ios-depth/access-control.md)
- Cum (1 Mayıs): ✅ Group Anagrams (Format B) → [0049-group-anagrams](problems/hashmap/0049-group-anagrams.md) · ✅ GCD / Concurrency (Format A) → [concurrency-gcd](ios-depth/concurrency-gcd.md)

> **Ara (5 Mayıs → 2 Haziran):** token yenileme + iş + Kurban Bayramı. Trendyol: HR telefon aşamasında elendi (teknik aşamaya gelmeden). Plan korundu, Google hedefi diri.

**Restart Week (2026-06-06 →)** — Pazartesi (8 Haz) teknik sohbet mülakatı prep
- Cmt (6 Haz): ✅ iOS Deep-Dive — Architecture/SOLID + UIKit lifecycle + async/await + image-loading senaryo (Format D)
  → [architecture](ios-depth/architecture.md) · [async-await](ios-depth/async-await.md) · [uikit-lifecycle](ios-depth/uikit-lifecycle.md) · [scenario](ios-depth/drills/04-scenario-image-list.md)
- Paz (7 Haz): ✅ Testing + SwiftUI temel + 4 senaryo mock (payment/offline/realtime/search) (Format D)
  → [testing](ios-depth/testing.md) · [swiftui-basics](ios-depth/swiftui-basics.md) · drills 05-08
- Paz (7 Haz) PM: ✅ SwiftUI deep-dive (struct/diffing/identity/köprü) + 2 senaryo (background upload, analytics batching) + clarify 4-eksen framework
  → drills 09-10
- Paz (7 Haz) gece: ✅ UIKit deep-dive (layout cycle, responder chain, Auto Layout, frame/bounds, cell reuse) → [uikit-deep](ios-depth/uikit-deep.md)
- Pzt (8 Haz): 🎯 Teknik sohbet mülakatı
