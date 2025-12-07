class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://yqrcscudifobekkitfta.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlxcmNzY3VkaWZvYmVra2l0ZnRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNDQzMTksImV4cCI6MjA4MDYyMDMxOX0.AtQFiQtF9StUOct4h2oPk-6N2TJ4uaBRG-QOjYs71Nc';

  // Legacy API Configuration (kept for backward compatibility during migration)
  static const String baseUrl = 'http://localhost:3000/api';

  // App Configuration
  static const String appName = 'Athletica';
  static const String appVersion = '1.0.0';

  // API Endpoints (legacy - will be replaced by Supabase)
  static const String authSignUp = '/auth/signup';
  static const String authSignIn = '/auth/signin';
  static const String authSignOut = '/auth/signout';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authGoogleSignIn = '/auth/google-signin';
  static const String authFacebookSignIn = '/auth/facebook-signin';
  static const String authAppleSignIn = '/auth/apple-signin';

  static const String coachProfile = '/coaches/profile';
  static const String clients = '/clients';
  static const String plans = '/plans';
  static const String analytics = '/analytics/dashboard';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Development Mode - Set to false for production
  static const bool useMockApi = false; // Changed to false to use Supabase backend
}
