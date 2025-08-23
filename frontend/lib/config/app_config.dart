class AppConfig {
  // Configuration de l'API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  
  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  // Configuration de l'application
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'COMPTAB POS',
  );
  
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );
  
  static const String appEnvironment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'development',
  );

  // Configuration de la base de données locale
  static const String hiveDbName = String.fromEnvironment(
    'HIVE_DB_NAME',
    defaultValue: 'comptab_pos_db',
  );
  
  static const int hiveDbVersion = int.fromEnvironment(
    'HIVE_DB_VERSION',
    defaultValue: 1,
  );

  // Configuration des notifications
  static const bool notificationsEnabled = bool.fromEnvironment(
    'NOTIFICATIONS_ENABLED',
    defaultValue: true,
  );
  
  static const String notificationsChannelId = String.fromEnvironment(
    'NOTIFICATIONS_CHANNEL_ID',
    defaultValue: 'comptab_pos_channel',
  );
  
  static const String notificationsChannelName = String.fromEnvironment(
    'NOTIFICATIONS_CHANNEL_NAME',
    defaultValue: 'COMPTAB POS',
  );

  // Configuration de la sécurité
  static const int jwtRefreshThreshold = int.fromEnvironment(
    'JWT_REFRESH_THRESHOLD',
    defaultValue: 300000, // 5 minutes
  );
  
  static const bool biometricAuthEnabled = bool.fromEnvironment(
    'BIOMETRIC_AUTH_ENABLED',
    defaultValue: false,
  );

  // Configuration du cache
  static const int cacheMaxSize = int.fromEnvironment(
    'CACHE_MAX_SIZE',
    defaultValue: 100,
  );
  
  static const int cacheExpiryHours = int.fromEnvironment(
    'CACHE_EXPIRY_HOURS',
    defaultValue: 24,
  );

  // Configuration des logs
  static const String logLevel = String.fromEnvironment(
    'LOG_LEVEL',
    defaultValue: 'debug',
  );
  
  static const bool logToFile = bool.fromEnvironment(
    'LOG_TO_FILE',
    defaultValue: false,
  );

  // Méthodes utilitaires
  static bool get isDevelopment => appEnvironment == 'development';
  static bool get isProduction => appEnvironment == 'production';
  static bool get isTest => appEnvironment == 'test';

  static String get apiUrl => apiBaseUrl;
  static String get wsUrl => apiBaseUrl.replaceFirst('http', 'ws');

  // Configuration par environnement
  static Map<String, dynamic> get environmentConfig {
    switch (appEnvironment) {
      case 'development':
        return {
          'apiUrl': 'http://localhost:8080/api',
          'wsUrl': 'ws://localhost:8080/ws',
          'debugMode': true,
          'logLevel': 'debug',
        };
      case 'test':
        return {
          'apiUrl': 'http://test-server:8080/api',
          'wsUrl': 'ws://test-server:8080/ws',
          'debugMode': true,
          'logLevel': 'info',
        };
      case 'production':
        return {
          'apiUrl': 'https://api.comptab.com/api',
          'wsUrl': 'wss://api.comptab.com/ws',
          'debugMode': false,
          'logLevel': 'warning',
        };
      default:
        return {
          'apiUrl': 'http://localhost:8080/api',
          'wsUrl': 'ws://localhost:8080/ws',
          'debugMode': true,
          'logLevel': 'debug',
        };
    }
  }
}
