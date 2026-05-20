import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';
import 'package:event_ticket_app/services/api/api_client.dart';

class PurchaseService {
  final Dio _dio;

  PurchaseService(this._dio);

  Future<Map<String, dynamic>> purchaseTickets(
    int eventId,
    List<Map<String, dynamic>> tickets,
  ) async {
    try {
      final response = await _dio.post(
        ApiConstants.purchase,
        data: {'event_id': eventId, 'tickets': tickets},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to purchase tickets: ${response.data["message"] ?? "Failed"}',
        );
      }
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getPurchases({int page = 1}) async {
    try {
      final response = await _dio.get(
        ApiConstants.purchases,
        queryParameters: {'page': page},
      );
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getPurchase(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.purchases}/$id');
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }
}
