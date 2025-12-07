import 'package:athletica/data/models/plan.dart';

/// Abstract repository interface for plan operations
abstract class PlanRepository {
  Future<List<Plan>> getPlans();
  Future<Plan> getPlanById(String planId);
  Future<Plan> addPlan(Plan plan);
  Future<Plan> updatePlan(Plan plan);
  Future<void> deletePlan(String planId);
}

