import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/sale_model.dart';

class SalesService {
  final DioClient _dioClient;

  SalesService(this._dioClient);

  /// Récupère les ventes avec pagination et filtres
  Future<List<SaleModel>> getSales({
    int page = 0,
    int size = 20,
    String? status,
    String? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (status != null) queryParams['status'] = status;
      if (paymentMethod != null) queryParams['paymentMethod'] = paymentMethod;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _dioClient.get(
        '/sales',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['content'] ?? response.data;
      return data.map((json) => SaleModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère une vente par ID
  Future<SaleModel> getSale(String saleId) async {
    try {
      final response = await _dioClient.get('/sales/$saleId');
      return SaleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Crée une nouvelle vente
  Future<SaleModel> createSale(CreateSaleRequest saleRequest) async {
    try {
      final response = await _dioClient.post(
        '/sales',
        data: saleRequest.toJson(),
      );
      return SaleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Annule une vente
  Future<SaleModel> cancelSale(String saleId, String reason) async {
    try {
      final response = await _dioClient.post(
        '/sales/$saleId/cancel',
        data: {'reason': reason},
      );
      return SaleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Met à jour une vente
  Future<SaleModel> updateSale(String saleId, Map<String, dynamic> updateData) async {
    try {
      final response = await _dioClient.put(
        '/sales/$saleId',
        data: updateData,
      );
      return SaleModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère les statistiques de ventes
  Future<Map<String, dynamic>> getSalesStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _dioClient.get(
        '/sales/stats',
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère les ventes par session de caisse
  Future<List<SaleModel>> getSalesBySession(String sessionId) async {
    try {
      final response = await _dioClient.get('/sales/session/$sessionId');
      final List<dynamic> data = response.data;
      return data.map((json) => SaleModel.fromJson(json)).toList();
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
