part of 'grievance_bloc.dart';

abstract class GrievanceState extends Equatable {
  const GrievanceState();

  @override
  List<Object?> get props => [];
}

class GrievanceInitialState extends GrievanceState {}

class GrievanceLoadingState extends GrievanceState {}

class GrievanceLoadedState extends GrievanceState {
  final List<GrievanceEntity> grievances;

  const GrievanceLoadedState({required this.grievances});

  @override
  List<Object> get props => [grievances];
}

class GrievanceCreatedState extends GrievanceState {
  final GrievanceEntity grievance;

  const GrievanceCreatedState({required this.grievance});

  @override
  List<Object> get props => [grievance];
}

class GrievanceErrorState extends GrievanceState {
  final String message;

  const GrievanceErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
