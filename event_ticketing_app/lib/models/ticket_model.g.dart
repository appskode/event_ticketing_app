// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ticket _$TicketFromJson(Map<String, dynamic> json) => _Ticket(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  eventId: (json['event_id'] as num).toInt(),
  ticketTypeId: (json['ticket_type_id'] as num).toInt(),
  purchaseId: (json['purchase_id'] as num?)?.toInt(),
  ticketNumber: json['ticket_code'] as String? ?? '',
  status: json['status'] as String?,
  usedAt: json['used_at'] as String?,
  cancelledAt: json['cancelled_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  event: json['event'] == null
      ? null
      : Event.fromJson(json['event'] as Map<String, dynamic>),
  ticketType: json['ticket_type'] == null
      ? null
      : TicketType.fromJson(json['ticket_type'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketToJson(_Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'event_id': instance.eventId,
  'ticket_type_id': instance.ticketTypeId,
  'purchase_id': instance.purchaseId,
  'ticket_code': instance.ticketNumber,
  'status': instance.status,
  'used_at': instance.usedAt,
  'cancelled_at': instance.cancelledAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'event': instance.event,
  'ticket_type': instance.ticketType,
};
