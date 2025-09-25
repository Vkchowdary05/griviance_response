class ApiConstants {
  // Base URLs
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // API Endpoints
  static const String profilesEndpoint = '/profiles';
  static const String grievancesEndpoint = '/grievances';
  static const String departmentsEndpoint = '/departments';
  
  // Storage Buckets
  static const String grievanceImagesBucket = 'grievance-images';
  static const String profileImagesBucket = 'profile-images';
  
  // External APIs
  static const String geminiApiUrl = 'https://generativelanguage.googleapis.com';
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
  
  // Request Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload Limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Timeouts
  static const int connectionTimeoutMs = 30000; // 30 seconds
  static const int receiveTimeoutMs = 30000; // 30 seconds
}
