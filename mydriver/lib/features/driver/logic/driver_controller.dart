import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/core/models/booking.dart';

class DriverController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Booking> _orders = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Booking> get orders => _orders;

  // Fetch orders for the driver
  Future<void> fetchOrders(String driverId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/driver/orders?driverId=$driverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _orders = data.map((item) => Booking.fromJson(item)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage =
            jsonDecode(response.body)['message'] ?? 'Failed to fetch orders';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error connecting to the server';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Accept an order
  Future<bool> acceptOrder(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/driver/accept-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        _orders.firstWhere((order) => order.id == orderId).status = 'accepted';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            jsonDecode(response.body)['message'] ?? 'Failed to accept order';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error connecting to the server';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
