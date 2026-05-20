import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';
import 'package:event_ticket_app/services/api/api_client.dart';

class TicketService {
  final Dio _dio;

  TicketService(this._dio);

  Future<Map<String, dynamic>> getMyTickets({
    int page = 1,
    String? status,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.myTickets,
        queryParameters: {
          'page': page,
          if (status != null) 'status': status,
        },
      );
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getTicket(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.tickets}/$id');
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> cancelTicket(int id) async {
    try {
      final response = await _dio.post('${ApiConstants.tickets}/$id/cancel');
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }
}
