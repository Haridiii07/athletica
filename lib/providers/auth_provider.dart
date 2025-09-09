import 'package:flutter/material.dart';
import 'package:athletica/services/api_service.dart';
import 'package:athletica/models/coach.dart';
import 'package:athletica/utils/exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  Coach? _coach;
  bool _isLoading = false;
  String? _error;
  AppException? _lastException;

  Coach? get coach => _coach;
  bool get isLoading => _isLoading;
  String? get error => _error;
  AppException? get lastException => _lastException;
  bool get isAuthenticated => _coach != null;
  bool get isCoachLoaded => _coach != null;

  /// Check if the last error was due to authentication issues
  bool get isAuthError => _lastException is AuthException;

  /// Check if the last error was due to network issues
  bool get isNetworkError => _lastException is NetworkException;

  /// Check if the last error was due to validation issues
  bool get isValidationError => _lastException is ValidationException;

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
      _handleException(e as Exception);
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
    _lastException = null;

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
      _handleException(e as Exception);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _error = null;
    _lastException = null;

    try {
      final response = await _apiService.signIn(
        email: email,
        password: password,
      );

      _coach = Coach.fromJson(response['coach']);
      _setLoading(false);
      return true;
    } catch (e) {
      _handleException(e as Exception);
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
      _handleException(e as Exception);
    }
    _setLoading(false);
  }

  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    _error = null;
    _lastException = null;

    try {
      await _apiService.forgotPassword(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _handleException(e as Exception);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    _setLoading(true);
    _error = null;
    _lastException = null;

    try {
      final response = await _apiService.signInWithGoogle(
        googleToken: googleToken,
        name: name,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );

      _coach = Coach.fromJson(response['coach']);
      _setLoading(false);
      return true;
    } catch (e) {
      _handleException(e as Exception);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    _setLoading(true);
    _error = null;
    _lastException = null;

    try {
      final response = await _apiService.signInWithFacebook(
        facebookToken: facebookToken,
        name: name,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );

      _coach = Coach.fromJson(response['coach']);
      _setLoading(false);
      return true;
    } catch (e) {
      _handleException(e as Exception);
      _setLoading(false);
      return false;
    }
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
      _handleException(e as Exception);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    _lastException = null;
    notifyListeners();
  }

  /// Helper method to handle exceptions and set error state
  void _handleException(Exception e) {
    if (e is AppException) {
      _lastException = e;
      _error = e.message;
    } else {
      _lastException = null;
      _error = e.toString();
    }
    notifyListeners();
  }
}
