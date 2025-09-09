import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athletica/config/app_config.dart';
import 'package:athletica/models/coach.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';
import 'package:athletica/utils/exceptions.dart';

class ApiService {
  static const String authTokenKey = 'auth_token';

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  late final Dio _dio;
  String? _authToken;

  ApiService._() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token to requests if available
        final token = await authToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle common errors
        if (error.response?.statusCode == 401) {
          // Clear invalid token
          clearAuthToken();
        }
        handler.next(error);
      },
    ));
  }

  /// Helper method to handle DioExceptions and convert them to custom exceptions
  AppException _handleDioException(DioException e, [String? endpoint]) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException.timeout();
    }
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException.noConnection();
    }
    if (e.response != null) {
      return ExceptionMapper.mapFromResponse(
        e.response!.statusCode ?? 500,
        e.response!.data,
        endpoint: endpoint,
      );
    }
    return NetworkException(
      message:
          'Network error occurred. Please check your connection and try again.',
      code: 'NETWORK_ERROR',
      details: e.message,
    );
  }

  Future<String?> get authToken async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(authTokenKey);
    return _authToken;
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authTokenKey);
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.authSignUp,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await setAuthToken(data['token']);
      return data;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.authSignUp);
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.authSignIn,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      await setAuthToken(data['token']);
      return data;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.authSignIn);
    }
  }

  Future<void> signOut() async {
    try {
      await _dio.post(AppConfig.authSignOut);
    } on DioException {
      // Log the error but continue with token cleanup
      // Don't throw here as we want to clear the token regardless
    } finally {
      await clearAuthToken();
    }
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _dio.post(
        AppConfig.authForgotPassword,
        data: {'email': email},
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.authForgotPassword);
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle({
    required String googleToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.authGoogleSignIn,
        data: {
          'googleToken': googleToken,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await setAuthToken(data['token']);
      return data;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.authGoogleSignIn);
    }
  }

  Future<Map<String, dynamic>> signInWithFacebook({
    required String facebookToken,
    String? name,
    String? email,
    String? profilePhotoUrl,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.authFacebookSignIn,
        data: {
          'facebookToken': facebookToken,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
        },
      );

      final data = response.data as Map<String, dynamic>;
      await setAuthToken(data['token']);
      return data;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.authFacebookSignIn);
    }
  }

  // Coach endpoints
  Future<Coach> getCoachProfile() async {
    try {
      final response = await _dio.get(AppConfig.coachProfile);
      return Coach.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.coachProfile);
    }
  }

  Future<Coach> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      final response = await _dio.put(
        AppConfig.coachProfile,
        data: {
          if (name != null) 'name': name,
          if (bio != null) 'bio': bio,
          if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
        },
      );

      return Coach.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.coachProfile);
    }
  }

  // Client endpoints
  Future<List<Client>> getClients() async {
    try {
      final response = await _dio.get(AppConfig.clients);
      final data = response.data as List;
      return data
          .map((json) => Client.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.clients);
    }
  }

  Future<Client> addClient(Client client) async {
    try {
      final response = await _dio.post(
        AppConfig.clients,
        data: client.toJson(),
      );

      return Client.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.clients);
    }
  }

  Future<Client> updateClient(Client client) async {
    try {
      final response = await _dio.put(
        '${AppConfig.clients}/${client.id}',
        data: client.toJson(),
      );

      return Client.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, '${AppConfig.clients}/${client.id}');
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      await _dio.delete('${AppConfig.clients}/$clientId');
    } on DioException catch (e) {
      // For delete operations, 204 No Content is expected
      if (e.response?.statusCode != 204) {
        throw _handleDioException(e, '${AppConfig.clients}/$clientId');
      }
    }
  }

  // Plan endpoints
  Future<List<Plan>> getPlans() async {
    try {
      final response = await _dio.get(AppConfig.plans);
      final data = response.data as List;
      return data
          .map((json) => Plan.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.plans);
    }
  }

  Future<Plan> addPlan(Plan plan) async {
    try {
      final response = await _dio.post(
        AppConfig.plans,
        data: plan.toJson(),
      );

      return Plan.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.plans);
    }
  }

  Future<Plan> updatePlan(Plan plan) async {
    try {
      final response = await _dio.put(
        '${AppConfig.plans}/${plan.id}',
        data: plan.toJson(),
      );

      return Plan.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e, '${AppConfig.plans}/${plan.id}');
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _dio.delete('${AppConfig.plans}/$planId');
    } on DioException catch (e) {
      // For delete operations, 204 No Content is expected
      if (e.response?.statusCode != 204) {
        throw _handleDioException(e, '${AppConfig.plans}/$planId');
      }
    }
  }

  // Analytics endpoints
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get(AppConfig.analytics);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, AppConfig.analytics);
    }
  }
}
