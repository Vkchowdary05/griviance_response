import '../../../../services/supabase_service.dart';
import '../models/profile_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<void> updateProfile(ProfileModel profile);
  Future<String> uploadProfileImage(List<int> bytes, String fileName);
  Future<void> deleteProfile(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      final response = await SupabaseService.getUserProfile(userId);
      if (response == null) {
        throw const ServerException('Profile not found');
      }
      return ProfileModel.fromSupabase(response);
    } catch (e) {
      throw ServerException('Failed to get profile: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      await SupabaseService.updateUserProfile(profile.id, profile.toSupabase());
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage(List<int> bytes, String fileName) async {
    try {
      return await SupabaseService.uploadFile(
        'profile-images',
        fileName,
        bytes,
        contentType: 'image/jpeg',
      );
    } catch (e) {
      throw ServerException('Failed to upload profile image: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProfile(String userId) async {
    try {
      // Implementation for profile deletion if needed
      throw const ServerException('Profile deletion not implemented');
    } catch (e) {
      throw ServerException('Failed to delete profile: ${e.toString()}');
    }
  }
}

