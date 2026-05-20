// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Purchase {

 int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'event_id') int get eventId;@JsonKey(name: 'total_amount') double get totalAmount;@JsonKey(name: 'payment_status') String get paymentStatus;@JsonKey(name: 'payment_method') String? get paymentMethod;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt; Event? get event; List<Ticket> get tickets;
/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseCopyWith<Purchase> get copyWith => _$PurchaseCopyWithImpl<Purchase>(this as Purchase, _$identity);

  /// Serializes this Purchase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Purchase&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other.tickets, tickets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,eventId,totalAmount,paymentStatus,paymentMethod,createdAt,updatedAt,event,const DeepCollectionEquality().hash(tickets));

@override
String toString() {
  return 'Purchase(id: $id, userId: $userId, eventId: $eventId, totalAmount: $totalAmount, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt, event: $event, tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class $PurchaseCopyWith<$Res>  {
  factory $PurchaseCopyWith(Purchase value, $Res Function(Purchase) _then) = _$PurchaseCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'event_id') int eventId,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, Event? event, List<Ticket> tickets
});


$EventCopyWith<$Res>? get event;

}
/// @nodoc
class _$PurchaseCopyWithImpl<$Res>
    implements $PurchaseCopyWith<$Res> {
  _$PurchaseCopyWithImpl(this._self, this._then);

  final Purchase _self;
  final $Res Function(Purchase) _then;

/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? eventId = null,Object? totalAmount = null,Object? paymentStatus = null,Object? paymentMethod = freezed,Object? createdAt = null,Object? updatedAt = null,Object? event = freezed,Object? tickets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,
  ));
}
/// Create a copy of Purchase
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
}
}


/// Adds pattern-matching-related methods to [Purchase].
extension PurchasePatterns on Purchase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Purchase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Purchase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Purchase value)  $default,){
final _that = this;
switch (_that) {
case _Purchase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Purchase value)?  $default,){
final _that = this;
switch (_that) {
case _Purchase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Event? event,  List<Ticket> tickets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Purchase() when $default != null:
return $default(_that.id,_that.userId,_that.eventId,_that.totalAmount,_that.paymentStatus,_that.paymentMethod,_that.createdAt,_that.updatedAt,_that.event,_that.tickets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Event? event,  List<Ticket> tickets)  $default,) {final _that = this;
switch (_that) {
case _Purchase():
return $default(_that.id,_that.userId,_that.eventId,_that.totalAmount,_that.paymentStatus,_that.paymentMethod,_that.createdAt,_that.updatedAt,_that.event,_that.tickets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'event_id')  int eventId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt,  Event? event,  List<Ticket> tickets)?  $default,) {final _that = this;
switch (_that) {
case _Purchase() when $default != null:
return $default(_that.id,_that.userId,_that.eventId,_that.totalAmount,_that.paymentStatus,_that.paymentMethod,_that.createdAt,_that.updatedAt,_that.event,_that.tickets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Purchase implements Purchase {
  const _Purchase({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'event_id') required this.eventId, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'payment_status') required this.paymentStatus, @JsonKey(name: 'payment_method') this.paymentMethod, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, this.event, final  List<Ticket> tickets = const []}): _tickets = tickets;
  factory _Purchase.fromJson(Map<String, dynamic> json) => _$PurchaseFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'event_id') final  int eventId;
@override@JsonKey(name: 'total_amount') final  double totalAmount;
@override@JsonKey(name: 'payment_status') final  String paymentStatus;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override final  Event? event;
 final  List<Ticket> _tickets;
@override@JsonKey() List<Ticket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}


/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseCopyWith<_Purchase> get copyWith => __$PurchaseCopyWithImpl<_Purchase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Purchase&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other._tickets, _tickets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,eventId,totalAmount,paymentStatus,paymentMethod,createdAt,updatedAt,event,const DeepCollectionEquality().hash(_tickets));

@override
String toString() {
  return 'Purchase(id: $id, userId: $userId, eventId: $eventId, totalAmount: $totalAmount, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt, event: $event, tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class _$PurchaseCopyWith<$Res> implements $PurchaseCopyWith<$Res> {
  factory _$PurchaseCopyWith(_Purchase value, $Res Function(_Purchase) _then) = __$PurchaseCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'event_id') int eventId,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'payment_method') String? paymentMethod,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, Event? event, List<Ticket> tickets
});


@override $EventCopyWith<$Res>? get event;

}
/// @nodoc
class __$PurchaseCopyWithImpl<$Res>
    implements _$PurchaseCopyWith<$Res> {
  __$PurchaseCopyWithImpl(this._self, this._then);

  final _Purchase _self;
  final $Res Function(_Purchase) _then;

/// Create a copy of Purchase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? eventId = null,Object? totalAmount = null,Object? paymentStatus = null,Object? paymentMethod = freezed,Object? createdAt = null,Object? updatedAt = null,Object? event = freezed,Object? tickets = null,}) {
  return _then(_Purchase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event?,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,
  ));
}

/// Create a copy of Purchase
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
}
}

// dart format on
