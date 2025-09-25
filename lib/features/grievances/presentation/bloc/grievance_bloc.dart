import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../domain/usecases/create_grievance_usecase.dart';
import '../../domain/usecases/get_grievances_usecase.dart';
import '../../domain/usecases/update_grievance_usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

part 'grievance_event.dart';
part 'grievance_state.dart';

class GrievanceBloc extends Bloc<GrievanceEvent, GrievanceState> {
  final CreateGrievanceUseCase createGrievanceUseCase;
  final GetGrievancesUseCase getGrievancesUseCase;
  final UpdateGrievanceUseCase updateGrievanceUseCase;

  GrievanceBloc({
    required this.createGrievanceUseCase,
    required this.getGrievancesUseCase,
    required this.updateGrievanceUseCase,
  }) : super(GrievanceInitialState()) {
    on<LoadGrievancesEvent>(_onLoadGrievances);
    on<CreateGrievanceEvent>(_onCreateGrievance);
    on<UpdateGrievanceEvent>(_onUpdateGrievance);
    on<FilterGrievancesEvent>(_onFilterGrievances);
    on<RefreshGrievancesEvent>(_onRefreshGrievances);
  }

  void _onLoadGrievances(
    LoadGrievancesEvent event,
    Emitter<GrievanceState> emit,
  ) async {
    emit(GrievanceLoadingState());
    
    final result = await getGrievancesUseCase(GetGrievancesParams(
      citizenId: event.userRole == UserRole.citizen ? event.userId : null,
      officerId: event.userRole == UserRole.officer ? event.userId : null,
      status: event.status,
    ));
    
    result.fold(
      (failure) => emit(GrievanceErrorState(message: _mapFailureToMessage(failure))),
      (grievances) => emit(GrievanceLoadedState(grievances: grievances)),
    );
  }

  void _onCreateGrievance(
    CreateGrievanceEvent event,
    Emitter<GrievanceState> emit,
  ) async {
    emit(GrievanceLoadingState());
    
    final result = await createGrievanceUseCase(CreateGrievanceParams(
      title: event.title,
      description: event.description,
      departmentId: event.departmentId,
      citizenId: event.citizenId,
      locationLat: event.locationLat,
      locationLng: event.locationLng,
      locationAddress: event.locationAddress,
      imageUrl: event.imageUrl,
      priority: event.priority,
    ));
    
    result.fold(
      (failure) => emit(GrievanceErrorState(message: _mapFailureToMessage(failure))),
      (grievance) => emit(GrievanceCreatedState(grievance: grievance)),
    );
  }

  void _onUpdateGrievance(
    UpdateGrievanceEvent event,
    Emitter<GrievanceState> emit,
  ) async {
    final result = await updateGrievanceUseCase(UpdateGrievanceParams(
      id: event.id,
      updates: event.updates,
    ));
    
    result.fold(
      (failure) => emit(GrievanceErrorState(message: _mapFailureToMessage(failure))),
      (_) => add(RefreshGrievancesEvent()),
    );
  }

  void _onFilterGrievances(
    FilterGrievancesEvent event,
    Emitter<GrievanceState> emit,
  ) async {
    emit(GrievanceLoadingState());
    
    final result = await getGrievancesUseCase(GetGrievancesParams(
      status: event.status,
    ));
    
    result.fold(
      (failure) => emit(GrievanceErrorState(message: _mapFailureToMessage(failure))),
      (grievances) => emit(GrievanceLoadedState(grievances: grievances)),
    );
  }

  void _onRefreshGrievances(
    RefreshGrievancesEvent event,
    Emitter<GrievanceState> emit,
  ) async {
    final result = await getGrievancesUseCase(const GetGrievancesParams());
    
    result.fold(
      (failure) => emit(GrievanceErrorState(message: _mapFailureToMessage(failure))),
      (grievances) => emit(GrievanceLoadedState(grievances: grievances)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ?? 'Server error occurred';
      case NetworkFailure:
        return 'No internet connection';
      default:
        return 'An unexpected error occurred';
    }
  }
}
