import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required String id,
    required String email,
    required String fullName,
    required String role,
    String? department,
    String? phone,
    String? profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    email: email,
    fullName: fullName,
    role: role,
    department: department,
    phone: phone,
    profileImageUrl: profileImageUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromSupabase(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'department': department,
      'phone': phone,
      'profile_image_url': profileImageUrl,
    };
  }
}
