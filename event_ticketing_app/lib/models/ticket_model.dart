import 'package:event_ticket_app/models/event_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'ticket_type_id') required int ticketTypeId,
    @JsonKey(name: 'purchase_id') int? purchaseId,
    @JsonKey(name: 'ticket_code', defaultValue: "")
    required String? ticketNumber,
    required String? status,
    @JsonKey(name: 'used_at') String? usedAt,
    @JsonKey(name: 'cancelled_at') String? cancelledAt,
    @JsonKey(name: 'created_at') required String? createdAt,
    @JsonKey(name: 'updated_at') required String? updatedAt,
    Event? event,
    @JsonKey(name: 'ticket_type') TicketType? ticketType,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}
