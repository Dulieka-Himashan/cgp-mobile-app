# 🔧 Smart Parking System - Backend API

Flask REST API for managing the Smart Parking System with SQLite database.

## 📋 Database Schema

### 1. **Vehicles** Table
Registered vehicles with wallet balance
```sql
- vehicle_id (PRIMARY KEY)
- vehicle_number (UNIQUE)
- owner_name
- owner_phone
- vehicle_type (car/bike/etc)
- wallet_balance (default: 100.0)
- registered_at
- last_visit
- is_approved (0=pending, 1=approved, -1=rejected)
- rejection_reason
```

### 2. **Slots** Table
Parking slot inventory
```sql
- slot_id (PRIMARY KEY)
- slot_number (UNIQUE, e.g., A01, B05)
- slot_type (regular/vip)
- is_occupied (0/1)
- current_vehicle_number
- entry_time
- floor_level (Ground/First)
- is_active (0/1)
```

### 3. **EntryExitLogs** Table
Complete parking session history
```sql
- log_id (PRIMARY KEY)
- vehicle_number
- slot_number
- entry_time
- exit_time
- duration_minutes
- parking_fee
- wallet_balance_before
- wallet_balance_after
- status (active/completed)
```

### 4. **TransactionLogs** Table
Wallet transaction history
```sql
- transaction_id (PRIMARY KEY)
- vehicle_number
- transaction_type (CREDIT/DEBIT)
- amount
- balance_after
- timestamp
- notes
```

## 🚀 Installation & Setup

### 1. Activate Virtual Environment
```bash
cd parking-system
venv\Scripts\activate    # Windows
source venv/bin/activate # macOS/Linux
```

### 2. Install Dependencies
```bash
cd backend
pip install -r requirements.txt
```

### 3. Run the Server
```bash
python app.py
```

✅ Server starts on `http://localhost:5001`

## 📡 API Endpoints

### Health Check
```http
GET /api/health
```
**Response:**
```json
{
  "status": "success",
  "message": "Smart Parking System API is running",
  "timestamp": "2026-03-18T08:45:00"
}
```

---

### Vehicle Entry
```http
POST /api/vehicle/entry
Content-Type: application/json

{
  "vehicle_number": "SPQL9904",
  "owner_name": "Test User"
}
```

**Success Response (201):**
```json
{
  "status": "success",
  "message": "Vehicle entry recorded",
  "data": {
    "vehicle_number": "SPQL9904",
    "slot_number": "A01",
    "entry_time": "2026-03-18T08:45:00"
  }
}
```

**Error Responses:**
- `403` - Vehicle not registered or not approved
- `402` - Insufficient wallet balance
- `400` - Vehicle already parked
- `503` - Parking lot is full

---

### Vehicle Exit
```http
POST /api/vehicle/exit
Content-Type: application/json

{
  "vehicle_number": "SPQL9904"
}
```

**Success Response (200):**
```json
{
  "status": "success",
  "message": "Vehicle exit recorded",
  "data": {
    "vehicle_number": "SPQL9904",
    "slot_number": "A01",
    "entry_time": "2026-03-18T08:45:00",
    "exit_time": "2026-03-18T10:30:00",
    "duration_minutes": 105,
    "parking_fee": 20.0,
    "wallet_balance": 80.0
  }
}
```

**Error Responses:**
- `404` - Vehicle not found in parking lot
- `400` - Insufficient wallet balance

---

### Get All Slots
```http
GET /api/slots
```

**Response:**
```json
{
  "status": "success",
  "data": [...],
  "total_slots": 15,
  "occupied": 3,
  "available": 12
}
```

---

### Get Wallet Balance
```http
GET /api/wallet/SPQL9904
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "vehicle_number": "SPQL9904",
    "owner_name": "Test User",
    "wallet_balance": 80.0
  }
}
```

---

### Top Up Wallet
```http
POST /api/wallet/topup
Content-Type: application/json

{
  "vehicle_number": "SPQL9904",
  "amount": 500.0
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Wallet topped up successfully",
  "data": {
    "vehicle_number": "SPQL9904",
    "previous_balance": 80.0,
    "amount_added": 500.0,
    "new_balance": 580.0
  }
}
```

---

### Get Vehicle History
```http
GET /api/history/SPQL9904
```

**Response:**
```json
{
  "status": "success",
  "data": [...],
  "total_visits": 5
}
```

---

### Admin Logs
```http
GET /api/admin/logs?type=entry_exit&limit=100
GET /api/admin/logs?type=transactions&limit=100
```

## ⚙️ Configuration

### Parking Fee
Default: **Rs.10 per hour** (minimum 1 hour charge)

### Default Slots
- **Ground Floor**: 10 regular slots (A01-A10)
- **First Floor**: 5 VIP slots (B01-B05)

### Default Wallet Balance
New vehicles start with **Rs.100**

### Minimum Balance Required
**Rs.50** minimum required for entry

## 🧪 Testing with cURL

### Entry
```bash
curl -X POST http://localhost:5001/api/vehicle/entry \
  -H "Content-Type: application/json" \
  -d '{"vehicle_number": "SPQL9904", "owner_name": "Test User"}'
```

### Exit
```bash
curl -X POST http://localhost:5001/api/vehicle/exit \
  -H "Content-Type: application/json" \
  -d '{"vehicle_number": "SPQL9904"}'
```

### Check Slots
```bash
curl http://localhost:5001/api/slots
```

### Check Wallet
```bash
curl http://localhost:5001/api/wallet/SPQL9904
```

## 🐛 Troubleshooting

- **Database errors**: Delete `database/parking.db` and restart
- **Import errors**: Make sure virtual environment is activated
- **Port in use**: Check nothing else is running on port 5001
- **403 on entry**: Check vehicle `is_approved = 1` in database
- **402 on entry**: Check vehicle `wallet_balance >= 50` in database

## 📝 Notes

- All vehicle numbers are automatically converted to **UPPERCASE**
- Parking fee calculated based on duration (**minimum 1 hour**)
- Wallet balance must be sufficient for exit
- Database is **auto-created** on first run
- CORS is enabled for frontend and mobile app integration
- Android emulator connects via `10.0.2.2:5001` instead of `localhost`