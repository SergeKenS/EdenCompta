import '../models/login_response_model.dart';
import '../models/user_model.dart';

/// Interface commune pour tous les services d'authentification
abstract class AuthServiceInterface {
  /// Effectue la connexion avec username/password
  Future<LoginResponseModel> login(String username, String password);
  
  /// Déconnecte l'utilisateur
  Future<void> logout();
  
  /// Vérifie si l'utilisateur est connecté
  bool isLoggedIn();
  
  /// Récupère l'utilisateur connecté
  UserModel? getCurrentUser();
  
  /// Récupère le token actuel
  String? getCurrentToken();
  
  /// Change le mot de passe
  Future<void> changePassword(String currentPassword, String newPassword);
}
