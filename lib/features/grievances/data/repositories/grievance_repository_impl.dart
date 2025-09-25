import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../domain/repositories/grievance_repository.dart';
import '../datasources/grievance_remote_datasource.dart';

class GrievanceRepositoryImpl implements GrievanceRepository {
  final GrievanceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GrievanceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, GrievanceEntity>> createGrievance({
    required String title,
    required String description,
    required String departmentId,
    required String citizenId,
    double? locationLat,
    double? locationLng,
    String? locationAddress,
    String? imageUrl,
    GrievancePriority priority = GrievancePriority.medium,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final grievance = await remoteDataSource.createGrievance(
          title: title,
          description: description,
          departmentId: departmentId,
          citizenId: citizenId,
          locationLat: locationLat,
          locationLng: locationLng,
          locationAddress: locationAddress,
          imageUrl: imageUrl,
          priority: priority,
        );
        return Right(grievance);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<GrievanceEntity>>> getGrievances({
    String? citizenId,
    String? officerId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final grievances = await remoteDataSource.getGrievances(
          citizenId: citizenId,
          officerId: officerId,
          status: status,
          limit: limit,
          offset: offset,
        );
        return Right(grievances);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, GrievanceEntity?>> getGrievanceById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final grievance = await remoteDataSource.getGrievanceById(id);
        return Right(grievance);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateGrievance(
    String id,
    Map<String, dynamic> updates,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateGrievance(id, updates);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> upvoteGrievance(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.upvoteGrievance(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImage(List<int> bytes, String fileName) async {
    if (await networkInfo.isConnected) {
      try {
        final url = await remoteDataSource.uploadImage(bytes, fileName);
        return Right([url]);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
