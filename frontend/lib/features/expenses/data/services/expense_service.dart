import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final DioClient _dioClient;

  ExpenseService(this._dioClient);

  /// Récupère toutes les dépenses d'un magasin
  Future<List<ExpenseModel>> getExpensesByStore(String storeId) async {
    try {
      final response = await _dioClient.get(
        '/expenses',
        queryParameters: {'storeId': storeId},
      );

      final List<dynamic> expensesData = response.data;
      return expensesData
          .map((json) => ExpenseModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Crée une nouvelle dépense
  Future<ExpenseModel> createExpense({
    required String storeId,
    required String category,
    required String description,
    required String amount,
    required String paymentMethod,
    String? reference,
    String? notes,
    required String createdBy,
  }) async {
    try {
      final response = await _dioClient.post(
        '/expenses',
        data: {
          'storeId': storeId,
          'category': category,
          'description': description,
          'amount': amount,
          'paymentMethod': paymentMethod,
          'reference': reference,
          'notes': notes,
          'createdBy': createdBy,
        },
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Met à jour une dépense
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required String category,
    required String description,
    required String amount,
    required String paymentMethod,
    String? reference,
    String? notes,
  }) async {
    try {
      final response = await _dioClient.put(
        '/expenses/$expenseId',
        data: {
          'category': category,
          'description': description,
          'amount': amount,
          'paymentMethod': paymentMethod,
          'reference': reference,
          'notes': notes,
        },
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Supprime une dépense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _dioClient.delete('/expenses/$expenseId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Approuve une dépense
  Future<ExpenseModel> approveExpense({
    required String expenseId,
    required String approvedBy,
  }) async {
    try {
      final response = await _dioClient.post(
        '/expenses/$expenseId/approve',
        data: {'approvedBy': approvedBy},
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Rejette une dépense
  Future<ExpenseModel> rejectExpense({
    required String expenseId,
    required String reason,
  }) async {
    try {
      final response = await _dioClient.post(
        '/expenses/$expenseId/reject',
        data: {'reason': reason},
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Annule une dépense
  Future<ExpenseModel> cancelExpense(String expenseId) async {
    try {
      final response = await _dioClient.post(
        '/expenses/$expenseId/cancel',
      );

      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gestion des erreurs Dio
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Délai d\'attente dépassé. Vérifiez votre connexion.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Erreur serveur';
        return Exception('Erreur $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Requête annulée');
      default:
        return Exception('Erreur de connexion: ${e.message}');
    }
  }
}
