/// Configuration pour le mode développement
class DevConfig {
  /// Active le mode développement (sans backend)
  static const bool enableDevMode = true;
  
  /// URL de base pour l'API (ignorée en mode dev)
  static const String apiBaseUrl = 'http://localhost:8080/api';
  
  /// Délai de simulation pour les opérations réseau
  static const Duration networkDelay = Duration(milliseconds: 500);
  
  /// Utilisateur de test par défaut
  static const String defaultTestUsername = 'admin';
  static const String defaultTestPassword = 'admin';
}
