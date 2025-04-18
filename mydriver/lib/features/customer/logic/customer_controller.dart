import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/core/models/booking.dart';

class CustomerController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final List<Booking> _bookings = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Booking> get bookings => _bookings;

  // Book a ride
  Future<bool> bookRide(String customerId, String source, String destination, String vehicleType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/customer/book'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customerId': customerId,
          'source': source,
          'destination': destination,
          'vehicleType': vehicleType,
        }),
      );

      if (response.statusCode == 201) {
        _bookings.add(Booking(
          id: jsonDecode(response.body)['bookingId'],
          customerId: customerId,
          source: source,
          destination: destination,
          vehicleType: vehicleType,
          status: 'pending',
        ));
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = jsonDecode(response.body)['message'] ?? 'Booking failed';
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

  // Send goods
  Future<bool> sendGoods(String customerId, String sender, String receiver, String item) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/customer/shipment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customerId': customerId,
          'sender': sender,
          'receiver': receiver,
          'item': item,
        }),
      );

      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = jsonDecode(response.body)['message'] ?? 'Shipment failed';
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