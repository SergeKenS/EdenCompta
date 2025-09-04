import 'package:hive/hive.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../../../../core/constants/app_constants.dart';

class DevAuthService {
  /// Effectue la connexion en mode développement (sans authentification réelle)
  Future<LoginResponseModel> login(String username, String password) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // En mode dev, on accepte n'importe quel username/password
    final user = UserModel(
      id: 'dev-user-id-${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: '$username@pos.com',
      firstName: 'Utilisateur',
      lastName: 'Test',
      role: 'SUPER_ADMIN',
      status: 'ACTIVE',
      storeId: 'dev-store-id',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final token = 'dev-token-${DateTime.now().millisecondsSinceEpoch}';
    
    // Sauvegarder les données d'authentification
    await _saveAuthData(token, user);
    
    return LoginResponseModel(
      success: true,
      message: 'Connexion réussie (mode développement)',
      user: user,
      token: token,
    );
  }

  /// Sauvegarde les données d'authentification
  Future<void> _saveAuthData(String token, UserModel user) async {
    final authBox = Hive.box(AppConstants.authBox);
    await authBox.put(AppConstants.tokenKey, token);
    await authBox.put(AppConstants.userKey, user.toJson());
    
    // Marquer que ce n'est plus le premier lancement
    final settingsBox = Hive.box(AppConstants.settingsBox);
    await settingsBox.put(AppConstants.firstLaunchKey, false);
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    final authBox = Hive.box(AppConstants.authBox);
    await authBox.clear();
  }

  /// Vérifie si l'utilisateur est connecté
  bool isLoggedIn() {
    final authBox = Hive.box(AppConstants.authBox);
    final token = authBox.get(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Récupère l'utilisateur connecté
  UserModel? getCurrentUser() {
    final authBox = Hive.box(AppConstants.authBox);
    final userData = authBox.get(AppConstants.userKey);
    
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    
    return null;
  }

  /// Récupère le token actuel
  String? getCurrentToken() {
    final authBox = Hive.box(AppConstants.authBox);
    return authBox.get(AppConstants.tokenKey);
  }

  /// Change le mot de passe de l'utilisateur
  Future<void> changePassword(String currentPassword, String newPassword) async {
    // En mode dev, on simule juste le changement de mot de passe
    await Future.delayed(const Duration(milliseconds: 300));
    // Pas de validation réelle en mode développement
  }
}
