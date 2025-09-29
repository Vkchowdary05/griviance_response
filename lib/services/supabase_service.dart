import 'dart:typed_data'; // Needed for Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/errors/exceptions.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // ---------------- User Profile Operations ----------------
  static Future<Map<String, dynamic>> createUserProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _client
          .from('profiles')
          .insert(userData)
          .select('*')
          .single();

      return response;
    } catch (e) {
      throw ServerException('Failed to create user profile: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await (_client
              .from('profiles')
              .select('*') as PostgrestFilterBuilder<Map<String, dynamic>>)
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw ServerException('Failed to get user profile: ${e.toString()}');
    }
  }

  static Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await (_client.from('profiles')
              .update({...updates, 'updated_at': DateTime.now().toIso8601String()})
          as PostgrestFilterBuilder<Map<String, dynamic>>)
          .eq('id', userId);
    } catch (e) {
      throw ServerException('Failed to update user profile: ${e.toString()}');
    }
  }

  // ---------------- Grievance Operations ----------------
  static Future<Map<String, dynamic>> createGrievance(
    Map<String, dynamic> grievanceData,
  ) async {
    try {
      final response = await _client
          .from('grievances')
          .insert(grievanceData)
          .select('''
            *,
            departments:department_id(*),
            profiles:citizen_id(*),
            assigned_officer:assigned_officer_id(*)
          ''')
          .single();

      return response;
    } catch (e) {
      throw ServerException('Failed to create grievance: ${e.toString()}');
    }
  }

  static Future<List<Map<String, dynamic>>> getGrievances({
    String? citizenId,
    String? officerId,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = (_client
              .from('grievances')
              .select('''
                *,
                departments:department_id(*),
                profiles:citizen_id(*),
                assigned_officer:assigned_officer_id(*)
              ''')
              .order('created_at', ascending: false)
              .range(offset, offset + limit - 1)
          as PostgrestFilterBuilder<Map<String, dynamic>>);

      if (citizenId != null) {
        query = query.eq('citizen_id', citizenId);
      }
      if (officerId != null) {
        query = query.eq('assigned_officer_id', officerId);
      }
      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw ServerException('Failed to get grievances: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getGrievanceById(String id) async {
    try {
      final response = await (_client
              .from('grievances')
              .select('''
                *,
                departments:department_id(*),
                profiles:citizen_id(*),
                assigned_officer:assigned_officer_id(*)
              ''') as PostgrestFilterBuilder<Map<String, dynamic>>)
          .eq('id', id)
          .maybeSingle();

      return response;
    } catch (e) {
      throw ServerException('Failed to get grievance: ${e.toString()}');
    }
  }

  static Future<void> updateGrievance(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      await (_client.from('grievances').update({
        ...updates,
        'updated_at': DateTime.now().toIso8601String()
      }) as PostgrestFilterBuilder<Map<String, dynamic>>)
          .eq('id', id);
    } catch (e) {
      throw ServerException('Failed to update grievance: ${e.toString()}');
    }
  }

  // ---------------- Department Operations ----------------
  static Future<List<Map<String, dynamic>>> getDepartments() async {
    try {
      final response = (_client
              .from('departments')
              .select('*')
              .order('name') as List);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ServerException('Failed to get departments: ${e.toString()}');
    }
  }

  // ---------------- File Upload ----------------
  static Future<String> uploadFile(
    String bucket,
    String path,
    List<int> bytes, {
    String? contentType,
  }) async {
    try {
      await _client.storage.from(bucket).uploadBinary(
            path,
            Uint8List.fromList(bytes), // ✅ Convert List<int> to Uint8List
            fileOptions: FileOptions(contentType: contentType),
          );

      final url = _client.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      throw ServerException('Failed to upload file: ${e.toString()}');
    }
  }
}
