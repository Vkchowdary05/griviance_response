import '../../../../services/supabase_service.dart';
import '../../../../services/gemini_service.dart';
import '../models/grievance_model.dart';
import '../../domain/entities/grievance_entity.dart';
import '../../../../core/errors/exceptions.dart';

abstract class GrievanceRemoteDataSource {
  Future<GrievanceModel> createGrievance({
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
  
  Future<List<GrievanceModel>> getGrievances({
    String? citizenId,
    String? officerId,
    String? status,
    int limit = 20,
    int offset = 0,
  });
  
  Future<GrievanceModel?> getGrievanceById(String id);
  Future<void> updateGrievance(String id, Map<String, dynamic> updates);
  Future<void> upvoteGrievance(String id);
  Future<String> uploadImage(List<int> bytes, String fileName);
}

class GrievanceRemoteDataSourceImpl implements GrievanceRemoteDataSource {
  @override
  Future<GrievanceModel> createGrievance({
    required String title,
    required String description,
    required String departmentId,
    required String citizenId,
    double? locationLat,
    double? locationLng,
    String? locationAddress,
    String? imageUrl,
    GrievancePriority priority = GrievancePriority.medium,
  }) async {
    try {
      // Validate with AI
      final aiScore = await GeminiService.validateGrievanceRelevance(
        title,
        description,
      );

      final grievanceData = {
        'title': title,
        'description': description,
        'department_id': departmentId,
        'citizen_id': citizenId,
        'status': 'pending',
        'priority': priority.value,
        'location_lat': locationLat,
        'location_lng': locationLng,
        'location_address': locationAddress,
        'image_url': imageUrl,
        'upvotes': 0,
        'ai_score': aiScore,
      };

      final response = await SupabaseService.createGrievance(grievanceData);
      return GrievanceModel.fromSupabase(response);
    } catch (e) {
      throw ServerException('Failed to create grievance: ${e.toString()}');
    }
  }

  @override
  Future<List<GrievanceModel>> getGrievances({
    String? citizenId,
    String? officerId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await SupabaseService.getGrievances(
        citizenId: citizenId,
        officerId: officerId,
        status: status,
        limit: limit,
        offset: offset,
      );

      return response.map((json) => GrievanceModel.fromSupabase(json)).toList();
    } catch (e) {
      throw ServerException('Failed to get grievances: ${e.toString()}');
    }
  }

  @override
  Future<GrievanceModel?> getGrievanceById(String id) async {
    try {
      final response = await SupabaseService.getGrievanceById(id);
      return response != null ? GrievanceModel.fromSupabase(response) : null;
    } catch (e) {
      throw ServerException('Failed to get grievance: ${e.toString()}');
    }
  }

  @override
  Future<void> updateGrievance(String id, Map<String, dynamic> updates) async {
    try {
      await SupabaseService.updateGrievance(id, updates);
    } catch (e) {
      throw ServerException('Failed to update grievance: ${e.toString()}');
    }
  }

  @override
  Future<void> upvoteGrievance(String id) async {
    try {
      // Get current grievance to increment upvotes
      final grievance = await SupabaseService.getGrievanceById(id);
      if (grievance != null) {
        final currentUpvotes = grievance['upvotes'] as int? ?? 0;
        await SupabaseService.updateGrievance(id, {
          'upvotes': currentUpvotes + 1,
        });
      }
    } catch (e) {
      throw ServerException('Failed to upvote grievance: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadImage(List<int> bytes, String fileName) async {
    try {
      return await SupabaseService.uploadFile(
        'grievance-images',
        fileName,
        bytes,
        contentType: 'image/jpeg',
      );
    } catch (e) {
      throw ServerException('Failed to upload image: ${e.toString()}');
    }
  }
}
