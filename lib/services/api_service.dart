import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:athletica/config/app_config.dart';
import 'package:athletica/models/coach.dart';
import 'package:athletica/models/client.dart';
import 'package:athletica/models/plan.dart';

class ApiService {
  static const String authTokenKey = 'auth_token';
  
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  
  ApiService._();
  
  String? _authToken;
  
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
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  Map<String, String> get _authHeaders async {
    final token = await authToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // Authentication endpoints
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.authSignUp}'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await setAuthToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Sign up failed');
    }
  }
  
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.authSignIn}'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setAuthToken(data['token']);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Sign in failed');
    }
  }
  
  Future<void> signOut() async {
    try {
      final headers = await _authHeaders;
      await http.post(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.authSignOut}'),
        headers: headers,
      );
    } finally {
      await clearAuthToken();
    }
  }
  
  // Coach endpoints
  Future<Coach> getCoachProfile() async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.coachProfile}'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Coach.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load profile');
    }
  }
  
  Future<Coach> updateCoachProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    final headers = await _authHeaders;
    final response = await http.put(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.coachProfile}'),
      headers: headers,
      body: jsonEncode({
        if (name != null) 'name': name,
        if (bio != null) 'bio': bio,
        if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Coach.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update profile');
    }
  }
  
  // Client endpoints
  Future<List<Client>> getClients() async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.clients}'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((json) => Client.fromJson(json)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load clients');
    }
  }
  
  Future<Client> addClient(Client client) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.clients}'),
      headers: headers,
      body: jsonEncode(client.toJson()),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Client.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to add client');
    }
  }
  
  Future<Client> updateClient(Client client) async {
    final headers = await _authHeaders;
    final response = await http.put(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.clients}/${client.id}'),
      headers: headers,
      body: jsonEncode(client.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Client.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update client');
    }
  }
  
  Future<void> deleteClient(String clientId) async {
    final headers = await _authHeaders;
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.clients}/$clientId'),
      headers: headers,
    );
    
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to delete client');
    }
  }
  
  // Plan endpoints
  Future<List<Plan>> getPlans() async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.plans}'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List).map((json) => Plan.fromJson(json)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load plans');
    }
  }
  
  Future<Plan> addPlan(Plan plan) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.plans}'),
      headers: headers,
      body: jsonEncode(plan.toJson()),
    );
    
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Plan.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to add plan');
    }
  }
  
  Future<Plan> updatePlan(Plan plan) async {
    final headers = await _authHeaders;
    final response = await http.put(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.plans}/${plan.id}'),
      headers: headers,
      body: jsonEncode(plan.toJson()),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Plan.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update plan');
    }
  }
  
  Future<void> deletePlan(String planId) async {
    final headers = await _authHeaders;
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.plans}/$planId'),
      headers: headers,
    );
    
    if (response.statusCode != 204) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to delete plan');
    }
  }
  
  // Analytics endpoints
  Future<Map<String, dynamic>> getDashboardStats() async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}${AppConfig.analytics}'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load dashboard stats');
    }
  }
}
