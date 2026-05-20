import 'package:dio/dio.dart';
import 'package:event_ticket_app/services/api/api_constants.dart';
import 'package:event_ticket_app/services/api/api_client.dart';

class EventService {
  final Dio _dio;

  EventService(this._dio);

  /// Laravel accepts 1/0 for boolean query params, not the string "false".
  static String? _boolQuery(bool? value) {
    if (value == null) return null;
    return value ? '1' : '0';
  }

  Future<Map<String, dynamic>> getEvents({
    int page = 1,
    int perPage = 10,
    String? category,
    String? location,
    String? dateFrom,
    String? dateTo,
    bool? onSale,
    bool? upcoming,
    bool? past,
    String? query,
    String? sort,
    String? sortDir,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.events,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (category != null && category.isNotEmpty) 'category': category,
          if (location != null && location.isNotEmpty) 'location': location,
          if (dateFrom != null) 'date_from': dateFrom,
          if (dateTo != null) 'date_to': dateTo,
          if (onSale != null) 'on_sale': _boolQuery(onSale),
          if (upcoming != null) 'upcoming': _boolQuery(upcoming),
          if (past != null) 'past': _boolQuery(past),
          if (query != null && query.isNotEmpty) 'q': query,
          if (sort != null) 'sort': sort,
          if (sortDir != null) 'sort_dir': sortDir,
        },
      );
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.eventCategories);
      return response.data['data'] as List<dynamic>;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> getEvent(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.events}/$id');
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> createEvent(
    Map<String, dynamic> eventData,
  ) async {
    try {
      final response = await _dio.post(ApiConstants.events, data: eventData);
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> addTicketType(
    int eventId,
    Map<String, dynamic> ticketData,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.events}/$eventId/ticket-types',
        data: ticketData,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioError(e);
    }
  }
}
