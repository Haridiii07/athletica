import 'package:flutter_test/flutter_test.dart';
import 'package:athletica/providers/auth_provider.dart';
import 'package:athletica/providers/coach_provider.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/models/coach.dart';
import 'package:athletica/utils/exceptions.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    tearDown(() {
      authProvider.dispose();
    });

    test('should initialize with unauthenticated state', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.coach, null);
      expect(authProvider.isLoading, false);
      expect(authProvider.error, null);
    });

    test('should handle successful sign in', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result =
          await authProvider.signIn(email: email, password: password);

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.coach, isNotNull);
      expect(authProvider.error, null);
    });

    test('should handle sign in failure', () async {
      // Arrange
      const email = 'invalid@example.com';
      const password = 'wrongpassword';

      // Act
      final result =
          await authProvider.signIn(email: email, password: password);

      // Assert
      expect(result, false);
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.error, isNotNull);
    });

    test('should handle sign out', () async {
      // Arrange
      await authProvider.signIn(
          email: 'test@example.com', password: 'password123');
      expect(authProvider.isAuthenticated, true);

      // Act
      authProvider.signOut();

      // Assert
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.coach, null);
    });

    test('should handle Google sign in', () async {
      // Act
      final result = await authProvider.signInWithGoogle(
        googleToken: 'mock_google_token',
        name: 'Google User',
        email: 'user@gmail.com',
      );

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.coach, isNotNull);
    });

    test('should handle Facebook sign in', () async {
      // Act
      final result = await authProvider.signInWithFacebook(
        facebookToken: 'mock_facebook_token',
        name: 'Facebook User',
        email: 'user@facebook.com',
      );

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.coach, isNotNull);
    });

    test('should handle Apple sign in', () async {
      // Act
      final result = await authProvider.signInWithApple(
        appleToken: 'mock_apple_token',
        name: 'Apple User',
        email: 'user@apple.com',
      );

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.coach, isNotNull);
    });
  });

  group('CoachProvider Tests', () {
    late CoachProvider coachProvider;

    setUp(() {
      coachProvider = CoachProvider();
    });

    tearDown(() {
      coachProvider.dispose();
    });

    test('should initialize with empty data', () {
      expect(coachProvider.clients, isEmpty);
      expect(coachProvider.plans, isEmpty);
      expect(coachProvider.isLoading, false);
    });

    test('should load clients successfully', () async {
      // Act
      await coachProvider.loadClients();

      // Assert
      expect(coachProvider.clients, isNotEmpty);
      expect(coachProvider.isLoading, false);
    });

    test('should load plans successfully', () async {
      // Act
      await coachProvider.loadPlans();

      // Assert
      expect(coachProvider.plans, isNotEmpty);
      expect(coachProvider.isLoading, false);
    });

    test('should add client', () {
      // Arrange
      final client = Client(
        id: 'test_client',
        coachId: 'coach1',
        name: 'Test Client',
        joinedAt: DateTime.now(),
      );

      // Act
      coachProvider.addClient(client);

      // Assert
      expect(coachProvider.clients.length, 1);
      expect(coachProvider.clients.first.id, 'test_client');
    });

    test('should update client', () {
      // Arrange
      final client = Client(
        id: 'test_client',
        coachId: 'coach1',
        name: 'Test Client',
        joinedAt: DateTime.now(),
      );
      coachProvider.addClient(client);

      final updatedClient = client.copyWith(name: 'Updated Client');

      // Act
      coachProvider.updateClient(updatedClient);

      // Assert
      expect(coachProvider.clients.first.name, 'Updated Client');
    });

    test('should delete client', () {
      // Arrange
      final client = Client(
        id: 'test_client',
        coachId: 'coach1',
        name: 'Test Client',
        joinedAt: DateTime.now(),
      );
      coachProvider.addClient(client);
      expect(coachProvider.clients.length, 1);

      // Act
      coachProvider.deleteClient('test_client');

      // Assert
      expect(coachProvider.clients, isEmpty);
    });

    test('should add plan', () {
      // Arrange
      final plan = Plan(
        id: 'test_plan',
        coachId: 'coach1',
        name: 'Test Plan',
        description: 'Test Description',
        duration: 4,
        price: 99.99,
        features: ['Feature 1', 'Feature 2'],
        status: 'active',
        createdAt: DateTime.now(),
      );

      // Act
      coachProvider.addPlan(plan);

      // Assert
      expect(coachProvider.plans.length, 1);
      expect(coachProvider.plans.first.id, 'test_plan');
    });

    test('should get client plans', () {
      // Arrange
      final plan = Plan(
        id: 'test_plan',
        coachId: 'coach1',
        name: 'Test Plan',
        description: 'Test Description',
        duration: 4,
        price: 99.99,
        features: ['Feature 1'],
        status: 'active',
        createdAt: DateTime.now(),
      );
      coachProvider.addPlan(plan);

      // Act
      final clientPlans = coachProvider.getClientPlans('client1');

      // Assert
      expect(clientPlans, isNotEmpty);
      expect(clientPlans.first.id, 'test_plan');
    });
  });

  group('Exception Tests', () {
    test('should create AuthException with correct properties', () {
      // Act
      final exception = AuthException.invalidCredentials();

      // Assert
      expect(exception.message, 'Invalid email or password');
      expect(exception.code, 'INVALID_CREDENTIALS');
    });

    test('should create ValidationException with correct properties', () {
      // Act
      const exception = ValidationException(
        message: 'Email is required',
        code: 'EMAIL_REQUIRED',
      );

      // Assert
      expect(exception.message, 'Email is required');
      expect(exception.code, 'EMAIL_REQUIRED');
    });

    test('should create NetworkException with correct properties', () {
      // Act
      final exception = NetworkException.noConnection();

      // Assert
      expect(exception.message, 'No internet connection');
      expect(exception.code, 'NO_CONNECTION');
    });

    test('should create ExternalServiceException with correct properties', () {
      // Act
      final exception = ExternalServiceException.googleSignIn();

      // Assert
      expect(exception.message, 'Google Sign-In is currently unavailable');
      expect(exception.service, 'Google Sign-In');
      expect(exception.code, 'GOOGLE_SIGNIN_ERROR');
    });
  });

  group('Model Tests', () {
    test('should create Client with correct properties', () {
      // Arrange
      final now = DateTime.now();
      final client = Client(
        id: 'client1',
        coachId: 'coach1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        status: 'active',
        subscriptionProgress: 0.5,
        joinedAt: now,
        lastSession: now,
        goals: {'weight': '70kg'},
        stats: {'age': 25},
        sessionHistory: [],
      );

      // Assert
      expect(client.id, 'client1');
      expect(client.name, 'John Doe');
      expect(client.email, 'john@example.com');
      expect(client.status, 'active');
      expect(client.subscriptionProgress, 0.5);
    });

    test('should serialize and deserialize Client', () {
      // Arrange
      final client = Client(
        id: 'client1',
        coachId: 'coach1',
        name: 'John Doe',
        joinedAt: DateTime.now(),
      );

      // Act
      final json = client.toJson();
      final deserializedClient = Client.fromJson(json);

      // Assert
      expect(deserializedClient.id, client.id);
      expect(deserializedClient.name, client.name);
      expect(deserializedClient.coachId, client.coachId);
    });

    test('should create Plan with correct properties', () {
      // Arrange
      final plan = Plan(
        id: 'plan1',
        coachId: 'coach1',
        name: 'Beginner Plan',
        description: 'A plan for beginners',
        duration: 4,
        price: 99.99,
        features: ['Feature 1', 'Feature 2'],
        status: 'active',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(plan.id, 'plan1');
      expect(plan.name, 'Beginner Plan');
      expect(plan.duration, 4);
      expect(plan.features.length, 2);
      expect(plan.status, 'active');
    });

    test('should serialize and deserialize Plan', () {
      // Arrange
      final plan = Plan(
        id: 'plan1',
        coachId: 'coach1',
        name: 'Beginner Plan',
        description: 'A plan for beginners',
        duration: 4,
        price: 99.99,
        features: ['Feature 1'],
        status: 'active',
        createdAt: DateTime.now(),
      );

      // Act
      final json = plan.toJson();
      final deserializedPlan = Plan.fromJson(json);

      // Assert
      expect(deserializedPlan.id, plan.id);
      expect(deserializedPlan.name, plan.name);
      expect(deserializedPlan.duration, plan.duration);
    });

    test('should create Coach with correct properties', () {
      // Arrange
      final coach = Coach(
        id: 'coach1',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1234567890',
        bio: 'Professional trainer',
        certificates: ['Cert 1', 'Cert 2'],
        subscriptionTier: 'premium',
        clientLimit: 50,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      // Assert
      expect(coach.id, 'coach1');
      expect(coach.name, 'Jane Smith');
      expect(coach.email, 'jane@example.com');
      expect(coach.subscriptionTier, 'premium');
      expect(coach.clientLimit, 50);
    });

    test('should serialize and deserialize Coach', () {
      // Arrange
      final coach = Coach(
        id: 'coach1',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '+1234567890',
        bio: 'Professional trainer',
        certificates: ['Cert 1'],
        subscriptionTier: 'premium',
        clientLimit: 50,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      // Act
      final json = coach.toJson();
      final deserializedCoach = Coach.fromJson(json);

      // Assert
      expect(deserializedCoach.id, coach.id);
      expect(deserializedCoach.name, coach.name);
      expect(deserializedCoach.email, coach.email);
      expect(deserializedCoach.subscriptionTier, coach.subscriptionTier);
    });
  });
}
