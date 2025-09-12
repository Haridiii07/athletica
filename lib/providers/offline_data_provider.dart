import 'package:flutter/material.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/models/coach.dart';

/// Provider for managing offline-first data operations
class OfflineDataProvider extends ChangeNotifier {
  List<Client> _clients = [];
  List<Plan> _plans = [];
  Coach? _coach;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Client> get clients => _clients;
  List<Plan> get plans => _plans;
  Coach? get coach => _coach;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize the provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Load mock data for now
      await _loadMockData();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize: $e');
      _setLoading(false);
    }
  }

  /// Load mock data
  Future<void> _loadMockData() async {
    try {
      // Mock coach data
      _coach = Coach(
        id: '1',
        name: 'John Trainer',
        email: 'john@trainer.com',
        phone: '+1234567890',
        bio: 'Certified fitness trainer with 5 years of experience',
        certificates: ['NASM-CPT', 'ACE-CPT'],
        subscriptionTier: 'pro',
        clientLimit: 50,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastActive: DateTime.now(),
      );

      // Mock clients data
      _clients = [
        Client(
          id: '1',
          coachId: '1',
          name: 'Alice Johnson',
          email: 'alice@email.com',
          phone: '+1234567891',
          status: 'active',
          subscriptionProgress: 0.75,
          joinedAt: DateTime.now().subtract(const Duration(days: 30)),
          lastSession: DateTime.now().subtract(const Duration(days: 2)),
          goals: {'primary': 'Weight Loss', 'secondary': 'Muscle Building'},
          stats: {
            'age': 28,
            'gender': 'Female',
            'fitnessLevel': 'Intermediate'
          },
        ),
        Client(
          id: '2',
          coachId: '1',
          name: 'Bob Smith',
          email: 'bob@email.com',
          phone: '+1234567892',
          status: 'active',
          subscriptionProgress: 0.45,
          joinedAt: DateTime.now().subtract(const Duration(days: 15)),
          lastSession: DateTime.now().subtract(const Duration(days: 1)),
          goals: {'primary': 'Weight Loss'},
          stats: {'age': 35, 'gender': 'Male', 'fitnessLevel': 'Beginner'},
        ),
      ];

      // Mock plans data
      _plans = [
        Plan(
          id: '1',
          coachId: '1',
          name: 'Weight Loss Program',
          description: 'Comprehensive weight loss program',
          duration: 84, // 12 weeks
          price: 299.99,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          status: 'active',
          clientCount: 5,
          successRate: 0.85,
          revenue: 1499.95,
        ),
        Plan(
          id: '2',
          coachId: '1',
          name: 'Muscle Building Plan',
          description: 'Intensive muscle building program',
          duration: 112, // 16 weeks
          price: 399.99,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          status: 'active',
          clientCount: 3,
          successRate: 0.92,
          revenue: 1199.97,
        ),
      ];

      notifyListeners();
    } catch (e) {
      _setError('Failed to load mock data: $e');
    }
  }

  // ========== CLIENT OPERATIONS ==========

  /// Add client
  Future<bool> addClient(Client client) async {
    try {
      _clients.add(client);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add client: $e');
      return false;
    }
  }

  /// Update client
  Future<bool> updateClient(Client client) async {
    try {
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = client;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update client: $e');
      return false;
    }
  }

  /// Delete client
  Future<bool> deleteClient(String clientId) async {
    try {
      _clients.removeWhere((c) => c.id == clientId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete client: $e');
      return false;
    }
  }

  /// Get client by ID
  Client? getClient(String clientId) {
    try {
      return _clients.firstWhere((c) => c.id == clientId);
    } catch (e) {
      return null;
    }
  }

  // ========== PLAN OPERATIONS ==========

  /// Add plan
  Future<bool> addPlan(Plan plan) async {
    try {
      _plans.add(plan);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add plan: $e');
      return false;
    }
  }

  /// Update plan
  Future<bool> updatePlan(Plan plan) async {
    try {
      final index = _plans.indexWhere((p) => p.id == plan.id);
      if (index != -1) {
        _plans[index] = plan;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update plan: $e');
      return false;
    }
  }

  /// Delete plan
  Future<bool> deletePlan(String planId) async {
    try {
      _plans.removeWhere((p) => p.id == planId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete plan: $e');
      return false;
    }
  }

  /// Get plan by ID
  Plan? getPlan(String planId) {
    try {
      return _plans.firstWhere((p) => p.id == planId);
    } catch (e) {
      return null;
    }
  }

  // ========== COACH OPERATIONS ==========

  /// Update coach
  Future<bool> updateCoach(Coach coach) async {
    try {
      _coach = coach;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update coach: $e');
      return false;
    }
  }

  // ========== UTILITY METHODS ==========

  /// Refresh data
  Future<void> refresh() async {
    await _loadMockData();
  }

  /// Clear all data
  Future<void> clearAllData() async {
    _clients.clear();
    _plans.clear();
    _coach = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
