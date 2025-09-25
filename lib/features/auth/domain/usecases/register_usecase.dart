import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      role: params.role,
      department: params.department,
      phone: params.phone,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final UserRole role;
  final String? department;
  final String? phone;

  const RegisterParams({
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
