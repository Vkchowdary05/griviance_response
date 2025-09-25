import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfileImage(List<int> bytes, String fileName);
  Future<Either<Failure, void>> deleteProfile(String userId);
}
