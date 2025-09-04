import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/dev_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'dev_auth_service.dart';

/// Service d'authentification unifié qui bascule automatiquement
/// entre le mode réel et le mode développement
class UnifiedAuthService {
  late final AuthService _realAuthService;
  late final DevAuthService _devAuthService;
  
  UnifiedAuthService(DioClient dioClient) {
    _realAuthService = AuthService(dioClient);
    _devAuthService = DevAuthService();
  }
  
  /// Retourne le service approprié selon la configuration
  dynamic get _currentService => 
      DevConfig.enableDevMode ? _devAuthService : _realAuthService;

  /// Effectue la connexion
  Future<LoginResponseModel> login(String username, String password) async {
    if (DevConfig.enableDevMode) {
      // En mode dev, utiliser des identifiants par défaut si vides
      final finalUsername = username.isEmpty ? DevConfig.defaultTestUsername : username;
      final finalPassword = password.isEmpty ? DevConfig.defaultTestPassword : password;
      return await _devAuthService.login(finalUsername, finalPassword);
    } else {
      return await _realAuthService.login(username, password);
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    return await _currentService.logout();
  }

  /// Vérifie si l'utilisateur est connecté
  bool isLoggedIn() {
    return _currentService.isLoggedIn();
  }

  /// Récupère l'utilisateur connecté
  UserModel? getCurrentUser() {
    return _currentService.getCurrentUser();
  }

  /// Récupère le token actuel
  String? getCurrentToken() {
    return _currentService.getCurrentToken();
  }

  /// Change le mot de passe
  Future<void> changePassword(String currentPassword, String newPassword) async {
    return await _currentService.changePassword(currentPassword, newPassword);
  }
}
