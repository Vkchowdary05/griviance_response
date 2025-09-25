import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/grievance_repository.dart';

class UpdateGrievanceUseCase implements UseCase<void, UpdateGrievanceParams> {
  final GrievanceRepository repository;

  UpdateGrievanceUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateGrievanceParams params) async {
    return await repository.updateGrievance(params.id, params.updates);
  }
}

class UpdateGrievanceParams extends Equatable {
  final String id;
  final Map<String, dynamic> updates;

  const UpdateGrievanceParams({
    required this.id,
    required this.updates,
  });

  @override
  List<Object> get props => [id, updates];
}
