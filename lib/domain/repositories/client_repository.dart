import 'package:athletica/data/models/client.dart';

/// Abstract repository interface for client operations
abstract class ClientRepository {
  Future<List<Client>> getClients();
  Future<Client> getClientById(String clientId);
  Future<Client> addClient(Client client);
  Future<Client> updateClient(Client client);
  Future<void> deleteClient(String clientId);
}

