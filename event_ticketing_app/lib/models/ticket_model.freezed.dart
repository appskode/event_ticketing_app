// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Ticket {

 int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'event_id') int get eventId;@JsonKey(name: 'ticket_type_id') int get ticketTypeId;@JsonKey(name: 'purchase_id') int? get purchaseId;@JsonKey(name: 'ticket_code', defaultValue: "") String? get ticketNumber; String? get status;@JsonKey(name: 'used_at') String? get usedAt;@JsonKey(name: 'cancelled_at') String? get cancelledAt;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt; Event? get event;@JsonKey(name: 'ticket_type') TicketType? get ticketType;
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCopyWith<Ticket> get copyWith => _$TicketCopyWithImpl<Ticket>(this as Ticket, _$identity);

  /// Serializes this Ticket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.ticketTypeId, ticketTypeId) || other.ticketTypeId == ticketTypeId)&&(identical(other.purchaseId, purchaseId) || other.purchaseId == purchaseId)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.event, event) || other.event == event)&&(identical(other.ticketType, ticketType) || other.ticketType == ticketType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,eventId,ticketTypeId,purchaseId,ticketNumber,status,usedAt,cancelledAt,createdAt,updatedAt,event,ticketType);

@override
String toString() {
  return 'Ticket(id: $id, userId: $userId, eventId: $eventId, ticketTypeId: $ticketTypeId, purchaseId: $purchaseId, ticketNumber: $ticketNumber, status: $status, usedAt: $usedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, event: $event, ticketType: $ticketType)';
}


}

/// @nodoc
abstract mixin class $TicketCopyWith<$Res>  {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) _then) = _$TicketCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'event_id') int eventId,@JsonKey(name: 'ticket_type_id') int ticketTypeId,@JsonKey(name: 'purchase_id') int? purchaseId,@JsonKey(name: 'ticket_code', defaultValue: "") String? ticketNumber, String? status,@JsonKey(name: 'used_at') String? usedAt,@JsonKey(name: 'cancelled_at') String? cancelledAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, Event? event,@JsonKey(name: 'ticket_type') TicketType? ticketType
});


$EventCopyWith<$Res>? get event;$TicketTypeCopyWith<$Res>? get ticketType;

}
/// @nodoc
class _$TicketCopyWithImpl<$Res>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._self, this._then);

  final Ticket _self;
  final $Res Function(Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? eventId = null,Object? ticketTypeId = null,Object? purchaseId = freezed,Object? ticketNumber = freezed,Object? status = freezed,Object? usedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? event = freezed,Object? ticketType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,ticketTypeId: null == ticketTypeId ? _self.ticketTypeId : ticketTypeId // ignore: cast_nullable_to_non_nullable
as int,purchaseId: freezed == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as int?,ticketNumber: freezed == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,ticketType: freezed == ticketType ? _self.ticketType : ticketType // ignore: cast_nullable_to_non_nullable
as TicketType?,
  ));
}
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketTypeCopyWith<$Res>? get ticketType {
    if (_self.ticketType == null) {
    return null;
  }

  return $TicketTypeCopyWith<$Res>(_self.ticketType!, (value) {
    return _then(_self.copyWith(ticketType: value));
  });
}
}


/// Adds pattern-matching-related methods to [Ticket].
extension TicketPatterns on Ticket {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ticket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ticket value)  $default,){
final _that = this;
switch (_that) {
case _Ticket():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ticket value)?  $default,){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'ticket_type_id')  int ticketTypeId, @JsonKey(name: 'purchase_id')  int? purchaseId, @JsonKey(name: 'ticket_code', defaultValue: "")  String? ticketNumber,  String? status, @JsonKey(name: 'used_at')  String? usedAt, @JsonKey(name: 'cancelled_at')  String? cancelledAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  Event? event, @JsonKey(name: 'ticket_type')  TicketType? ticketType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.userId,_that.eventId,_that.ticketTypeId,_that.purchaseId,_that.ticketNumber,_that.status,_that.usedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.event,_that.ticketType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'ticket_type_id')  int ticketTypeId, @JsonKey(name: 'purchase_id')  int? purchaseId, @JsonKey(name: 'ticket_code', defaultValue: "")  String? ticketNumber,  String? status, @JsonKey(name: 'used_at')  String? usedAt, @JsonKey(name: 'cancelled_at')  String? cancelledAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  Event? event, @JsonKey(name: 'ticket_type')  TicketType? ticketType)  $default,) {final _that = this;
switch (_that) {
case _Ticket():
return $default(_that.id,_that.userId,_that.eventId,_that.ticketTypeId,_that.purchaseId,_that.ticketNumber,_that.status,_that.usedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.event,_that.ticketType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'ticket_type_id')  int ticketTypeId, @JsonKey(name: 'purchase_id')  int? purchaseId, @JsonKey(name: 'ticket_code', defaultValue: "")  String? ticketNumber,  String? status, @JsonKey(name: 'used_at')  String? usedAt, @JsonKey(name: 'cancelled_at')  String? cancelledAt, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt,  Event? event, @JsonKey(name: 'ticket_type')  TicketType? ticketType)?  $default,) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.userId,_that.eventId,_that.ticketTypeId,_that.purchaseId,_that.ticketNumber,_that.status,_that.usedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt,_that.event,_that.ticketType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Ticket implements Ticket {
  const _Ticket({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'event_id') required this.eventId, @JsonKey(name: 'ticket_type_id') required this.ticketTypeId, @JsonKey(name: 'purchase_id') this.purchaseId, @JsonKey(name: 'ticket_code', defaultValue: "") required this.ticketNumber, required this.status, @JsonKey(name: 'used_at') this.usedAt, @JsonKey(name: 'cancelled_at') this.cancelledAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, this.event, @JsonKey(name: 'ticket_type') this.ticketType});
  factory _Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'event_id') final  int eventId;
@override@JsonKey(name: 'ticket_type_id') final  int ticketTypeId;
@override@JsonKey(name: 'purchase_id') final  int? purchaseId;
@override@JsonKey(name: 'ticket_code', defaultValue: "") final  String? ticketNumber;
@override final  String? status;
@override@JsonKey(name: 'used_at') final  String? usedAt;
@override@JsonKey(name: 'cancelled_at') final  String? cancelledAt;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  Event? event;
@override@JsonKey(name: 'ticket_type') final  TicketType? ticketType;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCopyWith<_Ticket> get copyWith => __$TicketCopyWithImpl<_Ticket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.ticketTypeId, ticketTypeId) || other.ticketTypeId == ticketTypeId)&&(identical(other.purchaseId, purchaseId) || other.purchaseId == purchaseId)&&(identical(other.ticketNumber, ticketNumber) || other.ticketNumber == ticketNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.usedAt, usedAt) || other.usedAt == usedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.event, event) || other.event == event)&&(identical(other.ticketType, ticketType) || other.ticketType == ticketType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,eventId,ticketTypeId,purchaseId,ticketNumber,status,usedAt,cancelledAt,createdAt,updatedAt,event,ticketType);

@override
String toString() {
  return 'Ticket(id: $id, userId: $userId, eventId: $eventId, ticketTypeId: $ticketTypeId, purchaseId: $purchaseId, ticketNumber: $ticketNumber, status: $status, usedAt: $usedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt, event: $event, ticketType: $ticketType)';
}


}

/// @nodoc
abstract mixin class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) _then) = __$TicketCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'event_id') int eventId,@JsonKey(name: 'ticket_type_id') int ticketTypeId,@JsonKey(name: 'purchase_id') int? purchaseId,@JsonKey(name: 'ticket_code', defaultValue: "") String? ticketNumber, String? status,@JsonKey(name: 'used_at') String? usedAt,@JsonKey(name: 'cancelled_at') String? cancelledAt,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt, Event? event,@JsonKey(name: 'ticket_type') TicketType? ticketType
});


@override $EventCopyWith<$Res>? get event;@override $TicketTypeCopyWith<$Res>? get ticketType;

}
/// @nodoc
class __$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(this._self, this._then);

  final _Ticket _self;
  final $Res Function(_Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? eventId = null,Object? ticketTypeId = null,Object? purchaseId = freezed,Object? ticketNumber = freezed,Object? status = freezed,Object? usedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? event = freezed,Object? ticketType = freezed,}) {
  return _then(_Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,ticketTypeId: null == ticketTypeId ? _self.ticketTypeId : ticketTypeId // ignore: cast_nullable_to_non_nullable
as int,purchaseId: freezed == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as int?,ticketNumber: freezed == ticketNumber ? _self.ticketNumber : ticketNumber // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,usedAt: freezed == usedAt ? _self.usedAt : usedAt // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,ticketType: freezed == ticketType ? _self.ticketType : ticketType // ignore: cast_nullable_to_non_nullable
as TicketType?,
  ));
}

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketTypeCopyWith<$Res>? get ticketType {
    if (_self.ticketType == null) {
    return null;
  }

  return $TicketTypeCopyWith<$Res>(_self.ticketType!, (value) {
    return _then(_self.copyWith(ticketType: value));
  });
}
}

// dart format on
