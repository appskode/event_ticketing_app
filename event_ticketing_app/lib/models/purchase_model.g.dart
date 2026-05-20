// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Purchase _$PurchaseFromJson(Map<String, dynamic> json) => _Purchase(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  eventId: (json['event_id'] as num).toInt(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  paymentStatus: json['payment_status'] as String,
  paymentMethod: json['payment_method'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  event: json['event'] == null
      ? null
      : Event.fromJson(json['event'] as Map<String, dynamic>),
  tickets:
      (json['tickets'] as List<dynamic>?)
          ?.map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PurchaseToJson(_Purchase instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'event_id': instance.eventId,
  'total_amount': instance.totalAmount,
  'payment_status': instance.paymentStatus,
  'payment_method': instance.paymentMethod,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'event': instance.event,
  'tickets': instance.tickets,
};
