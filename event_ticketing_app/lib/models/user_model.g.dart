// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  emailVerifiedAt: json['email_verified_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'role': _$UserRoleEnumMap[instance.role]!,
};

const _$UserRoleEnumMap = {UserRole.user: 'user', UserRole.admin: 'admin'};
