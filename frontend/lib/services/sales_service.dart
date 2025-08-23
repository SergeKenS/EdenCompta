import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decimal/decimal.dart';

import 'package:comptab_pos/models/sales.dart';
import 'package:comptab_pos/services/api_service.dart';

/// Helper pour convertir dynamiques / num / String en Decimal.
Decimal _dec(dynamic v) {
  if (v is Decimal) return v;
  if (v is num || v is String) return Decimal.parse(v.toString());
  throw ArgumentError('Expected Decimal/num/String, got ${v.runtimeType}');
}



class SalesService {
  final ApiService _apiService;

  SalesService(this._apiService);

  // Créer un nouveau reçu
  Future<Receipt?> createReceipt({
    required String storeId,
    required String createdBy,
    required String receiptNumber,
    String? sourceOfflineId,
  }) async {
    try {
      final response = await _apiService.post(
        '/sales/receipts',
        queryParameters: {
          'storeId': storeId,
          'createdBy': createdBy,
          'receiptNumber': receiptNumber,
          if (sourceOfflineId != null) 'sourceOfflineId': sourceOfflineId,
        },
      );

      if (response.statusCode == 201) {
        return Receipt.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter une ligne au reçu
  Future<bool> addLine({
    required String receiptId,
    required String variantId,
    required Decimal quantity,
    required Decimal unitPrice,
  }) async {
    try {
      final response = await _apiService.post(
        '/sales/receipts/$receiptId/lines',
        queryParameters: {
          'variantId': variantId,
          'quantity': quantity.toString(),
          'unitPrice': unitPrice.toString(),
        },
      );

      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  // Finaliser un reçu
  Future<Receipt?> finalizeReceipt({
    required String receiptId,
    required String finalizedBy,
  }) async {
    try {
      final response = await _apiService.post(
        '/sales/receipts/$receiptId/finalize',
        queryParameters: {
          'finalizedBy': finalizedBy,
        },
      );

      if (response.statusCode == 200) {
        return Receipt.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Ajouter un paiement
  Future<bool> addPayment({
    required String receiptId,
    required PaymentMethod method,
    required Decimal amount,
    String? reference,
  }) async {
    try {
      final response = await _apiService.post(
        '/sales/receipts/$receiptId/payments',
        queryParameters: {
          'method': method.name,
          'amount': amount.toString(),
          if (reference != null) 'reference': reference,
        },
      );

      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir un reçu par ID
  Future<Receipt?> getReceipt(String receiptId) async {
    try {
      final response = await _apiService.get('/sales/receipts/$receiptId');

      if (response.statusCode == 200) {
        return Receipt.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Lister les reçus d'un magasin
  Future<List<Receipt>> listReceipts(String storeId) async {
    try {
      final response = await _apiService.get(
        '/sales/receipts',
        queryParameters: {
          'storeId': storeId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Receipt.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Calculer le total des ventes pour une période
  Future<Decimal> getTotalSales({
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final receipts = await listReceipts(storeId);

      final filteredReceipts = receipts.where(
        (r) =>
            r.createdAt.isAfter(startDate) &&
            r.createdAt.isBefore(endDate) &&
            r.status == ReceiptStatus.finalized,
      );

      return filteredReceipts.fold<Decimal>(
        Decimal.zero,
        (Decimal sum, Receipt r) => sum + _dec(r.total),
      );
    } catch (e) {
      rethrow;
    }
  }

  // Obtenir les statistiques de vente
  Future<SalesStatistics> getSalesStatistics({
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final receipts = await listReceipts(storeId);

      final filteredReceipts = receipts.where(
        (r) =>
            r.createdAt.isAfter(startDate) &&
            r.createdAt.isBefore(endDate) &&
            r.status == ReceiptStatus.finalized,
      );

      final Decimal totalSales = filteredReceipts.fold<Decimal>(
        Decimal.zero,
        (Decimal sum, Receipt r) => sum + _dec(r.total),
      );

      final Decimal totalItems = filteredReceipts.fold<Decimal>(
        Decimal.zero,
        (Decimal sum, Receipt r) {
          final Decimal perReceiptQty = r.lines.fold<Decimal>(
            Decimal.zero,
            (Decimal lineSum, ReceiptLine line) => lineSum + _dec(line.quantity),
          );
          return sum + perReceiptQty;
        },
      );

      final Decimal averageTicket = filteredReceipts.isNotEmpty
          ? (totalSales / Decimal.fromInt(filteredReceipts.length)) as Decimal
          : Decimal.zero;

      return SalesStatistics(
        totalSales: totalSales,
        totalItems: totalItems,
        averageTicket: averageTicket,
        receiptCount: filteredReceipts.length,
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Statistiques de vente
class SalesStatistics {
  final Decimal totalSales;
  final Decimal totalItems;
  final Decimal averageTicket;
  final int receiptCount;

  const SalesStatistics({
    required this.totalSales,
    required this.totalItems,
    required this.averageTicket,
    required this.receiptCount,
  });
}

// Provider pour SalesService
final salesServiceProvider = Provider<SalesService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SalesService(apiService);
});

// Provider pour l'état des ventes
final salesStateProvider =
    StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  final salesService = ref.read(salesServiceProvider);
  return SalesNotifier(salesService);
});

// État des ventes
class SalesState {
  final bool isLoading;
  final List<Receipt> receipts;
  final Receipt? currentReceipt;
  final String? error;
  final SalesStatistics? statistics;

  const SalesState({
    this.isLoading = false,
    this.receipts = const [],
    this.currentReceipt,
    this.error,
    this.statistics,
  });

  SalesState copyWith({
    bool? isLoading,
    List<Receipt>? receipts,
    Receipt? currentReceipt,
    String? error,
    SalesStatistics? statistics,
  }) {
    return SalesState(
      isLoading: isLoading ?? this.isLoading,
      receipts: receipts ?? this.receipts,
      currentReceipt: currentReceipt ?? this.currentReceipt,
      error: error ?? this.error,
      statistics: statistics ?? this.statistics,
    );
  }
}

// Notifier pour l'état des ventes
class SalesNotifier extends StateNotifier<SalesState> {
  final SalesService _salesService;

  SalesNotifier(this._salesService) : super(const SalesState());

  Future<void> loadReceipts(String storeId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final receipts = await _salesService.listReceipts(storeId);
      state = state.copyWith(
        isLoading: false,
        receipts: receipts,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createReceipt({
    required String storeId,
    required String createdBy,
    required String receiptNumber,
    String? sourceOfflineId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final receipt = await _salesService.createReceipt(
        storeId: storeId,
        createdBy: createdBy,
        receiptNumber: receiptNumber,
        sourceOfflineId: sourceOfflineId,
      );

      if (receipt != null) {
        state = state.copyWith(
          isLoading: false,
          currentReceipt: receipt,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Impossible de créer le reçu',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addLineToReceipt({
    required String variantId,
    required Decimal quantity,
    required Decimal unitPrice,
  }) async {
    if (state.currentReceipt == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _salesService.addLine(
        receiptId: state.currentReceipt!.id,
        variantId: variantId,
        quantity: quantity,
        unitPrice: unitPrice,
      );

      if (success) {
        // Recharger le reçu actuel
        final updatedReceipt =
            await _salesService.getReceipt(state.currentReceipt!.id);
        if (updatedReceipt != null) {
          state = state.copyWith(
            isLoading: false,
            currentReceipt: updatedReceipt,
            error: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'Reçu introuvable après ajout de ligne',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Impossible d\'ajouter la ligne',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> finalizeReceipt(String finalizedBy) async {
    if (state.currentReceipt == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final receipt = await _salesService.finalizeReceipt(
        receiptId: state.currentReceipt!.id,
        finalizedBy: finalizedBy,
      );

      if (receipt != null) {
        state = state.copyWith(
          isLoading: false,
          currentReceipt: receipt,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Impossible de finaliser le reçu',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
