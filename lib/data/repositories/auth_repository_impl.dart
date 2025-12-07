import 'package:athletica/data/datasources/supabase_service.dart';
import 'package:athletica/data/models/coach.dart';
import 'package:athletica/domain/repositories/auth_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Implementation of AuthRepository using Supabase
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseService _supabaseService;

  AuthRepositoryImpl(this._supabaseService);

  @override
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      return response;
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Sign up failed: ${e.toString()}',
        code: 'SIGNUP_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Sign in failed: ${e.toString()}',
        code: 'SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Sign out failed: ${e.toString()}',
        code: 'SIGNOUT_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      return await _supabaseService.forgotPassword(email: email);
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Forgot password failed: ${e.toString()}',
        code: 'FORGOT_PASSWORD_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      return await _supabaseService.signInWithGoogle(
        googleToken: googleToken,
        name: name,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Google sign in failed: ${e.toString()}',
        code: 'GOOGLE_SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      return await _supabaseService.signInWithFacebook(
        facebookToken: facebookToken,
        name: name,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Facebook sign in failed: ${e.toString()}',
        code: 'FACEBOOK_SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithApple({
    required String appleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      return await _supabaseService.signInWithApple(
        appleToken: appleToken,
        name: name,
        email: email,
        profilePhotoUrl: profilePhotoUrl,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Apple sign in failed: ${e.toString()}',
        code: 'APPLE_SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<Coach> getCoachProfile() async {
    try {
      final data = await _supabaseService.getCoachProfile();
      return Coach.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to get coach profile: ${e.toString()}',
        code: 'GET_COACH_ERROR',
      );
    }
  }

  @override
  Future<Coach> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      final data = await _supabaseService.updateCoachProfile(
        name: name,
        bio: bio,
        profilePhotoUrl: profilePhotoUrl,
      );
      return Coach.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to update coach profile: ${e.toString()}',
        code: 'UPDATE_COACH_ERROR',
      );
    }
  }

  @override
  bool get isAuthenticated => _supabaseService.currentUser != null;

  @override
  String? get currentUserId => _supabaseService.currentUser?.id;

  /// Transform Supabase snake_case data to camelCase for models
  Map<String, dynamic> _transformSupabaseData(Map<String, dynamic> data) {
    // Handle both snake_case (from Supabase) and camelCase (already transformed)
    return {
      'id': data['id'],
      'name': data['name'],
      'email': data['email'],
      'phone': data['phone'],
      'profilePhotoUrl': data['profile_photo_url'] ?? data['profilePhotoUrl'],
      'bio': data['bio'] ?? '',
      'certificates': (data['certificates'] as List?)?.map((e) => e.toString()).toList() ?? [],
      'subscriptionTier': data['subscription_tier'] ?? data['subscriptionTier'] ?? 'free',
      'clientLimit': data['client_limit'] ?? data['clientLimit'] ?? 3,
      'createdAt': data['created_at'] ?? data['createdAt'] ?? DateTime.now().toIso8601String(),
      'lastActive': data['last_active'] ?? data['lastActive'],
      'settings': data['settings'] ?? {},
    };
  }
}

