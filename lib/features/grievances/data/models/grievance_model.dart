import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/grievance_entity.dart';

part 'grievance_model.g.dart';

@JsonSerializable()
class GrievanceModel extends GrievanceEntity {
  const GrievanceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.departmentId,
    required super.citizenId,
    super.assignedOfficerId,
    required super.status,
    required super.priority,
    super.locationLat,
    super.locationLng,
    super.locationAddress,
    super.imageUrl,
    required super.upvotes,
    required super.aiScore,
    required super.createdAt,
    required super.updatedAt,
    super.departmentName,
    super.citizenName,
    super.officerName,
  });

  factory GrievanceModel.fromJson(Map<String, dynamic> json) =>
      _$GrievanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrievanceModelToJson(this);

  factory GrievanceModel.fromSupabase(Map<String, dynamic> json) {
    return GrievanceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      departmentId: json['department_id'] as String,
      citizenId: json['citizen_id'] as String,
      assignedOfficerId: json['assigned_officer_id'] as String?,
      status: GrievanceStatusExtension.fromString(json['status'] as String),
      priority: GrievancePriorityExtension.fromString(json['priority'] as String),
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      locationAddress: json['location_address'] as String?,
      imageUrl: json['image_url'] as String?,
      upvotes: json['upvotes'] as int? ?? 0,
      aiScore: (json['ai_score'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      departmentName: json['departments']?['name'] as String?,
      citizenName: json['profiles']?['full_name'] as String?,
      officerName: json['assigned_officer']?['full_name'] as String?,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'title': title,
      'description': description,
      'department_id': departmentId,
      'citizen_id': citizenId,
      'assigned_officer_id': assignedOfficerId,
      'status': status.value,
      'priority': priority.value,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'location_address': locationAddress,
      'image_url': imageUrl,
      'upvotes': upvotes,
      'ai_score': aiScore,
    };
  }
}
