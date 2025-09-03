# EthioFootball Mobile (Flutter)

**EthioFootball** is an AI-powered football companion for Ethiopian fans.  
This repository contains the **Flutter mobile app**, built **mobile-first** with **offline support**, **Amharic/English localization**, and **lightweight football data integration**.  

---

## 📱 App Features

- **Chat Q&A** – Ask football questions in Amharic or English, get concise answers with freshness tags.  
- **Live Hub** – EPL (guaranteed) scores, fixtures, tables. Other leagues if available via API.  
- **Compare** – Team vs Team facts, rivalries, honors, recent form.  
- **News** – Summarized RSS sports feeds with “read source” links.  
- **My Clubs** – Follow up to 5 clubs (local/EPL), quick access + notifications.  
- **Offline Mode** – Cached club bios, FAQs, legends, and last known standings/fixtures.  

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)  
- **Key Packages:**  
  - `dio` – networking  
  - `sqflite` or `hive` – local storage/cache  
  - `cached_network_image` – optimized images  
  - `connectivity_plus` – online/offline detection  
  - `flutter_local_notifications` – fixture alerts  

---

## 📂 Project Structure

lib/
├── main.dart # App entry
├── ui/ # Widgets, screens (Chat, LiveHub, Compare, News, MyClubs, Offline)
├── models/ # Data models (Team, Fixture, Standing, NewsItem)
├── services/ # API + Cache layer
├── localization/ # Amharic/English strings
└── utils/ # Helpers (date, format, constants)

## ⚙️ Setup

1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥3.0).  
2. Clone the repo:
   git clone https://github.com/<org>/ethiofootball-mobile.git
   cd ethiofootball-mobile
3. Install dependencies: 
    flutter pub get
4. Run the app:
    flutter run