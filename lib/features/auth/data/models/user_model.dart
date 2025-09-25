import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    required String fullName,
    required UserRole role,
    String? department,
    String? phone,
    required DateTime createdAt,
  }) : super(
    id: id,
    email: email,
    fullName: fullName,
    role: role,
    department: department,
    phone: phone,
    createdAt: createdAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      department: json['department'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role.value,
      'department': department,
      'phone': phone,
    };
  }
}
