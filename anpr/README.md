# 📷 ANPR System - License Plate Recognition

Automatic Number Plate Recognition system using EasyOCR and OpenCV. Detects license plates from webcam and sends them to the Smart Parking backend.

## ✅ Features

- ✅ **Real-time webcam capture** - Live video feed via OpenCV
- ✅ **AI-based OCR** - EasyOCR with 99%+ accuracy on clear plates
- ✅ **Multi-pass preprocessing** - Grayscale, CLAHE contrast, Otsu threshold
- ✅ **Sri Lankan plate support** - Handles province codes and fuel type suffixes
- ✅ **Text validation** - Cleans and validates plate numbers automatically
- ✅ **Backend integration** - Sends plate data to Flask parking API
- ✅ **Manual & Auto modes** - Click to scan or automatic every 2 seconds

## 📋 Prerequisites

- Python 3.12+
- Webcam
- Backend server running on port 5001

## 🚀 Installation

### 1. Activate Virtual Environment
```bash
cd parking-system
venv\Scripts\activate    # Windows
source venv/bin/activate # macOS/Linux
```

### 2. Install Dependencies
```bash
pip install easyocr opencv-python requests numpy
```

### 3. Verify Installation
```bash
python -c "import easyocr; import cv2; print('All OK!')"
```

## 🎮 Usage
```bash
# Make sure backend server is running first!
python anpr/anpr_system.py
```

**Select mode when prompted:**

**Mode 1 - Manual (Recommended for testing):**
- Camera window opens
- Click anywhere on window to scan
- Confirm detected plate with `y` or reject with `n`

**Mode 2 - Auto:**
- Automatically scans every 2 seconds
- Good for demo purposes

**Keyboard Controls:**
- `E` - Switch to Entry mode
- `X` - Switch to Exit mode
- `Q` - Quit application

## 🔧 How It Works

### 1. Image Capture
```python
cap = cv2.VideoCapture(0)
ret, frame = cap.read()
```

### 2. Multi-Pass Preprocessing
```python
# Pass 1: Grayscale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Pass 2: CLAHE Contrast Enhancement
clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
contrast = clahe.apply(gray)

# Pass 3: Otsu Thresholding
_, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
```

### 3. EasyOCR Text Extraction
```python
reader = easyocr.Reader(['en'], gpu=False)
results = reader.readtext(
    img,
    allowlist='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
    paragraph=False,
    detail=1
)
```

### 4. Sri Lankan Plate Cleaning
```python
# Removes province codes (WP, CP, SP, NP...)
# Removes fuel type (P = Petrol, D = Diesel)
# Result: "SPQL9904" -> "QL9904" or keeps as "SPQL9904"
```

### 5. Send to Backend
```python
response = requests.post(
    "http://localhost:5001/api/vehicle/entry",
    json={"vehicle_number": plate_number, "owner_name": "Camera"}
)
```

## 📊 Example Output
```
🔄 Loading EasyOCR...
Using CPU. Note: This module is much faster with a GPU.
✅ Ready!

============================================================
SMART PARKING - ANPR SYSTEM
1. MANUAL MODE (Click to Scan)
2. AUTO MODE (Scans every 2 seconds)
============================================================
Select Mode (1 or 2): 1
✅ MANUAL MODE SELECTED

📸 SCANNING...
🔍 Analyzing frame...
🏆 Best Match: SPQL9904 (Score: 0.99)
✅ DETECTED: SPQL9904
   Confirm SPQL9904? (y/n): y
📡 Sending to backend (ENTRY)...
🎉 SUCCESS! Slot: A01
```

## ⚙️ Configuration

Edit these values at the top of `anpr_system.py`:
```python
BACKEND_URL = os.environ.get('BACKEND_URL', "http://localhost:5001/api")
CAMERA_INDEX = 0         # 0 = default webcam, 1 = external camera
AUTO_SCAN_INTERVAL = 2.0 # Seconds between auto scans
```

## 🐛 Troubleshooting

### "No module named easyocr"
```bash
pip install easyocr
# If still not found:
python -m pip install easyocr
```

### "No module named cv2"
```bash
pip install opencv-python-headless
```

### Conflict between opencv-python and opencv-python-headless
```bash
pip uninstall opencv-python
pip install opencv-python-headless
```

### "Cannot open camera"
```bash
# Try different camera index
CAMERA_INDEX = 1  # or 2
```

### "No plate detected"
- Ensure good lighting (avoid shadows)
- Hold plate steady inside the green rectangle
- Keep plate 20-30cm from camera
- Face plate directly (avoid skew angles)
- Try using a printed plate or phone screen

### "Cannot connect to backend API"
```bash
# Start backend server first
cd backend
python app.py
# Wait for: Running on http://127.0.0.1:5001
```

### Slow detection
- EasyOCR loads AI models on first use (takes 30-60 seconds)
- Subsequent scans are faster
- GPU support would significantly speed this up

## 📝 Notes

- **First scan**: Always slower due to model loading
- **Lighting**: Critical for accuracy — bright, even lighting works best
- **Distance**: Keep plate 20-30cm from camera
- **Angle**: Face plate directly to camera
- **Backend**: Must be running before starting ANPR

## 🔮 Future Enhancements

- [ ] YOLO-based plate detection for better accuracy
- [ ] GPU support for faster processing
- [ ] Support multiple plate formats (different countries)
- [ ] Multi-camera support
- [ ] Plate tracking across frames
- [ ] Confidence threshold configuration
- [ ] Save captured plate images for audit

## 📚 Dependencies

- **easyocr** - AI-based OCR engine (replaces Tesseract)
- **opencv-python** - Webcam capture and image processing
- **torch** - PyTorch backend (required by EasyOCR)
- **requests** - HTTP API calls to backend
- **numpy** - Image array operations
- **Pillow** - Image manipulation support