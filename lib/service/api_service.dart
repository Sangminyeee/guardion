import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://3.39.253.151:8080';
  static final _storage = const FlutterSecureStorage();

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  static Future<Map<String, dynamic>> getTemperatureHumidity(
      String serialNumber,
      ) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/temperature-humidity/$serialNumber'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load temperature and humidity');
    }
  }

  static Future<Map<String, dynamic>> getDeviceData(String serialNumber) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/device-data/$serialNumber'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load device data');
    }
  }

  static Future<void> registerDevice(Map<String, dynamic> deviceData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/device'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(deviceData),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register device');
    }
  }

  static Future<List<dynamic>> getAlerts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/alert/all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load alerts');
    }
  }

  static Future<Map<String, dynamic>> getAlert(String alertId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/alert/$alertId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load alert');
    }
  }
}