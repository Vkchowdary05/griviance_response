class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Firebase Configuration
  static const String firebaseProjectId = 'your-project-id';
  
  // Google Gemini Configuration
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  
  // App Configuration
  static const String appName = 'Grievance System';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userPrefsKey = 'user_prefs';
  static const String tokenKey = 'auth_token';
  static const String userRoleKey = 'user_role';
  
  // Validation Constants
  static const int maxDescriptionLength = 1000;
  static const int minDescriptionLength = 10;
  static const double maxImageSizeMB = 5.0;
  
  // Status Types
  static const List<String> grievanceStatuses = [
    'pending',
    'in_progress', 
    'resolved',
    'rejected'
  ];
  
  static const List<String> priorityLevels = [
    'low',
    'medium',
    'high',
    'urgent'
  ];
}
