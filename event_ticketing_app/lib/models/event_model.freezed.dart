// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 int get id; String get name; String get description; String get location; String get category;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'event_date') String get eventDate;@JsonKey(name: 'sale_start_date') String get saleStartDate;@JsonKey(name: 'sale_end_date') String get saleEndDate;@JsonKey(name: 'is_sale_active') bool get isSaleActive;@JsonKey(name: 'allow_cancellation') bool get allowCancellation;@JsonKey(name: 'cancellation_hours_before') int? get cancellationHoursBefore;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'ticket_types') List<TicketType> get ticketTypes;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.isSaleActive, isSaleActive) || other.isSaleActive == isSaleActive)&&(identical(other.allowCancellation, allowCancellation) || other.allowCancellation == allowCancellation)&&(identical(other.cancellationHoursBefore, cancellationHoursBefore) || other.cancellationHoursBefore == cancellationHoursBefore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.ticketTypes, ticketTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,location,category,imageUrl,eventDate,saleStartDate,saleEndDate,isSaleActive,allowCancellation,cancellationHoursBefore,createdAt,updatedAt,const DeepCollectionEquality().hash(ticketTypes));

@override
String toString() {
  return 'Event(id: $id, name: $name, description: $description, location: $location, category: $category, imageUrl: $imageUrl, eventDate: $eventDate, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, isSaleActive: $isSaleActive, allowCancellation: $allowCancellation, cancellationHoursBefore: $cancellationHoursBefore, createdAt: $createdAt, updatedAt: $updatedAt, ticketTypes: $ticketTypes)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, String location, String category,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'event_date') String eventDate,@JsonKey(name: 'sale_start_date') String saleStartDate,@JsonKey(name: 'sale_end_date') String saleEndDate,@JsonKey(name: 'is_sale_active') bool isSaleActive,@JsonKey(name: 'allow_cancellation') bool allowCancellation,@JsonKey(name: 'cancellation_hours_before') int? cancellationHoursBefore,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'ticket_types') List<TicketType> ticketTypes
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? location = null,Object? category = null,Object? imageUrl = freezed,Object? eventDate = null,Object? saleStartDate = null,Object? saleEndDate = null,Object? isSaleActive = null,Object? allowCancellation = null,Object? cancellationHoursBefore = freezed,Object? createdAt = freezed,Object? updatedAt = null,Object? ticketTypes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as String,saleStartDate: null == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as String,saleEndDate: null == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as String,isSaleActive: null == isSaleActive ? _self.isSaleActive : isSaleActive // ignore: cast_nullable_to_non_nullable
as bool,allowCancellation: null == allowCancellation ? _self.allowCancellation : allowCancellation // ignore: cast_nullable_to_non_nullable
as bool,cancellationHoursBefore: freezed == cancellationHoursBefore ? _self.cancellationHoursBefore : cancellationHoursBefore // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,ticketTypes: null == ticketTypes ? _self.ticketTypes : ticketTypes // ignore: cast_nullable_to_non_nullable
as List<TicketType>,
  ));
}

}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String location,  String category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'sale_start_date')  String saleStartDate, @JsonKey(name: 'sale_end_date')  String saleEndDate, @JsonKey(name: 'is_sale_active')  bool isSaleActive, @JsonKey(name: 'allow_cancellation')  bool allowCancellation, @JsonKey(name: 'cancellation_hours_before')  int? cancellationHoursBefore, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'ticket_types')  List<TicketType> ticketTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.location,_that.category,_that.imageUrl,_that.eventDate,_that.saleStartDate,_that.saleEndDate,_that.isSaleActive,_that.allowCancellation,_that.cancellationHoursBefore,_that.createdAt,_that.updatedAt,_that.ticketTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String location,  String category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'sale_start_date')  String saleStartDate, @JsonKey(name: 'sale_end_date')  String saleEndDate, @JsonKey(name: 'is_sale_active')  bool isSaleActive, @JsonKey(name: 'allow_cancellation')  bool allowCancellation, @JsonKey(name: 'cancellation_hours_before')  int? cancellationHoursBefore, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'ticket_types')  List<TicketType> ticketTypes)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.name,_that.description,_that.location,_that.category,_that.imageUrl,_that.eventDate,_that.saleStartDate,_that.saleEndDate,_that.isSaleActive,_that.allowCancellation,_that.cancellationHoursBefore,_that.createdAt,_that.updatedAt,_that.ticketTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  String location,  String category, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'event_date')  String eventDate, @JsonKey(name: 'sale_start_date')  String saleStartDate, @JsonKey(name: 'sale_end_date')  String saleEndDate, @JsonKey(name: 'is_sale_active')  bool isSaleActive, @JsonKey(name: 'allow_cancellation')  bool allowCancellation, @JsonKey(name: 'cancellation_hours_before')  int? cancellationHoursBefore, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'ticket_types')  List<TicketType> ticketTypes)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.location,_that.category,_that.imageUrl,_that.eventDate,_that.saleStartDate,_that.saleEndDate,_that.isSaleActive,_that.allowCancellation,_that.cancellationHoursBefore,_that.createdAt,_that.updatedAt,_that.ticketTypes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
  const _Event({required this.id, required this.name, required this.description, required this.location, this.category = 'general', @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'event_date') required this.eventDate, @JsonKey(name: 'sale_start_date') required this.saleStartDate, @JsonKey(name: 'sale_end_date') required this.saleEndDate, @JsonKey(name: 'is_sale_active') this.isSaleActive = false, @JsonKey(name: 'allow_cancellation') this.allowCancellation = false, @JsonKey(name: 'cancellation_hours_before') this.cancellationHoursBefore, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'ticket_types') final  List<TicketType> ticketTypes = const []}): _ticketTypes = ticketTypes;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  int id;
@override final  String name;
@override final  String description;
@override final  String location;
@override@JsonKey() final  String category;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'event_date') final  String eventDate;
@override@JsonKey(name: 'sale_start_date') final  String saleStartDate;
@override@JsonKey(name: 'sale_end_date') final  String saleEndDate;
@override@JsonKey(name: 'is_sale_active') final  bool isSaleActive;
@override@JsonKey(name: 'allow_cancellation') final  bool allowCancellation;
@override@JsonKey(name: 'cancellation_hours_before') final  int? cancellationHoursBefore;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
 final  List<TicketType> _ticketTypes;
@override@JsonKey(name: 'ticket_types') List<TicketType> get ticketTypes {
  if (_ticketTypes is EqualUnmodifiableListView) return _ticketTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ticketTypes);
}


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.category, category) || other.category == category)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.saleStartDate, saleStartDate) || other.saleStartDate == saleStartDate)&&(identical(other.saleEndDate, saleEndDate) || other.saleEndDate == saleEndDate)&&(identical(other.isSaleActive, isSaleActive) || other.isSaleActive == isSaleActive)&&(identical(other.allowCancellation, allowCancellation) || other.allowCancellation == allowCancellation)&&(identical(other.cancellationHoursBefore, cancellationHoursBefore) || other.cancellationHoursBefore == cancellationHoursBefore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._ticketTypes, _ticketTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,location,category,imageUrl,eventDate,saleStartDate,saleEndDate,isSaleActive,allowCancellation,cancellationHoursBefore,createdAt,updatedAt,const DeepCollectionEquality().hash(_ticketTypes));

@override
String toString() {
  return 'Event(id: $id, name: $name, description: $description, location: $location, category: $category, imageUrl: $imageUrl, eventDate: $eventDate, saleStartDate: $saleStartDate, saleEndDate: $saleEndDate, isSaleActive: $isSaleActive, allowCancellation: $allowCancellation, cancellationHoursBefore: $cancellationHoursBefore, createdAt: $createdAt, updatedAt: $updatedAt, ticketTypes: $ticketTypes)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, String location, String category,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'event_date') String eventDate,@JsonKey(name: 'sale_start_date') String saleStartDate,@JsonKey(name: 'sale_end_date') String saleEndDate,@JsonKey(name: 'is_sale_active') bool isSaleActive,@JsonKey(name: 'allow_cancellation') bool allowCancellation,@JsonKey(name: 'cancellation_hours_before') int? cancellationHoursBefore,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'ticket_types') List<TicketType> ticketTypes
});




}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? location = null,Object? category = null,Object? imageUrl = freezed,Object? eventDate = null,Object? saleStartDate = null,Object? saleEndDate = null,Object? isSaleActive = null,Object? allowCancellation = null,Object? cancellationHoursBefore = freezed,Object? createdAt = freezed,Object? updatedAt = null,Object? ticketTypes = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as String,saleStartDate: null == saleStartDate ? _self.saleStartDate : saleStartDate // ignore: cast_nullable_to_non_nullable
as String,saleEndDate: null == saleEndDate ? _self.saleEndDate : saleEndDate // ignore: cast_nullable_to_non_nullable
as String,isSaleActive: null == isSaleActive ? _self.isSaleActive : isSaleActive // ignore: cast_nullable_to_non_nullable
as bool,allowCancellation: null == allowCancellation ? _self.allowCancellation : allowCancellation // ignore: cast_nullable_to_non_nullable
as bool,cancellationHoursBefore: freezed == cancellationHoursBefore ? _self.cancellationHoursBefore : cancellationHoursBefore // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,ticketTypes: null == ticketTypes ? _self._ticketTypes : ticketTypes // ignore: cast_nullable_to_non_nullable
as List<TicketType>,
  ));
}


}


/// @nodoc
mixin _$TicketType {

 int get id;@JsonKey(name: 'event_id') int get eventId; String get name; String? get description;@JsonKey(name: 'price') double get price;@JsonKey(name: 'total_quantity') int get totalQuantity;@JsonKey(name: 'available_quantity') int get availableQuantity;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of TicketType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketTypeCopyWith<TicketType> get copyWith => _$TicketTypeCopyWithImpl<TicketType>(this as TicketType, _$identity);

  /// Serializes this TicketType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketType&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,name,description,price,totalQuantity,availableQuantity,createdAt,updatedAt);

@override
String toString() {
  return 'TicketType(id: $id, eventId: $eventId, name: $name, description: $description, price: $price, totalQuantity: $totalQuantity, availableQuantity: $availableQuantity, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TicketTypeCopyWith<$Res>  {
  factory $TicketTypeCopyWith(TicketType value, $Res Function(TicketType) _then) = _$TicketTypeCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'event_id') int eventId, String name, String? description,@JsonKey(name: 'price') double price,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'available_quantity') int availableQuantity,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$TicketTypeCopyWithImpl<$Res>
    implements $TicketTypeCopyWith<$Res> {
  _$TicketTypeCopyWithImpl(this._self, this._then);

  final TicketType _self;
  final $Res Function(TicketType) _then;

/// Create a copy of TicketType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? name = null,Object? description = freezed,Object? price = null,Object? totalQuantity = null,Object? availableQuantity = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,availableQuantity: null == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketType].
extension TicketTypePatterns on TicketType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketType value)  $default,){
final _that = this;
switch (_that) {
case _TicketType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketType value)?  $default,){
final _that = this;
switch (_that) {
case _TicketType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'event_id')  int eventId,  String name,  String? description, @JsonKey(name: 'price')  double price, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'available_quantity')  int availableQuantity, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketType() when $default != null:
return $default(_that.id,_that.eventId,_that.name,_that.description,_that.price,_that.totalQuantity,_that.availableQuantity,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'event_id')  int eventId,  String name,  String? description, @JsonKey(name: 'price')  double price, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'available_quantity')  int availableQuantity, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TicketType():
return $default(_that.id,_that.eventId,_that.name,_that.description,_that.price,_that.totalQuantity,_that.availableQuantity,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'event_id')  int eventId,  String name,  String? description, @JsonKey(name: 'price')  double price, @JsonKey(name: 'total_quantity')  int totalQuantity, @JsonKey(name: 'available_quantity')  int availableQuantity, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TicketType() when $default != null:
return $default(_that.id,_that.eventId,_that.name,_that.description,_that.price,_that.totalQuantity,_that.availableQuantity,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketType implements TicketType {
  const _TicketType({required this.id, @JsonKey(name: 'event_id') required this.eventId, required this.name, this.description, @JsonKey(name: 'price') required this.price, @JsonKey(name: 'total_quantity') required this.totalQuantity, @JsonKey(name: 'available_quantity') this.availableQuantity = 0, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _TicketType.fromJson(Map<String, dynamic> json) => _$TicketTypeFromJson(json);

@override final  int id;
@override@JsonKey(name: 'event_id') final  int eventId;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'price') final  double price;
@override@JsonKey(name: 'total_quantity') final  int totalQuantity;
@override@JsonKey(name: 'available_quantity') final  int availableQuantity;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of TicketType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketTypeCopyWith<_TicketType> get copyWith => __$TicketTypeCopyWithImpl<_TicketType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketType&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,name,description,price,totalQuantity,availableQuantity,createdAt,updatedAt);

@override
String toString() {
  return 'TicketType(id: $id, eventId: $eventId, name: $name, description: $description, price: $price, totalQuantity: $totalQuantity, availableQuantity: $availableQuantity, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TicketTypeCopyWith<$Res> implements $TicketTypeCopyWith<$Res> {
  factory _$TicketTypeCopyWith(_TicketType value, $Res Function(_TicketType) _then) = __$TicketTypeCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'event_id') int eventId, String name, String? description,@JsonKey(name: 'price') double price,@JsonKey(name: 'total_quantity') int totalQuantity,@JsonKey(name: 'available_quantity') int availableQuantity,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$TicketTypeCopyWithImpl<$Res>
    implements _$TicketTypeCopyWith<$Res> {
  __$TicketTypeCopyWithImpl(this._self, this._then);

  final _TicketType _self;
  final $Res Function(_TicketType) _then;

/// Create a copy of TicketType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? name = null,Object? description = freezed,Object? price = null,Object? totalQuantity = null,Object? availableQuantity = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TicketType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,availableQuantity: null == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
