import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/../core/models/user.dart';

class AuthController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  bool _isOtpSentForLogin = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isOtpSentForLogin => _isOtpSentForLogin;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Common HTTP POST request with JSON
  Future<http.Response?> _postRequest(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (_) {
      _setError('Error connecting to the server');
      _setLoading(false);
      return null;
    }
  }

  /// Register a user with OTP
  Future<bool> register(String phoneNumber, String password, String role, String otp) async {
    _setLoading(true);
    _setError(null);

    final response = await _postRequest('http://localhost:3000/api/register', {
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
      'otp': otp,
    });

    if (response == null) return false;

    if (response.statusCode == 201) {
      _currentUser = User(phoneNumber: phoneNumber, role: role);
      _setLoading(false);
      return true;
    } else {
      _setError(jsonDecode(response.body)['message'] ?? 'Registration failed');
      _setLoading(false);
      return false;
    }
  }

  /// Send OTP for registration
  Future<bool> sendOtpForRegister(String phoneNumber) async {
    _setLoading(true);
    _setError(null);

    final response = await _postRequest('http://localhost:3000/api/send-otp-register', {
      'phoneNumber': phoneNumber,
    });

    if (response == null) return false;

    if (response.statusCode == 200) {
      _setLoading(false);
      return true;
    } else {
      _setError(jsonDecode(response.body)['message'] ?? 'Failed to send OTP');
      _setLoading(false);
      return false;
    }
  }

  /// Send OTP for login
  Future<bool> sendOtpForLogin(String phoneNumber) async {
    _setLoading(true);
    _setError(null);

    final response = await _postRequest('http://localhost:3000/api/send-otp-login', {
      'phoneNumber': phoneNumber,
    });

    if (response == null) return false;

    if (response.statusCode == 200) {
      _isOtpSentForLogin = true;
      _setLoading(false);
      return true;
    } else {
      _setError(jsonDecode(response.body)['message'] ?? 'Failed to send OTP');
      _setLoading(false);
      return false;
    }
  }

  /// Verify OTP and login
  Future<bool> verifyOtpForLogin(String phoneNumber, String password, String otp) async {
    _setLoading(true);
    _setError(null);

    final response = await _postRequest('http://localhost:3000/api/verify-otp-login', {
      'phoneNumber': phoneNumber,
      'password': password,
      'otp': otp,
    });

    if (response == null) return false;

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentUser = User(phoneNumber: phoneNumber, role: data['role']);
      _isOtpSentForLogin = false;
      _setLoading(false);
      return true;
    } else {
      _setError(jsonDecode(response.body)['message'] ?? 'Invalid OTP or login failed');
      _setLoading(false);
      return false;
    }
  }

  /// Simulate OTP sending (for development)
  Future<String?> sendOtp(String phoneNumber) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    _setLoading(false);
    return '123456';
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    _isOtpSentForLogin = false;
    notifyListeners();
  }
}
