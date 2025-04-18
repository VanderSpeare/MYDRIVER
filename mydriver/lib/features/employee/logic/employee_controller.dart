import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _tasks = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get tasks => _tasks;

  // Fetch collaborator tasks
  Future<void> fetchTasks(String employeeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/employee/tasks?employeeId=$employeeId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _tasks = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = jsonDecode(response.body)['message'] ?? 'Failed to fetch tasks';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error connecting to the server';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Complete a task
  Future<bool> completeTask(String taskId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/employee/complete-task'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'taskId': taskId}),
      );

      if (response.statusCode == 200) {
        _tasks.firstWhere((task) => task['id'] == taskId)['status'] = 'completed';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = jsonDecode(response.body)['message'] ?? 'Failed to complete task';
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