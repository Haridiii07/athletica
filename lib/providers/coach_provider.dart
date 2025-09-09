import 'package:flutter/material.dart';
import 'package:athletica/services/api_service.dart';
import 'package:athletica/services/mock_api_service.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/config/app_config.dart';

class CoachProvider extends ChangeNotifier {
  final dynamic _apiService =
      AppConfig.useMockApi ? MockApiService.instance : ApiService.instance;

  List<Client> _clients = [];
  List<Plan> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<Client> get clients => _clients;
  List<Plan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Client statistics
  int get totalClients => _clients.length;
  int get activeClients => _clients.where((client) => client.isActive).length;
  int get pendingClients => _clients.where((client) => client.isPending).length;
  double get averageSubscriptionProgress {
    if (_clients.isEmpty) return 0.0;
    final total =
        _clients.fold(0.0, (sum, client) => sum + client.subscriptionProgress);
    return total / _clients.length;
  }

  // Plan statistics
  int get totalPlans => _plans.length;
  int get activePlans => _plans.where((plan) => plan.isActive).length;
  double get totalRevenue {
    return _plans.fold(0.0, (sum, plan) => sum + plan.revenue);
  }

  Future<void> loadClients() async {
    _setLoading(true);
    _error = null;

    try {
      _clients = await _apiService.getClients();
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load clients: $e';
      _setLoading(false);
    }
  }

  Future<void> loadPlans() async {
    _setLoading(true);
    _error = null;

    try {
      _plans = await _apiService.getPlans();
      _setLoading(false);
    } catch (e) {
      _error = 'Failed to load plans: $e';
      _setLoading(false);
    }
  }

  Future<bool> addClient(Client client) async {
    try {
      final newClient = await _apiService.addClient(client);
      _clients.insert(0, newClient);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add client: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateClient(Client client) async {
    try {
      final updatedClient = await _apiService.updateClient(client);
      final index = _clients.indexWhere((c) => c.id == client.id);
      if (index != -1) {
        _clients[index] = updatedClient;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Failed to update client: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteClient(String clientId) async {
    try {
      await _apiService.deleteClient(clientId);
      _clients.removeWhere((client) => client.id == clientId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete client: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> addPlan(Plan plan) async {
    try {
      final newPlan = await _apiService.addPlan(plan);
      _plans.insert(0, newPlan);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add plan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> createPlan(Plan plan) async {
    // Alias for addPlan for compatibility
    return await addPlan(plan);
  }

  Future<bool> updatePlan(Plan plan) async {
    try {
      final updatedPlan = await _apiService.updatePlan(plan);
      final index = _plans.indexWhere((p) => p.id == plan.id);
      if (index != -1) {
        _plans[index] = updatedPlan;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Failed to update plan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePlan(String planId) async {
    try {
      await _apiService.deletePlan(planId);
      _plans.removeWhere((plan) => plan.id == planId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete plan: $e';
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

  void clearData() {
    _clients.clear();
    _plans.clear();
    notifyListeners();
  }
}
