import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/core/models/user.dart';

class AuthController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // Register a user
  Future<bool> register(
    String phoneNumber,
    String password,
    String role,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:3000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        _currentUser = User(phoneNumber: phoneNumber, role: role);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage =
            jsonDecode(response.body)['message'] ?? 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error connecting to the server: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Direct login without OTP
  Future<bool> login(
    String phoneNumber,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Verify password and confirm password match
    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.11:3000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User(phoneNumber: phoneNumber, role: data['role']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = jsonDecode(response.body)['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error connecting to the server: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
