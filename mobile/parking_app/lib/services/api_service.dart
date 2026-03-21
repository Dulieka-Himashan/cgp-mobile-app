import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5001/api';

  // Get parking slots
  static Future<Map<String, dynamic>> getSlots() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/slots'));
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Get wallet balance
  static Future<Map<String, dynamic>> getWallet(String vehicleNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/$vehicleNumber'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Top up wallet
  static Future<Map<String, dynamic>> topUpWallet(
    String vehicleNumber,
    double amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/topup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'vehicle_number': vehicleNumber, 'amount': amount}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // Get parking history
  static Future<Map<String, dynamic>> getHistory(String vehicleNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history/$vehicleNumber'),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
  // Register vehicle
static Future<Map<String, dynamic>> registerVehicle(
  String vehicleNumber,
  String ownerName,
  String vehicleType,
  String ownerPhone,
) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicle/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'vehicle_number': vehicleNumber,
        'owner_name': ownerName,
        'vehicle_type': vehicleType,
        'owner_phone': ownerPhone,
      }),
    );
    return jsonDecode(response.body);
  } catch (e) {
    return {'status': 'error', 'message': e.toString()};
  }
}
}