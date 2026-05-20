import 'dart:convert';

import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:event_ticket_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _ticketsKey = 'my_tickets';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> removeUser() async {
    await _storage.delete(key: _userKey);
  }

  Future<void> saveTickets(List<Ticket> tickets) async {
    final ticketsJson = tickets.map((t) => t.toJson()).toList();
    await _storage.write(key: _ticketsKey, value: jsonEncode(ticketsJson));
  }

  Future<List<Ticket>> getStoredTickets() async {
    final ticketsData = await _storage.read(key: _ticketsKey);
    if (ticketsData != null) {
      final List<dynamic> ticketsJson = jsonDecode(ticketsData);
      return ticketsJson.map((t) => Ticket.fromJson(t)).toList();
    }
    return [];
  }

  Future<void> removeTickets() async {
    await _storage.delete(key: _ticketsKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
