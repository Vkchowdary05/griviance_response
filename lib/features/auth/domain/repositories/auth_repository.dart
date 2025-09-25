import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? department,
    String? phone,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> updateProfile(UserEntity user);
  Future<Either<Failure, void>> resetPassword(String email);
}
