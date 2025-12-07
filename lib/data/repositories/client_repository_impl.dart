import 'package:athletica/data/datasources/supabase_service.dart';
import 'package:athletica/data/models/client.dart';
import 'package:athletica/domain/repositories/client_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Implementation of ClientRepository using Supabase
class ClientRepositoryImpl implements ClientRepository {
  final SupabaseService _supabaseService;

  ClientRepositoryImpl(this._supabaseService);

  @override
  Future<List<Client>> getClients() async {
    try {
      final data = await _supabaseService.getClients();
      return data.map((json) => Client.fromJson(_transformSupabaseData(json))).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to get clients: ${e.toString()}',
        code: 'GET_CLIENTS_ERROR',
      );
    }
  }

  @override
  Future<Client> getClientById(String clientId) async {
    try {
      final data = await _supabaseService.getClientById(clientId);
      return Client.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to get client: ${e.toString()}',
        code: 'GET_CLIENT_ERROR',
      );
    }
  }

  @override
  Future<Client> addClient(Client client) async {
    try {
      final data = await _supabaseService.addClient(_transformToSupabaseData(client.toJson()));
      return Client.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to add client: ${e.toString()}',
        code: 'ADD_CLIENT_ERROR',
      );
    }
  }

  @override
  Future<Client> updateClient(Client client) async {
    try {
      final data = await _supabaseService.updateClient(
        client.id,
        _transformToSupabaseData(client.toJson()),
      );
      return Client.fromJson(_transformSupabaseData(data));
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to update client: ${e.toString()}',
        code: 'UPDATE_CLIENT_ERROR',
      );
    }
  }

  @override
  Future<void> deleteClient(String clientId) async {
    try {
      await _supabaseService.deleteClient(clientId);
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException(
        message: 'Failed to delete client: ${e.toString()}',
        code: 'DELETE_CLIENT_ERROR',
      );
    }
  }

  /// Transform Supabase snake_case data to camelCase for models
  Map<String, dynamic> _transformSupabaseData(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'coachId': data['coach_id'],
      'name': data['name'],
      'profilePhotoUrl': data['profile_photo_url'],
      'status': data['status'] ?? 'pending',
      'subscriptionProgress': (data['subscription_progress'] ?? 0.0).toDouble(),
      'joinedAt': data['joined_at'] ?? DateTime.now().toIso8601String(),
      'lastSession': data['last_session'],
      'goals': data['goals'] ?? {},
      'stats': data['stats'] ?? {},
      'sessionHistory': data['session_history'] ?? [],
      'phone': data['phone'],
      'email': data['email'],
    };
  }

  /// Transform camelCase data to Supabase snake_case
  Map<String, dynamic> _transformToSupabaseData(Map<String, dynamic> data) {
    return {
      'id': data['id'],
      'name': data['name'],
      'profile_photo_url': data['profilePhotoUrl'],
      'status': data['status'],
      'subscription_progress': data['subscriptionProgress'],
      'joined_at': data['joinedAt'],
      'last_session': data['lastSession'],
      'goals': data['goals'],
      'stats': data['stats'],
      'session_history': data['sessionHistory'],
      'phone': data['phone'],
      'email': data['email'],
    };
  }
}

