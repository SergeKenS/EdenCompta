import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/services/expense_service.dart';
import '../../data/models/expense_model.dart';

// Provider pour le service des dépenses (API réelle)
final expenseServiceProvider = Provider<ExpenseService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return ExpenseService(dioClient);
});

// Provider pour la liste des dépenses
final expenseListProvider = StateNotifierProvider<ExpenseListNotifier, AsyncValue<List<ExpenseModel>>>((ref) {
  final expenseService = ref.read(expenseServiceProvider);
  return ExpenseListNotifier(expenseService);
});

// Notifier pour gérer la liste des dépenses
class ExpenseListNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  final ExpenseService _expenseService;

  ExpenseListNotifier(this._expenseService) : super(const AsyncValue.loading());

  /// Charge les dépenses d'un magasin
  Future<void> loadExpenses(String storeId) async {
    state = const AsyncValue.loading();
    
    try {
      final expenses = await _expenseService.getExpensesByStore(storeId);
      state = AsyncValue.data(expenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Ajoute une nouvelle dépense
  Future<void> addExpense({
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
      final newExpense = await _expenseService.createExpense(
        storeId: storeId,
        category: category,
        description: description,
        amount: amount,
        paymentMethod: paymentMethod,
        reference: reference,
        notes: notes,
        createdBy: createdBy,
      );

      // Mettre à jour la liste
      final currentExpenses = state.value ?? [];
      state = AsyncValue.data([newExpense, ...currentExpenses]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Met à jour une dépense
  Future<void> updateExpense({
    required String expenseId,
    required String category,
    required String description,
    required String amount,
    required String paymentMethod,
    String? reference,
    String? notes,
  }) async {
    try {
      final updatedExpense = await _expenseService.updateExpense(
        expenseId: expenseId,
        category: category,
        description: description,
        amount: amount,
        paymentMethod: paymentMethod,
        reference: reference,
        notes: notes,
      );

      // Mettre à jour la liste
      final currentExpenses = state.value ?? [];
      final updatedExpenses = currentExpenses.map((expense) {
        return expense.id == expenseId ? updatedExpense : expense;
      }).toList();
      
      state = AsyncValue.data(updatedExpenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Supprime une dépense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseService.deleteExpense(expenseId);

      // Mettre à jour la liste
      final currentExpenses = state.value ?? [];
      final updatedExpenses = currentExpenses
          .where((expense) => expense.id != expenseId)
          .toList();
      
      state = AsyncValue.data(updatedExpenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
