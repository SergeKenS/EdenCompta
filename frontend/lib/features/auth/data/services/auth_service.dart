import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  /// Effectue la connexion avec username/password
  Future<LoginResponseModel> login(String username, String password) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);
      
      if (loginResponse.success && loginResponse.token != null) {
        // Sauvegarder le token et l'utilisateur
        await _saveAuthData(loginResponse.token!, loginResponse.user!);
      }

      return loginResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
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

  /// Change le mot de passe
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = getCurrentUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      await _dioClient.post(
        '/auth/change-password',
        data: {
          'userId': user.id,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gestion des erreurs Dio
  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return Exception(data['message']);
      }
      return Exception('Erreur serveur: ${e.response!.statusCode}');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('Connexion timeout');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return Exception('Timeout de réception');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('Erreur de connexion au serveur');
    } else {
      return Exception('Erreur réseau: ${e.message}');
    }
  }
}
