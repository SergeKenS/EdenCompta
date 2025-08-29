import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class InventoryService {
  final DioClient _dioClient;

  InventoryService(this._dioClient);

  /// Récupère tous les produits
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int size = 20,
    String? search,
    String? category,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (isActive != null) {
        queryParams['isActive'] = isActive;
      }

      final response = await _dioClient.get(
        '/inventory/products',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['content'] ?? response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère un produit par ID
  Future<ProductModel> getProduct(String productId) async {
    try {
      final response = await _dioClient.get('/inventory/products/$productId');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Crée un nouveau produit
  Future<ProductModel> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dioClient.post(
        '/inventory/products',
        data: productData,
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Met à jour un produit
  Future<ProductModel> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      final response = await _dioClient.put(
        '/inventory/products/$productId',
        data: productData,
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Supprime un produit
  Future<void> deleteProduct(String productId) async {
    try {
      await _dioClient.delete('/inventory/products/$productId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère les variantes d'un produit
  Future<List<ProductVariantModel>> getProductVariants(String productId) async {
    try {
      final response = await _dioClient.get('/inventory/products/$productId/variants');
      final List<dynamic> data = response.data;
      return data.map((json) => ProductVariantModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Crée une nouvelle variante
  Future<ProductVariantModel> createProductVariant(Map<String, dynamic> variantData) async {
    try {
      final response = await _dioClient.post(
        '/inventory/variants',
        data: variantData,
      );
      return ProductVariantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Met à jour une variante
  Future<ProductVariantModel> updateProductVariant(String variantId, Map<String, dynamic> variantData) async {
    try {
      final response = await _dioClient.put(
        '/inventory/variants/$variantId',
        data: variantData,
      );
      return ProductVariantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Supprime une variante
  Future<void> deleteProductVariant(String variantId) async {
    try {
      await _dioClient.delete('/inventory/variants/$variantId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Met à jour le stock d'une variante
  Future<ProductVariantModel> updateStock(String variantId, int newStock, String reason) async {
    try {
      final response = await _dioClient.post(
        '/inventory/variants/$variantId/stock',
        data: {
          'newStock': newStock,
          'reason': reason,
        },
      );
      return ProductVariantModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Récupère les catégories disponibles
  Future<List<String>> getCategories() async {
    try {
      final response = await _dioClient.get('/inventory/categories');
      final List<dynamic> data = response.data;
      return data.cast<String>();
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
