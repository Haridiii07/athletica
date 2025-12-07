import 'package:athletica/data/models/coach.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<Map<String, dynamic>> forgotPassword({required String email});

  Future<Map<String, dynamic>> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  });

  Future<Map<String, dynamic>> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  });

  Future<Map<String, dynamic>> signInWithApple({
    required String appleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  });

  Future<Coach> getCoachProfile();
  Future<Coach> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  });

  bool get isAuthenticated;
  String? get currentUserId;
}

