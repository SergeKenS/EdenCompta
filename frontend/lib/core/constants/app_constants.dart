class AppConstants {
  // Box names pour Hive
  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';
  
  // Clés pour le stockage
  static const String tokenKey = 'jwt_token';
  static const String userKey = 'current_user';
  static const String storeKey = 'current_store';
  static const String firstLaunchKey = 'first_launch';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Polling intervals
  static const Duration dashboardPollingInterval = Duration(seconds: 5);
  
  // Pagination
  static const int defaultPageSize = 20;
}
