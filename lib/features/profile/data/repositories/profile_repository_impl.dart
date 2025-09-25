import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final profile = await remoteDataSource.getProfile(userId);
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile) async {
    if (await networkInfo.isConnected) {
      try {
        final profileModel = ProfileModel(
          id: profile.id,
          email: profile.email,
          fullName: profile.fullName,
          role: profile.role,
          department: profile.department,
          phone: profile.phone,
          profileImageUrl: profile.profileImageUrl,
          createdAt: profile.createdAt,
          updatedAt: DateTime.now(),
        );
        
        await remoteDataSource.updateProfile(profileModel);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(List<int> bytes, String fileName) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await remoteDataSource.uploadProfileImage(bytes, fileName);
        return Right(imageUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProfile(userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
