import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';

/// Backend returns `{ "success": true, "token": "..." }` from POST /auth/refresh.
String? parseRefreshToken(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['token'] as String?;
  }
  return null;
}

Never handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw Exception(
        'Connection timeout. Please check your internet connection.',
      );
    case DioExceptionType.sendTimeout:
      throw Exception('Request timeout. Please try again.');
    case DioExceptionType.receiveTimeout:
      throw Exception('Server response timeout. Please try again.');
    case DioExceptionType.badResponse:
      final data = e.response?.data;
      var message = 'Something went wrong';
      if (data is Map) {
        message = data['message'] as String? ??
            data['error'] as String? ??
            message;
        // Laravel validation (422) often returns { "message": "...", "errors": { "field": ["..."] } }
        if (message == 'Something went wrong' || message.isEmpty) {
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final first = errors.values.first;
            if (first is List && first.isNotEmpty) {
              message = first.first as String? ?? message;
            }
          }
        }
      }
      throw Exception(message);
    case DioExceptionType.cancel:
      throw Exception('Request was cancelled.');
    case DioExceptionType.connectionError:
      throw Exception(
        'Cannot connect to server. Please check if your Laravel server is running at ${ApiConstants.baseUrl}',
      );
    case DioExceptionType.unknown:
      throw Exception('Network error: ${e.message}');
    default:
      throw Exception('Unexpected error: ${e.message}');
  }
}

bool isNetworkError(Object error) {
  if (error is DioException) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
  return false;
}

/// Strips the `Exception: ` prefix from caught API errors for display in the UI.
String userFacingError(Object error) {
  final text = error.toString();
  const prefix = 'Exception: ';
  return text.startsWith(prefix) ? text.substring(prefix.length) : text;
}
