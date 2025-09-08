import 'package:flutter/material.dart';
import 'package:athletica/services/api_service.dart';
import 'package:athletica/models/coach.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  Coach? _coach;
  bool _isLoading = false;
  String? _error;

  Coach? get coach => _coach;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _coach != null;
  bool get isCoachLoaded => _coach != null;

  AuthProvider() {
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final token = await _apiService.authToken;
      if (token != null) {
        await _loadCoachData();
      }
    } catch (e) {
      // Token is invalid, clear it
      await _apiService.clearAuthToken();
    }
  }

  Future<void> _loadCoachData() async {
    try {
      _coach = await _apiService.getCoachProfile();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load coach data: $e';
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      _coach = Coach.fromJson(response['coach']);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.signIn(
        email: email,
        password: password,
      );

      _coach = Coach.fromJson(response['coach']);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _apiService.signOut();
      _coach = null;
    } catch (e) {
      _error = 'Failed to sign out: $e';
    }
    _setLoading(false);
  }

  Future<bool> updateProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    if (_coach == null) return false;

    try {
      _coach = await _apiService.updateCoachProfile(
        name: name,
        bio: bio,
        profilePhotoUrl: profilePhotoUrl,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile: $e';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reserved for future use to map backend error codes to user-friendly messages
  // String _getAuthErrorMessage(String code) { ... }
}
