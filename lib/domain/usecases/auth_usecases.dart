import 'package:athletica/data/models/coach.dart';
import 'package:athletica/domain/repositories/auth_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Use case for signing up a new coach
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Coach> call({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // Validate inputs
    if (email.isEmpty || !email.contains('@')) {
      throw ValidationException.invalidEmail();
    }
    if (password.length < 6) {
      throw ValidationException.weakPassword();
    }
    if (name.isEmpty) {
      throw ValidationException.requiredField('Name');
    }
    if (phone.isEmpty) {
      throw ValidationException.requiredField('Phone');
    }

    final response = await _repository.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    return Coach.fromJson(response['coach']);
  }
}

/// Use case for signing in
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Coach> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || !email.contains('@')) {
      throw ValidationException.invalidEmail();
    }
    if (password.isEmpty) {
      throw ValidationException.requiredField('Password');
    }

    final response = await _repository.signIn(
      email: email,
      password: password,
    );

    return Coach.fromJson(response['coach']);
  }
}

/// Use case for signing out
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() async {
    await _repository.signOut();
  }
}

/// Use case for getting coach profile
class GetCoachProfileUseCase {
  final AuthRepository _repository;

  GetCoachProfileUseCase(this._repository);

  Future<Coach> call() async {
    if (!_repository.isAuthenticated) {
      throw AuthException.unauthorized();
    }
    return await _repository.getCoachProfile();
  }
}

/// Use case for updating coach profile
class UpdateCoachProfileUseCase {
  final AuthRepository _repository;

  UpdateCoachProfileUseCase(this._repository);

  Future<Coach> call({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    if (!_repository.isAuthenticated) {
      throw AuthException.unauthorized();
    }
    return await _repository.updateCoachProfile(
      name: name,
      bio: bio,
      profilePhotoUrl: profilePhotoUrl,
    );
  }
}

