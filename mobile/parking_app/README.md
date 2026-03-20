# 📱 Smart Parking - Flutter Mobile App

Mobile application for the Smart Parking System. Built with Flutter for Android.

## ✅ Features

- 🔐 **Login** - Vehicle owner login with vehicle number
- 🅿️ **Parking Slots** - Real-time slot availability grid
- 💰 **Wallet** - Balance check and top-up
- 📋 **History** - Complete parking session history

## 🚀 Setup

### Prerequisites
- Flutter 3.41+
- Android Studio / Emulator
- Backend running on port 5001

### Install & Run
```bash
cd mobile/parking_app
flutter pub get
flutter run
```

### Run on specific device
```bash
flutter devices                    # List devices
flutter run -d emulator-5554      # Run on emulator
flutter run -d <device-id>        # Run on physical device
```

## 📁 Project Structure
```
lib/
├── main.dart              # App entry point
├── screens/
│   ├── login_screen.dart  # Login page
│   ├── home_screen.dart   # Main navigation
│   ├── slots_screen.dart  # Parking slots grid
│   ├── wallet_screen.dart # Wallet & top-up
│   └── history_screen.dart # Parking history
├── providers/
│   └── app_provider.dart  # State management
└── services/
    └── api_service.dart   # Backend API calls
```

## 🔗 API Connection

The app connects to the Flask backend at:
```dart
// For Android Emulator
static const String baseUrl = 'http://10.0.2.2:5001/api';

// For Physical Device (use your PC's IP)
static const String baseUrl = 'http://192.168.x.x:5001/api';
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.41
- **Language**: Dart 3.11
- **State Management**: Provider
- **HTTP Client**: http package
- **Storage**: shared_preferences

## 🐛 Troubleshooting

**Vehicle not found on login**
→ Register vehicle in database first

**Cannot connect to backend**
→ Make sure backend is running on port 5001
→ Android emulator uses `10.0.2.2` not `localhost`

**Build failed**
→ Run `flutter pub get` first
→ Make sure emulator is running