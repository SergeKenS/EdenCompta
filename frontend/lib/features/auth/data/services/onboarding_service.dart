import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class OnboardingService {
  final DioClient _dioClient;

  OnboardingService(this._dioClient);

  /// Crée un nouveau magasin et son manager (premier utilisateur admin)
  Future<OnboardingResponse> createStoreAndManager({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String storeName,
    String? storeAddress,
    String? storePhone,
  }) async {
    try {
      // 1. Créer le magasin d'abord
      final storeResponse = await _dioClient.post(
        '/stores',
        data: {
          'name': storeName,
          'address': storeAddress,
          'phone': storePhone,
          'status': 'ACTIVE',
        },
      );

      final storeId = storeResponse.data['id'];

      // 2. Créer l'utilisateur admin pour ce magasin
      final userResponse = await _dioClient.post(
        '/users',
        data: {
          'username': email, // Email utilisé comme username
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'role': 'ADMIN',
          'storeId': storeId,
          'createdBy': 'SYSTEM',
        },
      );

      // 3. Activer le compte immédiatement (pour le premier admin)
      final userId = userResponse.data['id'];
      await _dioClient.post('/users/$userId/activate');

      return OnboardingResponse(
        success: true,
        message: 'Magasin et compte manager créés avec succès',
        storeId: storeId,
        user: UserModel.fromJson(userResponse.data),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Vérifie si un email est disponible
  Future<bool> isEmailAvailable(String email) async {
    try {
      final response = await _dioClient.get('/users/check-email?email=$email');
      return response.data['available'] ?? false;
    } on DioException catch (e) {
      // Si erreur 404, l'email est disponible
      if (e.response?.statusCode == 404) {
        return true;
      }
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

class OnboardingResponse {
  final bool success;
  final String message;
  final String? storeId;
  final UserModel? user;

  OnboardingResponse({
    required this.success,
    required this.message,
    this.storeId,
    this.user,
  });
}
