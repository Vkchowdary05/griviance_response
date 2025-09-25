part of 'grievance_bloc.dart';

abstract class GrievanceEvent extends Equatable {
  const GrievanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadGrievancesEvent extends GrievanceEvent {
  final String userId;
  final UserRole userRole;
  final String? status;

  const LoadGrievancesEvent({
    required this.userId,
    required this.userRole,
    this.status,
  });

  @override
  List<Object?> get props => [userId, userRole, status];
}

class CreateGrievanceEvent extends GrievanceEvent {
  final String title;
  final String description;
  final String departmentId;
  final String citizenId;
  final double? locationLat;
  final double? locationLng;
  final String? locationAddress;
  final String? imageUrl;
  final GrievancePriority priority;

  const CreateGrievanceEvent({
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

class UpdateGrievanceEvent extends GrievanceEvent {
  final String id;
  final Map<String, dynamic> updates;

  const UpdateGrievanceEvent({
    required this.id,
    required this.updates,
  });

  @override
  List<Object> get props => [id, updates];
}

class FilterGrievancesEvent extends GrievanceEvent {
  final String? status;

  const FilterGrievancesEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class RefreshGrievancesEvent extends GrievanceEvent {}
