class AppConfig {
  // Backend Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  
  // For production, update this to your deployed backend URL
  // static const String baseUrl = 'https://your-backend-domain.com/api';
  
  // App Configuration
  static const String appName = 'Athletica';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String authSignUp = '/auth/signup';
  static const String authSignIn = '/auth/signin';
  static const String authSignOut = '/auth/signout';
  
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
}
