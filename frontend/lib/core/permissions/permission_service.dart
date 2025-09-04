import '../constants/app_constants.dart';
import 'package:hive/hive.dart';

class PermissionService {
  static const String _authBox = 'auth_box';
  
  /// Vérifie si l'utilisateur a le rôle MANAGER ou ADMIN
  static bool canAccessManagerFeatures() {
    final user = _getCurrentUser();
    if (user == null) return false;
    
    final role = user.role.toUpperCase();
    return role == 'MANAGER' || role == 'ADMIN';
  }
  
  /// Vérifie si l'utilisateur peut accéder à l'interface Employés
  static bool canAccessEmployees() {
    return canAccessManagerFeatures();
  }
  
  /// Vérifie si l'utilisateur peut accéder aux Paramètres
  static bool canAccessSettings() {
    return canAccessManagerFeatures();
  }
  
  /// Vérifie si l'utilisateur peut voir la page Clients
  static bool canAccessCustomers() {
    return canAccessManagerFeatures();
  }
  
  /// Vérifie si l'utilisateur peut voir les produits les plus vendus
  static bool canAccessTopProducts() {
    return canAccessManagerFeatures();
  }
  
  /// Récupère l'utilisateur connecté depuis Hive
  static _UserData? _getCurrentUser() {
    try {
      final authBox = Hive.box(_authBox);
      final userData = authBox.get(AppConstants.userKey);
      
      if (userData != null) {
        return _UserData.fromJson(Map<String, dynamic>.from(userData));
      }
    } catch (e) {
      // En cas d'erreur, retourner null
    }
    
    return null;
  }
}

/// Classe interne pour récupérer les données utilisateur
class _UserData {
  final String role;
  
  _UserData({required this.role});
  
  factory _UserData.fromJson(Map<String, dynamic> json) {
    return _UserData(
      role: json['role'] ?? '',
    );
  }
}
