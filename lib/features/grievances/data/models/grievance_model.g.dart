// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grievance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrievanceModel _$GrievanceModelFromJson(Map<String, dynamic> json) =>
    GrievanceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      departmentId: json['departmentId'] as String,
      citizenId: json['citizenId'] as String,
      assignedOfficerId: json['assignedOfficerId'] as String?,
      status: $enumDecode(_$GrievanceStatusEnumMap, json['status']),
      priority: $enumDecode(_$GrievancePriorityEnumMap, json['priority']),
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      locationAddress: json['locationAddress'] as String?,
      imageUrl: json['imageUrl'] as String?,
      upvotes: (json['upvotes'] as num).toInt(),
      aiScore: (json['aiScore'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      departmentName: json['departmentName'] as String?,
      citizenName: json['citizenName'] as String?,
      officerName: json['officerName'] as String?,
    );

Map<String, dynamic> _$GrievanceModelToJson(GrievanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'departmentId': instance.departmentId,
      'citizenId': instance.citizenId,
      'assignedOfficerId': instance.assignedOfficerId,
      'status': _$GrievanceStatusEnumMap[instance.status]!,
      'priority': _$GrievancePriorityEnumMap[instance.priority]!,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'locationAddress': instance.locationAddress,
      'imageUrl': instance.imageUrl,
      'upvotes': instance.upvotes,
      'aiScore': instance.aiScore,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'departmentName': instance.departmentName,
      'citizenName': instance.citizenName,
      'officerName': instance.officerName,
    };

const _$GrievanceStatusEnumMap = {
  GrievanceStatus.pending: 'pending',
  GrievanceStatus.inProgress: 'inProgress',
  GrievanceStatus.resolved: 'resolved',
  GrievanceStatus.rejected: 'rejected',
};

const _$GrievancePriorityEnumMap = {
  GrievancePriority.low: 'low',
  GrievancePriority.medium: 'medium',
  GrievancePriority.high: 'high',
  GrievancePriority.urgent: 'urgent',
};
