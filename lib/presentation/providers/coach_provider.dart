import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athletica/presentation/providers/auth_provider.dart';
import 'package:athletica/data/repositories/client_repository_impl.dart';
import 'package:athletica/data/repositories/plan_repository_impl.dart';
import 'package:athletica/data/models/client.dart';
import 'package:athletica/data/models/plan.dart';
import 'package:athletica/domain/usecases/client_usecases.dart';
import 'package:athletica/domain/usecases/plan_usecases.dart';

/// Provider for client repository
final clientRepositoryProvider = Provider<ClientRepositoryImpl>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return ClientRepositoryImpl(supabaseService);
});

/// Provider for plan repository
final planRepositoryProvider = Provider<PlanRepositoryImpl>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return PlanRepositoryImpl(supabaseService);
});

/// Provider for client use cases
final getClientsUseCaseProvider = Provider<GetClientsUseCase>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return GetClientsUseCase(repository);
});

final getClientByIdUseCaseProvider = Provider<GetClientByIdUseCase>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return GetClientByIdUseCase(repository);
});

final addClientUseCaseProvider = Provider<AddClientUseCase>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return AddClientUseCase(repository);
});

final updateClientUseCaseProvider = Provider<UpdateClientUseCase>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return UpdateClientUseCase(repository);
});

final deleteClientUseCaseProvider = Provider<DeleteClientUseCase>((ref) {
  final repository = ref.watch(clientRepositoryProvider);
  return DeleteClientUseCase(repository);
});

/// Provider for plan use cases
final getPlansUseCaseProvider = Provider<GetPlansUseCase>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return GetPlansUseCase(repository);
});

final getPlanByIdUseCaseProvider = Provider<GetPlanByIdUseCase>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return GetPlanByIdUseCase(repository);
});

final addPlanUseCaseProvider = Provider<AddPlanUseCase>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return AddPlanUseCase(repository);
});

final updatePlanUseCaseProvider = Provider<UpdatePlanUseCase>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return UpdatePlanUseCase(repository);
});

final deletePlanUseCaseProvider = Provider<DeletePlanUseCase>((ref) {
  final repository = ref.watch(planRepositoryProvider);
  return DeletePlanUseCase(repository);
});

/// Provider for all clients
final clientsProvider = FutureProvider<List<Client>>((ref) async {
  final useCase = ref.watch(getClientsUseCaseProvider);
  return await useCase.call();
});

/// Provider for a specific client by ID
final clientDetailsProvider = FutureProvider.family<Client, String>((ref, clientId) async {
  final useCase = ref.watch(getClientByIdUseCaseProvider);
  return await useCase.call(clientId);
});

/// Provider for all plans
final plansProvider = FutureProvider<List<Plan>>((ref) async {
  final useCase = ref.watch(getPlansUseCaseProvider);
  return await useCase.call();
});

/// Provider for a specific plan by ID
final planDetailsProvider = FutureProvider.family<Plan, String>((ref, planId) async {
  final useCase = ref.watch(getPlanByIdUseCaseProvider);
  return await useCase.call(planId);
});

class CoachDashboardState {
  final List<Client> clients;
  final List<Plan> plans;
  final bool isLoading;

  CoachDashboardState({
    this.clients = const [],
    this.plans = const [],
    this.isLoading = false,
  });

  int get totalClients => clients.length;
  int get activeClients => clients.where((c) => c.status == 'active').length;
  int get pendingClients => clients.where((c) => c.status == 'pending').length;
  int get totalPlans => plans.length;
  double get averageSubscriptionProgress => 0.0; // Placeholder logic
  double get totalRevenue => 0.0; // Placeholder logic

  CoachDashboardState copyWith({
    List<Client>? clients,
    List<Plan>? plans,
    bool? isLoading,
  }) {
    return CoachDashboardState(
      clients: clients ?? this.clients,
      plans: plans ?? this.plans,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CoachDashboardNotifier extends StateNotifier<CoachDashboardState> {
  final Ref ref;

  CoachDashboardNotifier(this.ref) : super(CoachDashboardState());

  Future<void> loadClients() async {
    state = state.copyWith(isLoading: true);
    try {
      final clients = await ref.read(getClientsUseCaseProvider).call();
      state = state.copyWith(clients: clients, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true);
    try {
      final plans = await ref.read(getPlansUseCaseProvider).call();
      state = state.copyWith(plans: plans, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final coachProvider = StateNotifierProvider<CoachDashboardNotifier, CoachDashboardState>((ref) {
  return CoachDashboardNotifier(ref);
});

