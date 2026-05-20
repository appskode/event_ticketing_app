import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/storage_service.dart';

class AuthService {
  final Dio _dio;
  final StorageService _storage;

  AuthService(this._dio, this._storage);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Login failed with status code: ${response.data["message"] ?? "Unknown error"}',
        );
      }
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } on DioException {
      // Ignore logout errors — local session is cleared regardless.
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _dio.get(ApiConstants.me);
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<bool> refreshToken() async {
    try {
      final response = await _dio.post(ApiConstants.refresh);
      final token = parseRefreshToken(response.data);
      if (token != null) {
        await _storage.saveToken(token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
