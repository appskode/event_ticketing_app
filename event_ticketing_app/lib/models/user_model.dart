import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('user')
  user,
  @JsonValue('admin')
  admin,
}

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'email_verified_at') String? emailVerifiedAt,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @Default(UserRole.user) UserRole role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  bool get isAdmin => role == UserRole.admin;
}
