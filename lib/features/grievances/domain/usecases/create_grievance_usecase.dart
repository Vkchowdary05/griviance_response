import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/grievance_entity.dart';
import '../repositories/grievance_repository.dart';

class CreateGrievanceUseCase implements UseCase<GrievanceEntity, CreateGrievanceParams> {
  final GrievanceRepository repository;

  CreateGrievanceUseCase(this.repository);

  @override
  Future<Either<Failure, GrievanceEntity>> call(CreateGrievanceParams params) async {
    return await repository.createGrievance(
      title: params.title,
      description: params.description,
      departmentId: params.departmentId,
      citizenId: params.citizenId,
      locationLat: params.locationLat,
      locationLng: params.locationLng,
      locationAddress: params.locationAddress,
      imageUrl: params.imageUrl,
      priority: params.priority,
    );
  }
}

class CreateGrievanceParams extends Equatable {
  final String title;
  final String description;
  final String departmentId;
  final String citizenId;
  final double? locationLat;
  final double? locationLng;
  final String? locationAddress;
  final String? imageUrl;
  final GrievancePriority priority;

  const CreateGrievanceParams({
    required this.title,
    required this.description,
    required this.departmentId,
    required this.citizenId,
    this.locationLat,
    this.locationLng,
    this.locationAddress,
    this.imageUrl,
    this.priority = GrievancePriority.medium,
  });

  @override
  List<Object?> get props => [
    title, description, departmentId, citizenId,
    locationLat, locationLng, locationAddress, imageUrl, priority
  ];
}
