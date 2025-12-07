import 'package:athletica/data/datasources/supabase_service.dart';
import 'package:athletica/data/models/plan.dart';
import 'package:athletica/domain/repositories/plan_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Implementation of PlanRepository using Supabase
class PlanRepositoryImpl implements PlanRepository {
  final SupabaseService _supabaseService;

  PlanRepositoryImpl(this._supabaseService);

  @override
  Future<List<Plan>> getPlans() async {
    try {
      final data = await _supabaseService.getPlans();
      return data.map((json) => Plan.fromJson(_transformSupabaseData(json))).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to get plans: ${e.toString()}',
        code: 'GET_PLANS_ERROR',
      );
    }
  }

  @override
  Future<Plan> getPlanById(String planId) async {
    try {
      final data = await _supabaseService.getPlanById(planId);
      return Plan.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to get plan: ${e.toString()}',
        code: 'GET_PLAN_ERROR',
      );
    }
  }

  @override
  Future<Plan> addPlan(Plan plan) async {
    try {
      final data = await _supabaseService.addPlan(_transformToSupabaseData(plan.toJson()));
      return Plan.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to add plan: ${e.toString()}',
        code: 'ADD_PLAN_ERROR',
      );
    }
  }

  @override
  Future<Plan> updatePlan(Plan plan) async {
    try {
      final data = await _supabaseService.updatePlan(
        plan.id,
        _transformToSupabaseData(plan.toJson()),
      );
      return Plan.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to update plan: ${e.toString()}',
        code: 'UPDATE_PLAN_ERROR',
      );
    }
  }

  @override
  Future<void> deletePlan(String planId) async {
    try {
      await _supabaseService.deletePlan(planId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to delete plan: ${e.toString()}',
        code: 'DELETE_PLAN_ERROR',
      );
    }
  }

  /// Transform Supabase snake_case data to camelCase for models
  Map<String, dynamic> _transformSupabaseData(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'coachId': data['coach_id'],
      'name': data['name'],
      'description': data['description'] ?? '',
      'imageUrl': data['image_url'],
      'duration': data['duration'] ?? 0,
      'price': (data['price'] ?? 0.0).toDouble(),
      'features': data['features'] ?? [],
      'createdAt': data['created_at'] ?? DateTime.now().toIso8601String(),
      'expiresAt': data['expires_at'],
      'status': data['status'] ?? 'active',
      'clientCount': data['client_count'] ?? 0,
      'successRate': (data['success_rate'] ?? 0.0).toDouble(),
      'revenue': (data['revenue'] ?? 0.0).toDouble(),
    };
  }

  /// Transform camelCase data to Supabase snake_case
  Map<String, dynamic> _transformToSupabaseData(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'name': data['name'],
      'description': data['description'],
      'image_url': data['imageUrl'],
      'duration': data['duration'],
      'price': data['price'],
      'features': data['features'],
      'expires_at': data['expiresAt'],
      'status': data['status'],
      'client_count': data['clientCount'],
      'success_rate': data['successRate'],
      'revenue': data['revenue'],
    };
  }
}

