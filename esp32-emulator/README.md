# 🚧 ESP32 Gate Controller Emulator

Python-based emulator for ESP32 microcontroller that controls a parking gate. No real hardware required!

## ✅ Features

- ✅ **Car detection simulation** - Simulates IR/ultrasonic sensor
- ✅ **Backend communication** - Sends plate data to Flask API
- ✅ **Gate control** - Opens/closes based on backend approval
- ✅ **LED indicators** - Green (approved), Red (denied), Yellow (processing)
- ✅ **Two modes** - Interactive and Automatic
- ✅ **Hardware simulation** - GPIO pins, servo motor, sensors

## 🔧 Hardware Simulation

### Simulated Components

| Component | GPIO Pin | Purpose |
|-----------|----------|---------|
| Car Sensor | GPIO 2 | Detects vehicle presence |
| Servo Motor | GPIO 9 | Controls gate movement |
| Green LED | GPIO 13 | Approved indicator |
| Red LED | GPIO 12 | Denied indicator |
| Yellow LED | GPIO 14 | Processing indicator |

### Gate States
- **CLOSED** - Default state, servo at 0°
- **OPEN** - Vehicle approved, servo at 90°

## 🚀 Installation
```bash
cd esp32-emulator
pip install requests
```

## 🎮 Usage

### Prerequisites
Backend server must be running first:
```bash
cd backend
python app.py
```

### Run the Emulator
```bash
python gate_controller.py
```

## 📋 Operating Modes

### 1. Interactive Mode (Recommended)

Manual control — enter plate numbers directly.

**Commands:**
```
entry SPQL9904    # Simulate vehicle entry
exit SPQL9904     # Simulate vehicle exit
status            # Show hardware status
quit              # Exit
```

**Example Session:**
```
> entry SPQL9904
🚗 VEHICLE DETECTED AT ENTRY GATE - 19:49:40
📋 License Plate: SPQL9904
📤 Sending to backend: SPQL9904
   Response: 201
✅ APPROVED
   Assigned Slot: A01
🎉 Gate Open
⏱️  Keeping gate open for 5 seconds...
🚪 Closing gate...
✓ Gate CLOSED
```

### 2. Automatic Mode

Simulates random car arrivals automatically.
```
Select mode:
  1. Interactive mode
  2. Automatic mode
Enter choice: 2
```

## 🔄 System Flow
```
Vehicle Arrives
      ↓
Yellow LED ON (Processing)
      ↓
Send Plate to Backend API
POST /api/vehicle/entry
      ↓
   Response?
  ↙        ↘
201         4xx/5xx
✅           ❌
  ↓           ↓
Green LED   Red LED
Gate OPEN   Gate CLOSED
  ↓
Wait 5 sec
  ↓
Gate CLOSE
Green LED OFF
```

## 📊 Example Output

### Successful Entry
```
============================================================
🚗 VEHICLE DETECTED AT ENTRY GATE - 19:49:40
============================================================
   💡 YELLOW LED (GPIO 14): ON
📋 License Plate: SPQL9904
📤 Sending to backend: SPQL9904
   URL: http://localhost:5001/api/vehicle/entry
   Response: 201
✅ APPROVED
   💡 GREEN LED (GPIO 13): ON
   Assigned Slot: A01
   Entry Time: 2026-03-18T19:49:42
🎉 Gate Open
🚪 Opening gate...
   [Servo] Moving to 90°
   ✓ Gate OPEN
⏱️  Keeping gate open for 5 seconds...
🚪 Closing gate...
   [Servo] Moving to 0°
   ✓ Gate CLOSED
   💡 GREEN LED (GPIO 13): OFF
📊 Status: Gate=CLOSED 🔴 | Sensor=DETECTED 🚗 | LEDs=⚫⚫⚫
```

### Successful Exit
```
============================================================
🚗 VEHICLE DETECTED AT EXIT GATE - 19:50:28
============================================================
📋 License Plate: SPQL9904
   Response: 200
✅ APPROVED
   Duration: 0 mins
   Fee: Rs.10.0
   Wallet Balance: Rs.63.61
   Status: PAID & EXITING
🎉 Gate Open
✓ Gate OPEN
⏱️  Keeping gate open for 5 seconds...
✓ Gate CLOSED
```

### Denied Entry
```
📋 License Plate: SPQL9904
   Response: 400
❌ DENIED
   Reason: Vehicle is already parked
🚫 Gate Closed
```

## ⚙️ Configuration

Edit `gate_controller.py`:
```python
BACKEND_URL = "http://localhost:5001/api"  # Backend URL
GATE_OPEN_DURATION = 5                     # Seconds to keep gate open
```

## 🐛 Troubleshooting

### "Cannot connect to backend"
Start backend server first:
```bash
cd backend
python app.py
```

### "Connection refused"
Check backend is running on port 5001:
```python
BACKEND_URL = "http://localhost:5001/api"
```

### "Vehicle already parked"
Do an exit first:
```
> exit SPQL9904
```

### "Vehicle not found in parking lot"
Do an entry first:
```
> entry SPQL9904
```

## 🔮 Real ESP32 Implementation

To deploy on real ESP32 hardware:

1. **Replace simulation with real GPIO:**
```python
from machine import Pin, PWM
sensor = Pin(2, Pin.IN)
servo = PWM(Pin(9), freq=50)
led_green = Pin(13, Pin.OUT)
```

2. **Add WiFi connection:**
```python
import network
wlan = network.WLAN(network.STA_IF)
wlan.connect('YOUR_SSID', 'YOUR_PASSWORD')
```

3. **Use urequests instead of requests:**
```python
import urequests as requests
```

4. **Flash MicroPython to ESP32:**
```bash
esptool.py --port COM3 write_flash 0x1000 firmware.bin
```

## 📝 Notes

- This is a **software emulator** — no real hardware needed
- Simulates all ESP32 components in Python
- Perfect for testing and demos
- Real ESP32 deployment requires MicroPython

## 🎓 Resources

- **ESP32 Docs**: https://docs.espressif.com/
- **MicroPython**: https://micropython.org/