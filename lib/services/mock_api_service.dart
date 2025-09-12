import 'dart:io';
import 'package:athletica/models/coach.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/utils/exceptions.dart';
import 'package:athletica/config/app_config.dart';

/// Mock API Service for frontend testing without backend
/// This simulates all API responses for UI testing
class MockApiService {
  static MockApiService? _instance;
  static MockApiService get instance => _instance ??= MockApiService._();

  String? _authToken;
  bool _isAuthenticated = false;

  MockApiService._();

  // Simulate network delay (reduced for frontend testing)
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Mock authentication token
  Future<String?> get authToken async {
    await _simulateDelay();
    return _authToken;
  }

  Future<void> clearAuthToken() async {
    await _simulateDelay();
    _authToken = null;
    _isAuthenticated = false;
  }

  // Mock Sign Up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _simulateDelay();

    // Simulate validation errors
    if (email == 'test@error.com') {
      throw ValidationException.emailTaken();
    }

    if (password.length < 6) {
      throw ValidationException.weakPassword();
    }

    // Simulate successful signup
    _authToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;

    final coach = Coach(
      id: 'mock_coach_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      bio: 'Mock coach bio',
      certificates: ['Mock Certificate 1', 'Mock Certificate 2'],
      subscriptionTier: 'free',
      clientLimit: 3,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    return {
      'token': _authToken,
      'coach': coach.toJson(),
    };
  }

  // Mock Sign In
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    await _simulateDelay();

    // Simulate authentication errors
    if (email == 'wrong@email.com' || password == 'wrongpassword') {
      throw AuthException.invalidCredentials();
    }

    if (email == 'locked@email.com') {
      throw AuthException.accountLocked();
    }

    // Simulate successful signin
    _authToken = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;

    final coach = Coach(
      id: 'mock_coach_123',
      name: 'Mock Coach',
      email: email,
      phone: '+1234567890',
      bio: 'Experienced fitness trainer with 5+ years of experience',
      certificates: ['NASM-CPT', 'CrossFit Level 2', 'Yoga Instructor'],
      subscriptionTier: 'pro',
      clientLimit: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );

    return {
      'token': _authToken,
      'coach': coach.toJson(),
    };
  }

  // Mock Sign Out
  Future<void> signOut() async {
    await _simulateDelay();
    _authToken = null;
    _isAuthenticated = false;
  }

  // Mock Forgot Password
  Future<void> forgotPassword({required String email}) async {
    await _simulateDelay();

    if (email == 'notfound@email.com') {
      throw DataException.notFound('Email address');
    }

    // Simulate successful password reset email
    // In real app, this would send an email
  }

  // Mock Google Sign In
  Future<Map<String, dynamic>> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    await _simulateDelay();

    if (googleToken == 'invalid_token') {
      throw ExternalServiceException.googleSignIn();
    }

    _authToken = 'mock_google_token_${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;

    final coach = Coach(
      id: 'mock_google_coach_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Google User',
      email: email ?? 'user@gmail.com',
      phone: '+1234567890',
      profilePhotoUrl: profilePhotoUrl,
      bio: 'Google Sign-In User',
      certificates: [],
      subscriptionTier: 'free',
      clientLimit: 3,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    return {
      'token': _authToken,
      'coach': coach.toJson(),
    };
  }

  // Mock Facebook Sign In
  Future<Map<String, dynamic>> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    await _simulateDelay();

    if (facebookToken == 'invalid_token') {
      throw ExternalServiceException.facebookSignIn();
    }

    _authToken = 'mock_facebook_token_${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;

    final coach = Coach(
      id: 'mock_facebook_coach_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Facebook User',
      email: email ?? 'user@facebook.com',
      phone: '+1234567890',
      profilePhotoUrl: profilePhotoUrl,
      bio: 'Facebook Sign-In User',
      certificates: [],
      subscriptionTier: 'free',
      clientLimit: 3,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    return {
      'token': _authToken,
      'coach': coach.toJson(),
    };
  }

  // Mock Apple Sign In
  Future<Map<String, dynamic>> signInWithApple({
    required String appleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    await _simulateDelay();

    if (appleToken == 'invalid_token') {
      throw ExternalServiceException.appleSignIn();
    }

    _authToken = 'mock_apple_token_${DateTime.now().millisecondsSinceEpoch}';
    _isAuthenticated = true;

    final coach = Coach(
      id: 'mock_apple_coach_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Apple User',
      email: email ?? 'user@icloud.com',
      phone: '+1234567890',
      profilePhotoUrl: profilePhotoUrl,
      bio: 'Apple Sign-In User',
      certificates: [],
      subscriptionTier: 'free',
      clientLimit: 3,
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
    );

    return {
      'token': _authToken,
      'coach': coach.toJson(),
    };
  }

  // Mock Get Coach Profile
  Future<Coach> getCoachProfile() async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return Coach(
      id: 'mock_coach_123',
      name: 'Mock Coach',
      email: 'coach@example.com',
      phone: '+1234567890',
      bio: 'Experienced fitness trainer with 5+ years of experience',
      certificates: ['NASM-CPT', 'CrossFit Level 2', 'Yoga Instructor'],
      subscriptionTier: 'pro',
      clientLimit: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );
  }

  // Mock Update Coach Profile
  Future<Coach> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return Coach(
      id: 'mock_coach_123',
      name: name ?? 'Updated Coach',
      email: 'coach@example.com',
      phone: '+1234567890',
      bio: bio ?? 'Updated bio',
      profilePhotoUrl: profilePhotoUrl,
      certificates: ['NASM-CPT', 'CrossFit Level 2', 'Yoga Instructor'],
      subscriptionTier: 'pro',
      clientLimit: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
    );
  }

  // Mock Get Clients
  Future<List<Client>> getClients() async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return [
      Client(
        id: 'client_1',
        coachId: 'mock_coach_123',
        name: 'Ahmed Mohamed',
        status: 'active',
        subscriptionProgress: 0.75,
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
        lastSession: DateTime.now().subtract(const Duration(days: 2)),
        goals: {'weight_loss': '10kg', 'muscle_gain': '5kg'},
        stats: {'height': 175, 'weight': 80, 'age': 28},
        phone: '+201234567890',
        email: 'ahmed@example.com',
      ),
      Client(
        id: 'client_2',
        coachId: 'mock_coach_123',
        name: 'Fatma Hassan',
        status: 'active',
        subscriptionProgress: 0.50,
        joinedAt: DateTime.now().subtract(const Duration(days: 8)),
        lastSession: DateTime.now().subtract(const Duration(days: 1)),
        goals: {'fitness': 'general', 'strength': 'improve'},
        stats: {'height': 160, 'weight': 65, 'age': 25},
        phone: '+201234567891',
        email: 'fatma@example.com',
      ),
      Client(
        id: 'client_3',
        coachId: 'mock_coach_123',
        name: 'Omar Ali',
        status: 'pending',
        subscriptionProgress: 0.0,
        joinedAt: DateTime.now().subtract(const Duration(days: 2)),
        goals: {'weight_loss': '15kg'},
        stats: {'height': 180, 'weight': 95, 'age': 32},
        phone: '+201234567892',
        email: 'omar@example.com',
      ),
    ];
  }

  // Mock Get Plans
  Future<List<Plan>> getPlans() async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return [
      Plan(
        id: 'plan_1',
        coachId: 'mock_coach_123',
        name: 'Weight Loss Program',
        description: '12-week comprehensive weight loss program',
        duration: 84,
        price: 1500.0,
        features: [
          'Personal training',
          'Nutrition guidance',
          'Progress tracking'
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        status: 'active',
        clientCount: 5,
        successRate: 0.85,
        revenue: 7500.0,
      ),
      Plan(
        id: 'plan_2',
        coachId: 'mock_coach_123',
        name: 'Muscle Building',
        description: '8-week muscle building program',
        duration: 56,
        price: 2000.0,
        features: [
          'Strength training',
          'Supplement advice',
          'Weekly check-ins'
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        status: 'active',
        clientCount: 3,
        successRate: 0.90,
        revenue: 6000.0,
      ),
    ];
  }

  // Mock Dashboard Stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return {
      'totalClients': 12,
      'activeClients': 8,
      'pendingClients': 4,
      'totalRevenue': 15000.0,
      'monthlyRevenue': 5000.0,
      'averageProgress': 0.65,
      'totalPlans': 5,
      'activePlans': 3,
    };
  }

  // Mock Add Client
  Future<Client> addClient(Client client) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return client.copyWith(
      id: 'client_${DateTime.now().millisecondsSinceEpoch}',
      joinedAt: DateTime.now(),
    );
  }

  // Mock Update Client
  Future<Client> updateClient(Client client) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return client;
  }

  // Mock Delete Client
  Future<void> deleteClient(String clientId) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    // Simulate successful deletion
  }

  // Mock Add Plan
  Future<Plan> addPlan(Plan plan) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return plan.copyWith(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
  }

  // Mock Update Plan
  Future<Plan> updatePlan(Plan plan) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    return plan;
  }

  // Mock Delete Plan
  Future<void> deletePlan(String planId) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    // Simulate successful deletion
  }

  // Mock Image Upload
  Future<String> uploadImage(File imageFile) async {
    await _simulateDelay();

    if (!_isAuthenticated) {
      throw AuthException.tokenExpired();
    }

    // Simulate file size validation
    final fileSize = await imageFile.length();
    if (fileSize > AppConfig.maxImageSize) {
      throw ValidationException(
        message:
            'Image file is too large. Maximum size is ${AppConfig.maxImageSize ~/ (1024 * 1024)}MB.',
        code: 'FILE_TOO_LARGE',
      );
    }

    // Simulate image format validation
    final fileName = imageFile.path.toLowerCase();
    final isValidFormat = AppConfig.allowedImageTypes.any(
      (ext) => fileName.endsWith('.$ext'),
    );

    if (!isValidFormat) {
      throw ValidationException(
        message:
            'Invalid image format. Allowed formats: ${AppConfig.allowedImageTypes.join(', ')}',
        code: 'INVALID_FORMAT',
      );
    }

    // Simulate successful upload and return mock URL
    return 'https://mock-cdn.athletica.com/profile_photos/mock_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
