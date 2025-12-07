import 'package:athletica/data/models/plan.dart';
import 'package:athletica/domain/repositories/plan_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Use case for getting all plans
class GetPlansUseCase {
  final PlanRepository _repository;

  GetPlansUseCase(this._repository);

  Future<List<Plan>> call() async {
    return await _repository.getPlans();
  }
}

/// Use case for getting a plan by ID
class GetPlanByIdUseCase {
  final PlanRepository _repository;

  GetPlanByIdUseCase(this._repository);

  Future<Plan> call(String planId) async {
    if (planId.isEmpty) {
      throw ValidationException.requiredField('Plan ID');
    }
    return await _repository.getPlanById(planId);
  }
}

/// Use case for adding a new plan
class AddPlanUseCase {
  final PlanRepository _repository;

  AddPlanUseCase(this._repository);

  Future<Plan> call(Plan plan) async {
    // Validate plan data
    if (plan.name.isEmpty) {
      throw ValidationException.requiredField('Plan Name');
    }
    if (plan.duration <= 0) {
      throw ValidationException(
        message: 'Duration must be greater than 0',
        code: 'INVALID_DURATION',
      );
    }
    if (plan.price < 0) {
      throw ValidationException(
        message: 'Price cannot be negative',
        code: 'INVALID_PRICE',
      );
    }

    return await _repository.addPlan(plan);
  }
}

/// Use case for updating a plan
class UpdatePlanUseCase {
  final PlanRepository _repository;

  UpdatePlanUseCase(this._repository);

  Future<Plan> call(Plan plan) async {
    if (plan.id.isEmpty) {
      throw ValidationException.requiredField('Plan ID');
    }
    if (plan.name.isEmpty) {
      throw ValidationException.requiredField('Plan Name');
    }

    return await _repository.updatePlan(plan);
  }
}

/// Use case for deleting a plan
class DeletePlanUseCase {
  final PlanRepository _repository;

  DeletePlanUseCase(this._repository);

  Future<void> call(String planId) async {
    if (planId.isEmpty) {
      throw ValidationException.requiredField('Plan ID');
    }
    await _repository.deletePlan(planId);
  }
}

