import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Check if a user is already logged in
  Future<void> checkCurrentUser() async {
    _setLoading(true);
    final user = _firebaseService.currentUser;
    if (user != null) {
      _currentUser = await _firebaseService.getUserDetails(user.uid);
    }
    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _firebaseService.loginUser(email, password);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, String role) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentUser = await _firebaseService.registerUser(email, password, name, role);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseService.logout();
    _currentUser = null;
    notifyListeners();
  }
}
