// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      department: json['department'] as String?,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'role': _$UserRoleEnumMap[instance.role]!,
      'department': instance.department,
      'phone': instance.phone,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.citizen: 'citizen',
  UserRole.officer: 'officer',
};
