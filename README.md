# Google iOS L3 — Interview Prep

**Hedef:** Software Engineer III, Mobile (iOS) — Google
**Süre:** 6 ay (sürdürülebilir ritim, 8-9 saat/hafta)
**Başlangıç:** 2026-04-21 (Salı)
**Başvuru Hedefi:** ~2026-10

---

## Progress Tracker

### Overall

| Metric | Current | Target |
|--------|---------|--------|
| LeetCode problems solved | 2 | 150+ |
| Blind 75 completion | 2 / 75 | 75 / 75 |
| NeetCode 150 completion | 2 / 150 | 150 / 150 |
| Concept deep-dives done | 3 / 11 | 11 / 11 |
| iOS deep-dives done | 1 / 8 | 8 / 8 |
| Mock interviews done | 0 | 3-5 |
| Weeks completed | 0 / 24 | 24 / 24 |

### Phase Progression

- [ ] **Phase 1 — Fundamentals Review** (Month 1-2)
- [ ] **Phase 2 — Medium LeetCode grind** (Month 3-4)
- [ ] **Phase 3 — iOS Depth** (parallel, Month 3-4)
- [ ] **Phase 4 — System Design** (Month 5)
- [ ] **Phase 5 — Behavioral + Polish** (Month 6)

### Concept Coverage

| # | Topic | Deep-dive | Problems Solved |
|---|-------|-----------|-----------------|
| 01 | Array | ✅ | 0 |
| 02 | HashTable / Dictionary | ✅ | 2 |
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
├── README.md               ← this file (master tracker)
├── concepts/               ← concept cheat sheets (deep-dives live in Xcode playground)
├── problems/               ← LeetCode solutions organized by topic
│   ├── arrays/
│   ├── hashmap/
│   ├── strings/
│   ├── linked-list/
│   ├── trees/
│   ├── graphs/
│   └── dp/
├── ios-depth/              ← iOS internals, memory, concurrency, architecture
├── system-design/          ← mobile system design notes
└── weekly-reviews/         ← weekly retrospectives + Sunday planning output
```

---

## Session Discipline Framework

### Time Boundaries

| Rule | Value | Type |
|------|-------|------|
| **Daily floor** | 1.5 hours | Non-negotiable minimum |
| **Daily ceiling** | 2.5 hours | Non-negotiable maximum |
| **Hard bedtime** | 22:30 | Non-negotiable (sleep = memory consolidation) |
| **Mandatory recovery** | 3 consecutive extended days → 1 floor-only day | Burnout prevention |
| **Weekly off-day** | 1 day complete rest | Sustainability |

### Weekly Bands

| Band | Hours/week | Status |
|------|-----------|--------|
| 🟢 Green | 8-10 | On track |
| 🟡 Yellow | 5-7 | Acceptable, momentum preserved |
| 🔴 Red | <5 | Recovery plan needed (Sunday ritual) |

Target: **≤ 2 Red weeks across 6 months**.

---

## Energy-Matched Sessions

Match session type to energy level; do not force HIGH work into LOW windows.

| Energy | Duration | Best For |
|--------|----------|----------|
| 🔥 **HIGH** | 90-150 min | New concept, hard problem, mock interview |
| ⚡ **MEDIUM** | 60-90 min | Medium problem, concept review, guided solve |
| 🪫 **LOW** | 20-40 min | Warm-up recall, easy re-solve, reading |
| 🔋 **MICRO** | 10-15 min | Flashcards, article, podcast |

Typical energy by day:
- 🔥 HIGH: weekend morning, WFH evening (fresh)
- ⚡ MEDIUM: WFH weekday evening
- 🪫 LOW: post-gym evening, long work day
- 🔋 MICRO: commute, lunch break

---

## Session Formats

Each session takes one of 5 shapes. Mentor proposes; user confirms at start.

| Format | Name | Duration | When |
|--------|------|----------|------|
| **A** | Concept Deep-Dive | 60-90 min | New data structure or algorithm |
| **B** | Guided Problem | 45-60 min | LeetCode with mentor, hints as needed |
| **C** | Solo Sprint | 30+20 min | Timed solo solve + review |
| **D** | iOS Deep-Dive | 60 min | iOS topic (Month 3+) |
| **E** | Mock Interview | 60-90 min | Full simulation (Month 5+) |

---

## Weekly Routine (Template)

### Rotation A — Office = Wed + Fri

```
MON (WFH)       20:30-22:00   🔥 New topic / guided problem
TUE (WFH)       20:30-22:00   ⚡ Solo problem (timed)
WED (Off+Gym)   22:30-23:00   🪫 Preview / flashcard
THU (WFH)       20:30-22:00   ⚡ Topic deepening or iOS
FRI (Off+Gym)   22:30-23:00   🪫 Light review
SAT             09:00-11:00   🔥 Deep work (hard problem)
SUN             10:00-11:30   📊 Weekly Quiz + next week plan
```

### Rotation B — Office = Mon + Thu

```
MON (Off+Gym)   22:30-23:00   🪫 Preview / flashcard
TUE (WFH)       20:30-22:00   🔥 New topic / guided problem
WED (WFH)       20:30-22:00   ⚡ Solo problem (timed)
THU (Off+Gym)   22:30-23:00   🪫 Light review
FRI (WFH)       20:30-21:30   🔋 Flashcard day (short)
SAT             09:00-11:00   🔥 Deep work
SUN             10:00-11:30   📊 Weekly Quiz + next week plan
```

**Meta-solution:** Every Sunday at 11:15-11:30, the plan is re-built fresh based on the upcoming week's office rotation and gym schedule. Templates are defaults, not straitjackets.

---

## Sunday Planning Ritual (15 min)

Every Sunday 11:15-11:30, end of weekly review:

1. **Input:** Next week's rotation (A or B)
2. **Input:** Gym days (user follows 2-on-1-off, skips Tuesdays)
3. **Input:** Fixed commitments (meetings, social, travel)
4. **Output:** 7-day session plan with energy bands, targets, and expected problems/topics

The output goes into `weekly-reviews/YYYY-Www-plan.md`.

---

## Daily Warm-Up Recall (3-5 min, every session start)

Active retrieval over passive re-reading. Spaced repetition schedule:
- **1 day** after topic learned
- **3 days** after
- **1 week** after
- **2 weeks** after
- **1 month** after

Mentor rotates 3 recall questions per session from the active deck. Weak topics surface more frequently.

---

## English Integration (Gradual)

- **Now (Month 1-2):** Problems solved in TR; problem descriptions read in EN
- **Month 3:** Weekly problem summaries written in EN
- **Month 3+:** Mock interviews conducted in EN

---

## Weekly Routine Rules

1. **Sustainability > intensity.** Missing a day is fine; missing a week needs recovery plan.
2. **Retrieval > re-reading.** Active recall beats passive review.
3. **Explain before code.** Verbal pseudocode + Big O before any Swift.
4. **Timed solo solving.** Track real solve time — this is the interview gap.
5. **Sunday planning is sacred.** 15 min, non-negotiable. Without it, retention collapses.
6. **No guilt rule.** Missed sessions are recovered, never punished.

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
- Tue: ✅ Planning + setup (this repo)
- Wed: ✅ Preview Two Sum (Office + Gym)
- Thu: ✅ Two Sum guided solve (Format B) → [0001-two-sum](problems/hashmap/0001-two-sum.md)
- Fri: 🪫 Light session (30-min passive review of Two Sum MD)
- Sat: ✅ Contains Duplicate solo (Format C) → [0217-contains-duplicate](problems/hashmap/0217-contains-duplicate.md)
- Sun: ✅ iOS Deep-Dive — ARC + Memory Management (Format D) → [memory-management](ios-depth/memory-management.md)
- Sun: 📊 Weekly Quiz + Week 2 plan (later)
