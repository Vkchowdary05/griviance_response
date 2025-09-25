import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/grievance_entity.dart';
import '../repositories/grievance_repository.dart';

class GetGrievancesUseCase implements UseCase<List<GrievanceEntity>, GetGrievancesParams> {
  final GrievanceRepository repository;

  GetGrievancesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GrievanceEntity>>> call(GetGrievancesParams params) async {
    return await repository.getGrievances(
      citizenId: params.citizenId,
      officerId: params.officerId,
      status: params.status,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetGrievancesParams extends Equatable {
  final String? citizenId;
  final String? officerId;
  final String? status;
  final int limit;
  final int offset;

  const GetGrievancesParams({
    this.citizenId,
    this.officerId,
    this.status,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [citizenId, officerId, status, limit, offset];
}
