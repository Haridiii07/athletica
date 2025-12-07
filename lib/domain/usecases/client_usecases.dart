import 'package:athletica/data/models/client.dart';
import 'package:athletica/domain/repositories/client_repository.dart';
import 'package:athletica/utils/exceptions.dart';

/// Use case for getting all clients
class GetClientsUseCase {
  final ClientRepository _repository;

  GetClientsUseCase(this._repository);

  Future<List<Client>> call() async {
    return await _repository.getClients();
  }
}

/// Use case for getting a client by ID
class GetClientByIdUseCase {
  final ClientRepository _repository;

  GetClientByIdUseCase(this._repository);

  Future<Client> call(String clientId) async {
    if (clientId.isEmpty) {
      throw ValidationException.requiredField('Client ID');
    }
    return await _repository.getClientById(clientId);
  }
}

/// Use case for adding a new client
class AddClientUseCase {
  final ClientRepository _repository;

  AddClientUseCase(this._repository);

  Future<Client> call(Client client) async {
    // Validate client data
    if (client.name.isEmpty) {
      throw ValidationException.requiredField('Name');
    }
    if (client.email != null && !client.email!.contains('@')) {
      throw ValidationException.invalidEmail();
    }

    return await _repository.addClient(client);
  }
}

/// Use case for updating a client
class UpdateClientUseCase {
  final ClientRepository _repository;

  UpdateClientUseCase(this._repository);

  Future<Client> call(Client client) async {
    if (client.id.isEmpty) {
      throw ValidationException.requiredField('Client ID');
    }
    if (client.name.isEmpty) {
      throw ValidationException.requiredField('Name');
    }

    return await _repository.updateClient(client);
  }
}

/// Use case for deleting a client
class DeleteClientUseCase {
  final ClientRepository _repository;

  DeleteClientUseCase(this._repository);

  Future<void> call(String clientId) async {
    if (clientId.isEmpty) {
      throw ValidationException.requiredField('Client ID');
    }
    await _repository.deleteClient(clientId);
  }
}

