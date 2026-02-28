# Next Stop 🚆⏰

## Sleep peacefully. We’ll wake you before your stop.

Next Stop is a smart arrival alarm app designed for commuters who want to rest during travel without missing their destination. Whether you're on a bus, train, or metro, Next Stop monitors your journey and alerts you before you arrive.

Built with Flutter and Riverpod, the app focuses on reliability, minimal user friction, and real-world usability.

---

## 📌 The Problem

Many people check the distance to their destination in Google Maps and then fall asleep while traveling.

If navigation isn’t actively running, there is no reliable wake-up alert before arrival.

Missing your stop can result in:

- Extra travel time
- Additional expenses
- Stress during daily commute
- Safety concerns during late-night travel

Next Stop solves this problem with a simple and intelligent arrival alarm system.

---

## 🚀 Core Features (MVP)

- 📍 Share destination directly from Google Maps
- 🔔 Loud arrival alarm before reaching your stop
- 🧠 Smart radius detection (adjusts alert distance based on speed)
- 🔋 Reliable foreground location tracking
- 📱 Works even when the phone is locked
- ⚡ Minimal interaction required

---

## 🧠 How It Works

1. Search your destination in Google Maps
2. Tap **Share → Next Stop**
3. Confirm the destination
4. Tap **Start Alarm Mode**
5. Lock your phone and relax

Next Stop tracks your live location in the background and triggers a loud alarm before you reach your destination.

---

## 🏗 Architecture Overview

Flutter UI
↓
ArrivalController (Riverpod)
↓
Location Service
↓
Smart Radius Engine
↓
Alarm Service

### Core Components

- **ArrivalController**  
  Manages app state and tracking lifecycle.

- **Location Service**  
  Provides live GPS updates using background tracking.

- **Smart Radius Engine**  
  Dynamically adjusts alert distance based on speed.

- **Alarm Service**  
  Triggers a loud wake-up notification before arrival.

---

## 🛠 Tech Stack

- Flutter
- Riverpod (State Management)
- Geolocator
- Flutter Background Service
- Flutter Local Notifications

Android-first architecture.

---

## 🧠 Smart Radius Logic

Instead of using a fixed alert distance, Next Stop adjusts dynamically:

- High speed (train/highway) → Larger alert radius
- Medium speed (bus) → Moderate radius
- Low speed (city traffic) → Smaller radius

This ensures:

- No late alerts
- No unnecessary early wake-ups
- More accurate arrival timing

---

## 🎯 Ideal Use Cases

- Daily bus commuters
- Train travelers
- Metro riders
- Long-distance travelers
- Students and office commuters
- Night travel

---

## 🔐 Permissions Used

Next Stop only requests necessary permissions:

- Precise Location
- Background Location (Android)
- Foreground Service (Android)

No accessibility services.  
No intrusive overlay permissions in the MVP.

---

## 📱 Platform Support

- Android (Primary Target)
- iOS support planned for future versions

---

## 🚧 Development Status

- MVP in development
- Android-first release
- Core tracking logic in progress

---

## 🗺 Roadmap

### Phase 1 – MVP

- Share-to-activate
- Background tracking
- Smart radius
- Alarm trigger

### Phase 2

- Optional overlay mode
- Alarm customization
- Travel history
- Battery optimization improvements

### Phase 3

- iOS support
- Route intelligence
- Smart commute profiles

---

## 💡 Vision

Next Stop aims to become the simplest and most reliable arrival wake-up assistant for commuters worldwide.

Sleep peacefully. We’ll handle the stop.
