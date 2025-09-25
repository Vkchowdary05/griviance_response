import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;
  final String? department;
  final String? phone;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.department,
    this.phone,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, email, fullName, role, department, phone, createdAt
  ];
}

enum UserRole { citizen, officer }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.citizen:
        return 'citizen';
      case UserRole.officer:
        return 'officer';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'officer':
        return UserRole.officer;
      default:
        return UserRole.citizen;
    }
  }
}
