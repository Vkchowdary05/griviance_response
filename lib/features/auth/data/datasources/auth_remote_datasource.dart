import '../../../../services/firebase_service.dart';
import '../../../../services/supabase_service.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? department,
    String? phone,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> updateProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Sign in with Firebase
      final firebaseUser = await FirebaseService.signInWithEmailPassword(
        email,
        password,
      );
      
      // Get user profile from Supabase
      final profileData = await SupabaseService.getUserProfile(firebaseUser.uid);
      
      if (profileData == null) {
        throw const ServerException('User profile not found');
      }
      
      return UserModel.fromSupabase(profileData);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? department,
    String? phone,
  }) async {
    try {
      // Create Firebase user
      final firebaseUser = await FirebaseService.createUserWithEmailPassword(
        email,
        password,
      );
      
      // Create Supabase profile
      final userData = {
        'id': firebaseUser.uid,
        'email': email,
        'full_name': fullName,
        'role': role.value,
        'department': department,
        'phone': phone,
      };
      
      final profileData = await SupabaseService.createUserProfile(userData);
      
      return UserModel.fromSupabase(profileData);
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseService.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = FirebaseService.getCurrentUser();
      
      if (firebaseUser == null) {
        return null;
      }
      
      final profileData = await SupabaseService.getUserProfile(firebaseUser.uid);
      
      if (profileData == null) {
        return null;
      }
      
      return UserModel.fromSupabase(profileData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    try {
      await SupabaseService.updateUserProfile(
        user.id,
        user.toSupabase(),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
