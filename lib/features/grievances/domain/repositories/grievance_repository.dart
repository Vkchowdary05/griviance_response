import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/grievance_entity.dart';

abstract class GrievanceRepository {
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
  });
  
  Future<Either<Failure, List<GrievanceEntity>>> getGrievances({
    String? citizenId,
    String? officerId,
    String? status,
    int limit = 20,
    int offset = 0,
  });
  
  Future<Either<Failure, GrievanceEntity?>> getGrievanceById(String id);
  
  Future<Either<Failure, void>> updateGrievance(
    String id,
    Map<String, dynamic> updates,
  );
  
  Future<Either<Failure, void>> upvoteGrievance(String id);
  
  Future<Either<Failure, List<String>>> uploadImage(List<int> bytes, String fileName);
}
