import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kigali_directory_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<String?> login(String email, String password) async {
    _setLoading(true);
    final error = await _authService.login(email, password);
    _setLoading(false);
    return error;
  }

  Future<String?> signUp(
      String email, String password, String name) async {
    _setLoading(true);
    final error = await _authService.signUp(email, password, name);
    _setLoading(false);
    return error;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}