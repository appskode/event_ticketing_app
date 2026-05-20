import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_model.freezed.dart';
part 'purchase_model.g.dart';

@freezed
abstract class Purchase with _$Purchase {
  const factory Purchase({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    Event? event,
    @Default([]) List<Ticket> tickets,
  }) = _Purchase;

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);
}
