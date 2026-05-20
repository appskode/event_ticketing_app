import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:event_ticket_app/models/user_model.dart';
import 'package:event_ticket_app/services/auth_service.dart';
import 'package:event_ticket_app/services/offline_cache_service.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:event_ticket_app/services/storage_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  final offlineCache = ref.watch(offlineCacheServiceProvider);
  return AuthNotifier(authService, storageService, offlineCache);
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final StorageService _storageService;
  final OfflineCacheService _offlineCache;

  AuthNotifier(this._authService, this._storageService, this._offlineCache)
      : super(AuthState(isLoading: true)) {
    _initAuth();
  }

  Future<void> _initAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _storageService.getToken();
      if (token != null) {
        await _authService.refreshToken();
        final userData = await _authService.getMe();
        final user = User.fromJson(userData['data']);
        await _storageService.saveUser(user);
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      await _storageService.clearAll();
      await _offlineCache.clearAll();
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(email, password);
      final token = response['data']['token'];
      final user = User.fromJson(response['data']['user']);

      await _storageService.saveToken(token);
      await _storageService.saveUser(user);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(name, email, password);
      final token = response['data']['token'];
      final user = User.fromJson(response['data']['user']);

      await _storageService.saveToken(token);
      await _storageService.saveUser(user);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.logout();
    } catch (e) {
      // Ignore logout errors
    }
    await _storageService.clearAll();
    await _offlineCache.clearAll();
    state = AuthState();
  }
}
