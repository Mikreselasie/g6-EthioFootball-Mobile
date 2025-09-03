# EthioFootball

**AI-Powered Football Companion for Ethiopians**
Mobile-first • Flutter • Amharic/English • Offline-friendly • Thin GenAI Wrapper

---

## 🚀 Overview

Football is huge in Ethiopia — from **St. George, Bunna, Coffee, and the Walias** to EPL favorites like **Arsenal**. But fans often struggle to find reliable, timely info in one place. Existing sources are fragmented, heavy for low-bandwidth users, and rarely support **Amharic**.

**EthioFootball** is a **localized AI-powered companion** designed for Ethiopian football fans. It:

* Answers football questions in **Amharic/English**.
* Shows **scores, fixtures, tables, and news summaries**.
* Works **offline with cached data** (club histories, last tables, FAQs).
* Prioritizes **simplicity, transparency, and connectivity awareness**.

---

## 📱 Features (V1)

* **Conversational Q\&A (Amharic & English)**
  Ask “St. George vs Bunna head-to-head?” → see recent form, history, and freshness tag.

* **Live Tiles (via APIs)**
  EPL guaranteed: Scores, Fixtures, Tables (others if available).

* **Compare & Fun Facts**
  Side-by-side clubs: honors, notable players, fanbase notes (with source labels).

* **News Briefs**
  Summarized from RSS feeds (local publishers, federation posts).

* **Offline Mode**
  Cached club bios, chants, legends, FAQs + last known results/standings.

* **My Clubs**
  Follow 3–5 clubs (local or EPL). Quick access + notifications.

---

## 🎯 Goals & Success Metrics

* **Adoption:** ≥10,000 Q\&A interactions in first month
* **Speed:** ≤2.5s cached / ≤4.5s live
* **Reliability:** Freshness badge on ≥90% responses
* **Language:** ≥70% Amharic usage
* **Engagement:** ≥35% sessions include follow-up/compare/fixtures

---

## 🛠️ Tech Stack

**Mobile (primary):** Flutter

* `dio`, `sqflite/hive`, `cached_network_image`, `connectivity_plus`, `flutter_local_notifications`

**Backend:** FastAPI (Python) \[or Node.js/Go alternative]

* LLM orchestration (thin wrapper)
* Licensed football API integration (EPL + others)
* RSS ingestion for sports news
* Redis-class cache for standings/fixtures

**Web (optional demo):** Next.js (TypeScript)

---

## 🗂️ Architecture

```mermaid
flowchart LR
    U[User Question] --> IP[Intent Parser (LLM)]
    IP --> R[Router]
    R -->|Live Data| API[Football API / RSS]
    R -->|Offline| Cache[(Local Cache)]
    API --> AC[Answer Composer (LLM)]
    Cache --> AC
    AC --> UI[Mobile/Web UI]
```

---

## 📑 Data Model (Sketch)

* **Team**: id, name, league, crest, bio (curated)
* **Standing**: league, season, pos, team\_id, pts, gd, updated
* **Fixture**: id, league, date, home\_id, away\_id, status, score
* **NewsItem**: title, snippet, source, url, published\_at
* **FollowedTeam**: team\_id, notify
* **CacheMeta**: key, source, freshness\_ts

---

## 📅 Execution Plan (3 Weeks)

**Week 1 – Foundations (Aug 22–28)**

* Backend scaffolding (/intent, mock endpoints)
* Mobile Flutter Home (Chat, Answer Card, Live Hub skeleton)
* Offline library (sample club bios)
* Web Next.js skeleton

**Week 2 – Integration (Aug 29–Sep 4)**

* EPL live data (fixtures/standings)
* RSS news integration
* Curated Ethiopian clubs dataset
* My Clubs (follow & notifications)
* End-to-end QA with 20 sample queries

**Week 3 – Hardening & Demo (Sep 5–10)**

* Rate limits, fallbacks, cache tuning
* UI polish + offline states
* Accessibility labels
* Demo-ready scenario (Amharic + English)

---

## 🎨 Design

* **Colors:** Deep Blue `#0D2A4B`, Green `#22C55E`, Red `#EF4444`, Neutral Slate `#F2F4F7`
* **Typography:** Noto Sans Ethiopic (Amharic), Inter (English)
* **Components:** Chat composer, Answer cards, Score tiles, Table widgets, Compare sheets, News cards
* **Tone:** Friendly, respectful, transparent (no toxic banter)

---

## ⚖️ Non-Functional Requirements

* **Performance:** Cached ≤2.5s, Live ≤4.5s
* **Offline:** Cached bios, last tables/fixtures
* **Privacy:** No login required (favorites stored locally)
* **Cost control:** Short LLM prompts, cached summaries, rate limits

---

## 📜 License

TBD (team decision). Suggest: **MIT** for app code, **Attribution for curated data**.

---

## 🙌 Credits

**Operation Walias** team (Backend, Mobile, Web).
Built for Ethiopian football fans, with ❤️ for the game.
