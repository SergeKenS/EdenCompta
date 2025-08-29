import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor pour ajouter le token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final box = Hive.box(AppConstants.authBox);
          final token = box.get(AppConstants.tokenKey);
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          _logger.d('Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          _logger.e('Message: ${error.message}');
          _logger.e('Data: ${error.response?.data}');
          
          // Gérer l'expiration du token
          if (error.response?.statusCode == 401) {
            _handleTokenExpiration();
          }
          
          handler.next(error);
        },
      ),
    );

    // Logging interceptor pour le debug
    if (true) { // Enable in debug mode
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => _logger.d(log),
      ));
    }
  }

  void _handleTokenExpiration() {
    final box = Hive.box(AppConstants.authBox);
    box.delete(AppConstants.tokenKey);
    box.delete(AppConstants.userKey);
    // TODO: Rediriger vers la page de connexion
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Méthode pour mettre à jour le token
  void updateToken(String token) {
    final box = Hive.box(AppConstants.authBox);
    box.put(AppConstants.tokenKey, token);
  }

  // Méthode pour supprimer le token
  void removeToken() {
    final box = Hive.box(AppConstants.authBox);
    box.delete(AppConstants.tokenKey);
  }
}
