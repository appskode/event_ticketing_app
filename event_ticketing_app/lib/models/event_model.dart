import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
abstract class Event with _$Event {
  const factory Event({
    required int id,
    required String name,
    required String description,
    required String location,
    @Default('general') String category,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'event_date') required String eventDate,
    @JsonKey(name: 'sale_start_date') required String saleStartDate,
    @JsonKey(name: 'sale_end_date') required String saleEndDate,
    @JsonKey(name: 'is_sale_active') @Default(false) bool isSaleActive,
    @JsonKey(name: 'allow_cancellation') @Default(false) bool allowCancellation,
    @JsonKey(name: 'cancellation_hours_before') int? cancellationHoursBefore,
    @JsonKey(name: 'created_at') required String? createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'ticket_types') @Default([]) List<TicketType> ticketTypes,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

@freezed
abstract class TicketType with _$TicketType {
  const factory TicketType({
    required int id,
    @JsonKey(name: 'event_id') required int eventId,
    required String name,
    String? description,
    @JsonKey(name: 'price') required double price,
    @JsonKey(name: 'total_quantity') required int totalQuantity,
    @JsonKey(name: 'available_quantity') @Default(0) int availableQuantity,
    @JsonKey(name: 'created_at') required String? createdAt,
    @JsonKey(name: 'updated_at') required String? updatedAt,
  }) = _TicketType;

  factory TicketType.fromJson(Map<String, dynamic> json) =>
      _$TicketTypeFromJson(json);
}
