import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? department;
  final String? phone;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.department,
    this.phone,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, email, fullName, role, department, phone, profileImageUrl, createdAt, updatedAt
  ];
}
