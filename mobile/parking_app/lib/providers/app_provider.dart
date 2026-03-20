import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  String _vehicleNumber = '';
  String _ownerName = '';
  double _walletBalance = 0.0;
  bool _isLoggedIn = false;

  String get vehicleNumber => _vehicleNumber;
  String get ownerName => _ownerName;
  double get walletBalance => _walletBalance;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String vehicleNumber, String ownerName) async {
    _vehicleNumber = vehicleNumber.toUpperCase();
    _ownerName = ownerName;
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vehicle_number', _vehicleNumber);
    await prefs.setString('owner_name', _ownerName);

    notifyListeners();
  }

  Future<void> logout() async {
    _vehicleNumber = '';
    _ownerName = '';
    _walletBalance = 0.0;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  void updateBalance(double balance) {
    _walletBalance = balance;
    notifyListeners();
  }

  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedVehicle = prefs.getString('vehicle_number');
    final savedName = prefs.getString('owner_name');

    if (savedVehicle != null && savedName != null) {
      _vehicleNumber = savedVehicle;
      _ownerName = savedName;
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}