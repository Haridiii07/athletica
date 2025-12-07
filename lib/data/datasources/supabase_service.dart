import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:athletica/config/app_config.dart';
import 'package:athletica/utils/exceptions.dart';
import 'dart:io';

/// Supabase service for handling all backend operations
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  late final SupabaseClient _client;

  SupabaseService._() {
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  /// Initialize Supabase (should be called in main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  /// Helper method to handle Supabase exceptions and convert them to custom exceptions
  AppException _handleSupabaseException(Object e, [String? operation]) {
    // Check for Supabase AuthException (from gotrue package)
    if (e.toString().contains('AuthException') || 
        e.toString().contains('Invalid login credentials') ||
        e.toString().contains('Invalid credentials')) {
      final message = e.toString();
      if (message.contains('Invalid login credentials') || 
          message.contains('Invalid credentials')) {
        return AuthException.invalidCredentials();
      }
      if (message.contains('Email not confirmed') || 
          message.contains('email not confirmed')) {
        return AuthException.emailNotVerified();
      }
      return AuthException(
        message: message,
        code: 'AUTH_ERROR',
      );
    }

    if (e is PostgrestException) {
      // Handle PostgreSQL errors
      if (e.code == '23505') {
        // Unique constraint violation
        if (e.message.contains('email')) {
          return ValidationException.emailTaken();
        }
        return DataException.conflict('Resource');
      }
      if (e.code == 'PGRST116') {
        return DataException.notFound(operation ?? 'Resource');
      }
      return NetworkException(
        message: e.message,
        code: e.code,
      );
    }

    if (e is StorageException) {
      return NetworkException(
        message: 'Storage error: ${e.message}',
        code: e.statusCode?.toString(),
      );
    }

    return NetworkException(
      message: 'An unexpected error occurred: ${e.toString()}',
      code: 'UNKNOWN_ERROR',
    );
  }

  // ========== AUTHENTICATION METHODS ==========

  /// Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
        },
      );

      if (response.user == null) {
        throw AuthException(
          message: 'Failed to create account',
          code: 'SIGNUP_FAILED',
        );
      }

      // Create coach profile in coaches table
      await _client.from('coaches').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
        'subscription_tier': 'free',
        'client_limit': 3,
      });

      return {
        'token': response.session?.accessToken,
        'coach': {
          'id': response.user!.id,
          'name': name,
          'email': email,
          'phone': phone,
          'createdAt': DateTime.now().toIso8601String(),
          'subscriptionTier': 'free',
          'clientLimit': 3,
        },
      };
    } catch (e) {
      throw _handleSupabaseException(e, 'signUp');
    }
  }

  /// Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null || response.session == null) {
        throw AuthException.invalidCredentials();
      }

      // Fetch coach profile
      final coachData = await _client
          .from('coaches')
          .select()
          .eq('id', response.user!.id)
          .single();

      return {
        'token': response.session!.accessToken,
        'coach': coachData,
      };
    } catch (e) {
      throw _handleSupabaseException(e, 'signIn');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw _handleSupabaseException(e, 'signOut');
    }
  }

  /// Forgot password
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return {
        'message': 'Password reset email sent',
      };
    } catch (e) {
      throw _handleSupabaseException(e, 'forgotPassword');
    }
  }

  /// Sign in with Google
  /// Note: This requires OAuth setup in Supabase. For now, returns error.
  Future<Map<String, dynamic>> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      // OAuth sign in requires redirect flow, not token-based
      // This is a placeholder - implement OAuth redirect flow separately
      throw ExternalServiceException.googleSignIn();
    } catch (e) {
      throw _handleSupabaseException(e, 'signInWithGoogle');
    }
  }

  /// Sign in with Facebook
  /// Note: This requires OAuth setup in Supabase. For now, returns error.
  Future<Map<String, dynamic>> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      // OAuth sign in requires redirect flow, not token-based
      // This is a placeholder - implement OAuth redirect flow separately
      throw ExternalServiceException.facebookSignIn();
    } catch (e) {
      throw _handleSupabaseException(e, 'signInWithFacebook');
    }
  }

  /// Sign in with Apple
  /// Note: This requires OAuth setup in Supabase. For now, returns error.
  Future<Map<String, dynamic>> signInWithApple({
    required String appleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      // OAuth sign in requires redirect flow, not token-based
      // This is a placeholder - implement OAuth redirect flow separately
      throw ExternalServiceException.appleSignIn();
    } catch (e) {
      throw _handleSupabaseException(e, 'signInWithApple');
    }
  }

  /// Get current user session
  User? get currentUser => _client.auth.currentUser;

  /// Get current session
  Session? get currentSession => _client.auth.currentSession;

  // ========== COACH METHODS ==========

  /// Get coach profile
  Future<Map<String, dynamic>> getCoachProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('coaches')
          .select()
          .eq('id', userId)
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'getCoachProfile');
    }
  }

  /// Update coach profile
  Future<Map<String, dynamic>> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (bio != null) updateData['bio'] = bio;
      if (profilePhotoUrl != null) updateData['profile_photo_url'] = profilePhotoUrl;
      updateData['last_active'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('coaches')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'updateCoachProfile');
    }
  }

  // ========== CLIENT METHODS ==========

  /// Get all clients for current coach
  Future<List<Map<String, dynamic>>> getClients() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('clients')
          .select()
          .eq('coach_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'getClients');
    }
  }

  /// Get client by ID
  Future<Map<String, dynamic>> getClientById(String clientId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('clients')
          .select()
          .eq('id', clientId)
          .eq('coach_id', userId)
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'getClientById');
    }
  }

  /// Add a new client
  Future<Map<String, dynamic>> addClient(Map<String, dynamic> clientData) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final insertData = {
        ...clientData,
        'coach_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('clients')
          .insert(insertData)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'addClient');
    }
  }

  /// Update client
  Future<Map<String, dynamic>> updateClient(
    String clientId,
    Map<String, dynamic> clientData,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('clients')
          .update(clientData)
          .eq('id', clientId)
          .eq('coach_id', userId)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'updateClient');
    }
  }

  /// Delete client
  Future<void> deleteClient(String clientId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      await _client
          .from('clients')
          .delete()
          .eq('id', clientId)
          .eq('coach_id', userId);
    } catch (e) {
      throw _handleSupabaseException(e, 'deleteClient');
    }
  }

  // ========== PLAN METHODS ==========

  /// Get all plans for current coach
  Future<List<Map<String, dynamic>>> getPlans() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('plans')
          .select()
          .eq('coach_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'getPlans');
    }
  }

  /// Get plan by ID
  Future<Map<String, dynamic>> getPlanById(String planId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('plans')
          .select()
          .eq('id', planId)
          .eq('coach_id', userId)
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'getPlanById');
    }
  }

  /// Add a new plan
  Future<Map<String, dynamic>> addPlan(Map<String, dynamic> planData) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final insertData = {
        ...planData,
        'coach_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('plans')
          .insert(insertData)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'addPlan');
    }
  }

  /// Update plan
  Future<Map<String, dynamic>> updatePlan(
    String planId,
    Map<String, dynamic> planData,
  ) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final response = await _client
          .from('plans')
          .update(planData)
          .eq('id', planId)
          .eq('coach_id', userId)
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw _handleSupabaseException(e, 'updatePlan');
    }
  }

  /// Delete plan
  Future<void> deletePlan(String planId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      await _client
          .from('plans')
          .delete()
          .eq('id', planId)
          .eq('coach_id', userId);
    } catch (e) {
      throw _handleSupabaseException(e, 'deletePlan');
    }
  }

  // ========== IMAGE UPLOAD ==========

  /// Upload image to Supabase Storage
  Future<String> uploadImage(File imageFile, {String? folder}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      final fileName =
          '${folder ?? 'profile'}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$userId/$fileName';

      await _client.storage.from('images').upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      final url = _client.storage.from('images').getPublicUrl(filePath);
      return url;
    } catch (e) {
      throw _handleSupabaseException(e, 'uploadImage');
    }
  }

  // ========== ANALYTICS ==========

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw AuthException.unauthorized();
      }

      // Get client count
      final clientsResponse = await _client
          .from('clients')
          .select('id')
          .eq('coach_id', userId);

      final clientCount = (clientsResponse as List).length;

      // Get plan count
      final plansResponse = await _client
          .from('plans')
          .select('id')
          .eq('coach_id', userId);

      final planCount = (plansResponse as List).length;

      // Get active clients
      final activeClientsResponse = await _client
          .from('clients')
          .select('id')
          .eq('coach_id', userId)
          .eq('status', 'active');

      final activeClientCount = (activeClientsResponse as List).length;

      return {
        'totalClients': clientCount,
        'activeClients': activeClientCount,
        'totalPlans': planCount,
        'totalRevenue': 0.0, // Calculate from plans if needed
      };
    } catch (e) {
      throw _handleSupabaseException(e, 'getDashboardStats');
    }
  }
}

