import 'package:equatable/equatable.dart';

class GrievanceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String departmentId;
  final String citizenId;
  final String? assignedOfficerId;
  final GrievanceStatus status;
  final GrievancePriority priority;
  final double? locationLat;
  final double? locationLng;
  final String? locationAddress;
  final String? imageUrl;
  final int upvotes;
  final double aiScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related entities
  final String? departmentName;
  final String? citizenName;
  final String? officerName;

  const GrievanceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.departmentId,
    required this.citizenId,
    this.assignedOfficerId,
    required this.status,
    required this.priority,
    this.locationLat,
    this.locationLng,
    this.locationAddress,
    this.imageUrl,
    required this.upvotes,
    required this.aiScore,
    required this.createdAt,
    required this.updatedAt,
    this.departmentName,
    this.citizenName,
    this.officerName,
  });

  @override
  List<Object?> get props => [
    id, title, description, departmentId, citizenId, assignedOfficerId,
    status, priority, locationLat, locationLng, locationAddress, imageUrl,
    upvotes, aiScore, createdAt, updatedAt
  ];
}

enum GrievanceStatus { pending, inProgress, resolved, rejected }
enum GrievancePriority { low, medium, high, urgent }

extension GrievanceStatusExtension on GrievanceStatus {
  String get value {
    switch (this) {
      case GrievanceStatus.pending:
        return 'pending';
      case GrievanceStatus.inProgress:
        return 'in_progress';
      case GrievanceStatus.resolved:
        return 'resolved';
      case GrievanceStatus.rejected:
        return 'rejected';
    }
  }

  static GrievanceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return GrievanceStatus.inProgress;
      case 'resolved':
        return GrievanceStatus.resolved;
      case 'rejected':
        return GrievanceStatus.rejected;
      default:
        return GrievanceStatus.pending;
    }
  }
}

extension GrievancePriorityExtension on GrievancePriority {
  String get value {
    switch (this) {
      case GrievancePriority.low:
        return 'low';
      case GrievancePriority.medium:
        return 'medium';
      case GrievancePriority.high:
        return 'high';
      case GrievancePriority.urgent:
        return 'urgent';
    }
  }

  static GrievancePriority fromString(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return GrievancePriority.high;
      case 'urgent':
        return GrievancePriority.urgent;
      case 'low':
        return GrievancePriority.low;
      default:
        return GrievancePriority.medium;
    }
  }
}
