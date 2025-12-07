import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athletica/data/datasources/supabase_service.dart';
import 'package:athletica/data/repositories/auth_repository_impl.dart';
import 'package:athletica/data/models/coach.dart';
import 'package:athletica/domain/usecases/auth_usecases.dart';

/// Provider for Supabase service
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return AuthRepositoryImpl(supabaseService);
});

/// Provider for auth use cases
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

final getCoachProfileUseCaseProvider = Provider<GetCoachProfileUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCoachProfileUseCase(repository);
});

final updateCoachProfileUseCaseProvider = Provider<UpdateCoachProfileUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateCoachProfileUseCase(repository);
});

/// Provider for current coach profile
final currentCoachProvider = FutureProvider<Coach?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  if (!repository.isAuthenticated) {
    return null;
  }
  try {
    final useCase = ref.watch(getCoachProfileUseCaseProvider);
    return await useCase.call();
  } catch (e) {
    return null;
  }
});

/// Provider for authentication state
final authStateProvider = StreamProvider<bool>((ref) async* {
  final supabaseService = ref.watch(supabaseServiceProvider);
  
  // Initial state
  yield supabaseService.currentUser != null;
  
  // Listen to auth state changes
  supabaseService.client.auth.onAuthStateChange.listen((data) {
    ref.invalidate(currentCoachProvider);
  });
  
  // Stream auth state
  yield* supabaseService.client.auth.onAuthStateChange.map((data) {
    return data.session != null;
  });
});

/// Provider for sign up
final signUpProvider = FutureProvider.family<Coach, SignUpParams>((ref, params) async {
  final useCase = ref.watch(signUpUseCaseProvider);
  return await useCase.call(
    email: params.email,
    password: params.password,
    name: params.name,
    phone: params.phone,
  );
});

/// Provider for sign in
final signInProvider = FutureProvider.family<Coach, SignInParams>((ref, params) async {
  final useCase = ref.watch(signInUseCaseProvider);
  return await useCase.call(
    email: params.email,
    password: params.password,
  );
});

/// Parameters for sign up
class SignUpParams {
  final String email;
  final String password;
  final String name;
  final String phone;

  SignUpParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}

/// Parameters for sign in
class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}

