import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';
import 'package:event_ticket_app/services/api/dio_ssl.dart';
import 'package:event_ticket_app/services/auth_service.dart';
import 'package:event_ticket_app/services/event_service.dart';
import 'package:event_ticket_app/services/purchase_service.dart';
import 'package:event_ticket_app/services/storage_service.dart';
import 'package:event_ticket_app/services/ticket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.contentType: 'application/json',
        ApiConstants.accept: 'application/json',
      },
    ),
  );

  configureDioSsl(dio);

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (obj) => debugPrint('🌐 API: $obj'),
      ),
    );
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (kDebugMode) {
          debugPrint('🚀 ${options.method} ${options.path}');
        }

        final token = await ref.read(storageServiceProvider).getToken();
        if (token != null) {
          options.headers[ApiConstants.authorization] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        if (kDebugMode) {
          debugPrint(
            '❌ ${error.response?.statusCode} ${error.requestOptions.path}',
          );
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.watch(dioProvider),
    ref.watch(storageServiceProvider),
  );
});

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService(ref.watch(dioProvider));
});

final ticketServiceProvider = Provider<TicketService>((ref) {
  return TicketService(ref.watch(dioProvider));
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return PurchaseService(ref.watch(dioProvider));
});
