# 🚗 Smart Parking System

A complete smart parking management system with automatic license plate recognition (ANPR), Flask backend API, ESP32 gate emulator, and Flutter mobile app.

## 👥 Team
- Dulieka Himashan
- Adithya Herath

**Institution:** NSBM Green University

## 📁 Project Structure
```
parking-system/
├── backend/              # Flask REST API + SQLite
│   ├── app.py            # Main Flask application
│   ├── database/         # SQLite database + models
│   ├── routes/           # API route handlers
│   ├── requirements.txt  # Python dependencies
│   ├── README.md         # API documentation
│   └── DATABASE_SCHEMA.md
│
├── anpr/                 # License Plate Recognition
│   ├── anpr_system.py    # EasyOCR + OpenCV script
│   ├── requirements.txt
│   └── README.md
│
├── esp32-emulator/       # Gate Controller Emulator
│   ├── gate_controller.py
│   ├── requirements.txt
│   └── README.md
│
├── mobile/               # Flutter Mobile App
│   └── parking_app/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── screens/  # Login, Slots, Wallet, History
│       │   ├── providers/ # State management
│       │   └── services/ # API service
│       └── pubspec.yaml
│
└── frontend/             # Web Dashboard
    ├── index.html
    ├── admin_dashboard.html
    ├── styles.css
    └── script.js
```

## ✅ Features

### 🔧 Backend API (Flask)
- Vehicle entry/exit management
- Automatic parking slot assignment
- Wallet-based payment system
- Parking fee calculation (Rs.10/hour, minimum 1 hour)
- Complete transaction history
- SQLite database with 4 tables

### 📷 ANPR System
- Real-time webcam capture via OpenCV
- AI-based license plate recognition using EasyOCR
- Multi-pass image preprocessing
- Sri Lankan plate format support
- Manual & Auto scan modes
- 99%+ accuracy on clear plates

### 🚧 ESP32 Gate Emulator
- Simulates physical gate hardware
- LED status indicators (Green/Red/Yellow)
- Servo motor simulation (open/close)
- Interactive & automatic modes
- Real-time backend communication

### 📱 Flutter Mobile App
- Vehicle owner login
- Real-time parking slot grid view
- Wallet balance & top-up (Rs.100/200/500/1000)
- Complete parking history
- Android support

### 🌐 Web Dashboard
- Real-time slot monitoring
- Admin controls
- Dark mode UI
- Dynamic updates via Fetch API

## 🚀 Quick Start

### Prerequisites
- Python 3.12+
- Flutter 3.41+
- Android Studio / Emulator

### 1. Backend Setup
```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
pip install -r requirements.txt
python app.py
```
✅ Backend runs on: `http://localhost:5001`

### 2. ANPR Setup
```bash
cd anpr
pip install easyocr opencv-python requests numpy
python anpr_system.py
```

### 3. ESP32 Emulator
```bash
cd esp32-emulator
pip install requests
python gate_controller.py
```

### 4. Flutter Mobile App
```bash
cd mobile/parking_app
flutter pub get
flutter run
```

### 5. Web Dashboard
Open `frontend/index.html` in your browser.

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| POST | `/api/vehicle/entry` | Vehicle entry |
| POST | `/api/vehicle/exit` | Vehicle exit |
| GET | `/api/slots` | Get all parking slots |
| GET | `/api/wallet/<vehicle>` | Get wallet balance |
| POST | `/api/wallet/topup` | Top up wallet |
| GET | `/api/history/<vehicle>` | Get parking history |

## 🗄️ Database Schema

| Table | Description |
|-------|-------------|
| vehicles | Registered vehicles + wallet balance |
| slots | 15 parking slots (A01-A10, B01-B05) |
| entry_exit_logs | Parking session history |
| transaction_logs | Wallet transactions |

### Default Data
- **Slots**: 10 regular (A01-A10) + 5 VIP (B01-B05)
- **Default Wallet**: Rs.100
- **Parking Fee**: Rs.10/hour (minimum 1 hour)

## 🔄 System Flow

### Automated Entry (ANPR)
```
1. Vehicle arrives at entry gate
2. ANPR camera captures license plate
3. EasyOCR extracts plate number (99%+ accuracy)
4. System sends plate to backend API
5. Backend checks registration & wallet balance
6. Available slot assigned automatically
7. Gate opens for 5 seconds then closes
```

### Mobile App Flow
```
1. User logs in with vehicle number
2. Views real-time slot availability
3. Checks wallet balance
4. Tops up wallet if needed
5. Views parking history
```

## 📊 System Architecture
```
📱 Mobile App          📷 ANPR Camera
      |                      |
      |    🌐 Web Dashboard  |
      |          |           |
      └──────────┼───────────┘
                 ↓
     🔧 Flask Backend (Port 5001)
                 ↓
        🗄️ SQLite Database
                 ↑
     🚧 ESP32 Gate Emulator
```

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Backend | Python 3.12, Flask, SQLite |
| ANPR | OpenCV, EasyOCR, PyTorch |
| Gate Emulator | Python (ESP32 simulation) |
| Mobile App | Flutter 3.41, Dart |
| Web Dashboard | HTML, CSS, JavaScript |

## 🐛 Troubleshooting

### Backend Issues
- **Database errors**: Delete `backend/database/parking.db` and restart
- **Import errors**: Make sure virtual environment is activated
- **Port in use**: Check nothing else is running on port 5001

### ANPR Issues
- **Slow first scan**: EasyOCR loads AI models on first use
- **No plate detected**: Improve lighting, hold plate steady
- **Connection refused**: Start backend server first

### Mobile App Issues
- **Vehicle not found**: Register vehicle in database first
- **Cannot connect**: Make sure backend is running on port 5001
- **Emulator**: Use `10.0.2.2` instead of `localhost` for Android emulator

## 🔮 Future Enhancements
- [ ] Payment gateway integration
- [ ] Push notifications
- [ ] Cloud database (Firebase/PostgreSQL)
- [ ] Advanced YOLO plate detection
- [ ] Multi-camera support
- [ ] iOS app support
- [ ] Reporting and analytics

## 📄 License
Educational project — NSBM Green University

## 👨‍💻 Tech Stack Summary
- **Backend**: Flask, SQLite, Python
- **ANPR**: OpenCV, EasyOCR, PyTorch
- **Mobile**: Flutter, Dart
- **Gate**: Python ESP32 Emulator
- **Frontend**: HTML, CSS, JavaScript

---
**Made with ❤️ for Smart Parking Management — NSBM Green University**