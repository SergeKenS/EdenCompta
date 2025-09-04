import '../models/expense_model.dart';

class DevExpenseService {
  /// Récupère des dépenses fictives pour le développement
  Future<List<ExpenseModel>> getExpensesByStore(String storeId) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      ExpenseModel(
        id: 'exp-001',
        storeId: storeId,
        category: 'SUPPLIES',
        description: 'Fournitures de bureau - Papeterie et cartouches',
        amount: '45.50',
        paymentMethod: 'CARD',
        reference: 'FACT-2024-001',
        notes: 'Commande mensuelle de fournitures',
        expenseDate: DateTime.now().subtract(const Duration(days: 2)),
        approvedBy: 'Jean Dupont',
        approvedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: 'APPROVED',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        createdBy: 'Marie Martin',
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ExpenseModel(
        id: 'exp-002',
        storeId: storeId,
        category: 'TRANSPORT',
        description: 'Essence pour livraisons - 50L',
        amount: '78.25',
        paymentMethod: 'CASH',
        reference: 'TICKET-ESSENCE-001',
        notes: 'Ravitaillement véhicule de livraison',
        expenseDate: DateTime.now().subtract(const Duration(days: 1)),
        approvedBy: null,
        approvedAt: null,
        status: 'PENDING',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'Pierre Durand',
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ExpenseModel(
        id: 'exp-003',
        storeId: storeId,
        category: 'MAINTENANCE',
        description: 'Réparation imprimante - Pièces et main d\'œuvre',
        amount: '120.00',
        paymentMethod: 'CARD',
        reference: 'FACT-MAINT-2024-003',
        notes: 'Remplacement du tambour et nettoyage complet',
        expenseDate: DateTime.now().subtract(const Duration(days: 5)),
        approvedBy: 'Jean Dupont',
        approvedAt: DateTime.now().subtract(const Duration(days: 4)),
        status: 'APPROVED',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        createdBy: 'Sophie Bernard',
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      ExpenseModel(
        id: 'exp-004',
        storeId: storeId,
        category: 'MARKETING',
        description: 'Publicité Facebook - Campagne promotionnelle',
        amount: '200.00',
        paymentMethod: 'CARD',
        reference: 'FB-ADS-2024-001',
        notes: 'Campagne de 2 semaines pour nouveaux produits',
        expenseDate: DateTime.now().subtract(const Duration(days: 7)),
        approvedBy: null,
        approvedAt: null,
        status: 'PENDING',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        createdBy: 'Marie Martin',
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
      ExpenseModel(
        id: 'exp-005',
        storeId: storeId,
        category: 'UTILITIES',
        description: 'Électricité - Facture mensuelle',
        amount: '156.80',
        paymentMethod: 'MOBILE',
        reference: 'EDF-2024-03',
        notes: 'Paiement par application mobile',
        expenseDate: DateTime.now().subtract(const Duration(days: 10)),
        approvedBy: 'Jean Dupont',
        approvedAt: DateTime.now().subtract(const Duration(days: 9)),
        status: 'APPROVED',
        createdAt: DateTime.now().subtract(const Duration(days: 11)),
        createdBy: 'Pierre Durand',
        updatedAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
    ];
  }

  /// Crée une nouvelle dépense fictive
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
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    return ExpenseModel(
      id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
      storeId: storeId,
      category: category,
      description: description,
      amount: amount,
      paymentMethod: paymentMethod,
      reference: reference,
      notes: notes,
      expenseDate: DateTime.now(),
      approvedBy: null,
      approvedAt: null,
      status: 'PENDING',
      createdAt: DateTime.now(),
      createdBy: createdBy,
      updatedAt: DateTime.now(),
    );
  }

  /// Met à jour une dépense fictive
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required String category,
    required String description,
    required String amount,
    required String paymentMethod,
    String? reference,
    String? notes,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Retourner une dépense mise à jour (en réalité, on devrait récupérer l'existante)
    return ExpenseModel(
      id: expenseId,
      storeId: 'store-001', // Temporaire
      category: category,
      description: description,
      amount: amount,
      paymentMethod: paymentMethod,
      reference: reference,
      notes: notes,
      expenseDate: DateTime.now(),
      approvedBy: null,
      approvedAt: null,
      status: 'PENDING',
      createdAt: DateTime.now(),
      createdBy: 'Utilisateur Test',
      updatedAt: DateTime.now(),
    );
  }

  /// Supprime une dépense fictive
  Future<void> deleteExpense(String expenseId) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 300));
    // En mode test, on ne fait rien
  }

  /// Approuve une dépense fictive
  Future<ExpenseModel> approveExpense({
    required String expenseId,
    required String approvedBy,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Retourner une dépense approuvée
    return ExpenseModel(
      id: expenseId,
      storeId: 'store-001', // Temporaire
      category: 'SUPPLIES', // Temporaire
      description: 'Dépense approuvée', // Temporaire
      amount: '100.00', // Temporaire
      paymentMethod: 'CARD', // Temporaire
      reference: null,
      notes: null,
      expenseDate: DateTime.now(),
      approvedBy: approvedBy,
      approvedAt: DateTime.now(),
      status: 'APPROVED',
      createdAt: DateTime.now(),
      createdBy: 'Utilisateur Test',
      updatedAt: DateTime.now(),
    );
  }

  /// Rejette une dépense fictive
  Future<ExpenseModel> rejectExpense({
    required String expenseId,
    required String reason,
  }) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Retourner une dépense rejetée
    return ExpenseModel(
      id: expenseId,
      storeId: 'store-001', // Temporaire
      category: 'SUPPLIES', // Temporaire
      description: 'Dépense rejetée', // Temporaire
      amount: '100.00', // Temporaire
      paymentMethod: 'CARD', // Temporaire
      reference: null,
      notes: 'Rejeté: $reason',
      expenseDate: DateTime.now(),
      approvedBy: null,
      approvedAt: null,
      status: 'REJECTED',
      createdAt: DateTime.now(),
      createdBy: 'Utilisateur Test',
      updatedAt: DateTime.now(),
    );
  }

  /// Annule une dépense fictive
  Future<ExpenseModel> cancelExpense(String expenseId) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Retourner une dépense annulée
    return ExpenseModel(
      id: expenseId,
      storeId: 'store-001', // Temporaire
      category: 'SUPPLIES', // Temporaire
      description: 'Dépense annulée', // Temporaire
      amount: '100.00', // Temporaire
      paymentMethod: 'CARD', // Temporaire
      reference: null,
      notes: null,
      expenseDate: DateTime.now(),
      approvedBy: null,
      approvedAt: null,
      status: 'CANCELLED',
      createdAt: DateTime.now(),
      createdBy: 'Utilisateur Test',
      updatedAt: DateTime.now(),
    );
  }
}
