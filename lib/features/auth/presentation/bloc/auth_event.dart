part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final UserRole role;
  final String? department;
  final String? phone;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    this.department,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, fullName, role, department, phone];
}

class LogoutEvent extends AuthEvent {}
