import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  DateTimeRange? _selectedRange;
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _minExpenseDate;
  DateTime _maxExpenseDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: storeId réel
      const storeId = 'store-001';
      final expenses = await ref.read(expenseServiceProvider).getExpensesByStore(storeId);
      final minDate = expenses.isEmpty
          ? null
          : expenses.map((e) => e.expenseDate).reduce((a, b) => a.isBefore(b) ? a : b);
      setState(() {
        _minExpenseDate = minDate;
        _maxExpenseDate = DateTime.now();
        _expenses = _filterByCurrentDay(expenses);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<ExpenseModel> _filterByCurrentDay(List<ExpenseModel> all) {
    final now = DateTime.now();
    return all.where((e) =>
      e.expenseDate.year == now.year &&
      e.expenseDate.month == now.month &&
      e.expenseDate.day == now.day
    ).toList();
  }

  List<ExpenseModel> _filterByRange(List<ExpenseModel> all, DateTimeRange range) {
    final start = DateTime(range.start.year, range.start.month, range.start.day);
    final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);
    return all.where((e) => e.expenseDate.isAfter(start.subtract(const Duration(seconds: 1))) && e.expenseDate.isBefore(end.add(const Duration(seconds: 1)))).toList();
  }

  Future<void> _pickDateRange() async {
    final initialStart = _selectedRange?.start ?? DateTime.now();
    final initialEnd = _selectedRange?.end ?? DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: _minExpenseDate ?? DateTime(2020),
      lastDate: _maxExpenseDate,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      helpText: 'Sélectionner une plage de dates',
      saveText: 'Appliquer',
    );
    if (picked != null) {
      if (picked.start.isAfter(picked.end)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plage invalide: début après la fin')),
        );
        return;
      }
      setState(() {
        _selectedRange = picked;
      });
      // Recharger depuis la source et filtrer par range
      try {
        const storeId = 'store-001';
        final all = await ref.read(expenseServiceProvider).getExpensesByStore(storeId);
        setState(() {
          _expenses = _filterByRange(all, picked);
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dépenses'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            tooltip: 'Filtrer par dates',
            onPressed: _pickDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExpenses,
          ),
        ],
      ),
      body: _buildExpensesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddExpense,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Dépense'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildExpensesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedRange == null ? 'Aucune dépense aujourd\'hui' : 'Aucune dépense pour cette plage',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadExpenses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _expenses.length,
        itemBuilder: (context, index) {
          final expense = _expenses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExpenseCard(
              expense: expense,
              onTap: () => _onExpenseTap(expense),
            ),
          );
        },
      ),
    );
  }

  void _onAddExpense() {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController referenceController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    String category = 'SUPPLIES';
    String paymentMethod = 'CASH';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Nouvelle dépense', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(value: 'SUPPLIES', child: Text('Fournitures')),
                    DropdownMenuItem(value: 'TRANSPORT', child: Text('Transport')),
                    DropdownMenuItem(value: 'UTILITIES', child: Text('Services publics')),
                    DropdownMenuItem(value: 'MAINTENANCE', child: Text('Maintenance')),
                    DropdownMenuItem(value: 'MARKETING', child: Text('Marketing')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Autre')),
                  ],
                  onChanged: (v) => category = v ?? category,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Montant',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'CASH', child: Text('Espèces')),
                    DropdownMenuItem(value: 'MOBILE', child: Text('Mobile Money')),
                  ],
                  onChanged: (v) => paymentMethod = v ?? paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Méthode de paiement',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Référence (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final description = descriptionController.text.trim();
                          final amount = double.tryParse(amountController.text.trim());
                          if (description.isEmpty || amount == null || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veuillez renseigner une description et un montant valide')),
                            );
                            return;
                          }

                          try {
                            const storeId = 'store-001';
                            const createdBy = 'Utilisateur Test';
                            final created = await ref.read(expenseServiceProvider).createExpense(
                              storeId: storeId,
                              category: category,
                              description: description,
                              amount: amount.toStringAsFixed(2),
                              paymentMethod: paymentMethod,
                              reference: referenceController.text.trim().isEmpty ? null : referenceController.text.trim(),
                              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                              createdBy: createdBy,
                            );

                            setState(() {
                              if (_selectedRange != null) {
                                _expenses = _filterByRange([created, ..._expenses], _selectedRange!);
                              } else {
                                // Par défaut, on affiche le jour courant
                                final todayList = _filterByCurrentDay([created, ..._expenses]);
                                _expenses = todayList;
                              }
                            });

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Dépense ajoutée')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
                        child: const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onExpenseTap(ExpenseModel expense) {
    _showExpenseDetailsDialog(expense);
  }

  void _showExpenseDetailsDialog(ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long),
            const SizedBox(width: 8),
            const Text('Détails de la dépense'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Catégorie', expense.category),
            const SizedBox(height: 8),
            _detailRow('Description', expense.description),
            const SizedBox(height: 8),
            _detailRow('Montant', '${expense.amount}'),
            const SizedBox(height: 8),
            _detailRow('Paiement', expense.paymentMethod),
            const SizedBox(height: 8),
            if (expense.reference != null && expense.reference!.isNotEmpty)
              _detailRow('Référence', expense.reference!),
            const SizedBox(height: 8),
            _detailRow('Date', '${expense.expenseDate}'),
            const SizedBox(height: 8),
            if (expense.notes != null && expense.notes!.isNotEmpty)
              _detailRow('Notes', expense.notes!),
            const SizedBox(height: 8),
            _detailRow('Statut', expense.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmDeleteExpense(expense);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Supprimer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _editExpense(expense);
            },
            child: const Text('Modifier'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteExpense(ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la dépense'),
        content: const Text('Voulez-vous vraiment supprimer cette dépense ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(expenseServiceProvider).deleteExpense(expense.id);
                setState(() {
                  _expenses.removeWhere((e) => e.id == expense.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dépense supprimée')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _editExpense(ExpenseModel expense) {
    final TextEditingController descriptionController = TextEditingController(text: expense.description);
    final TextEditingController amountController = TextEditingController(text: expense.amount);
    final TextEditingController referenceController = TextEditingController(text: expense.reference ?? '');
    final TextEditingController notesController = TextEditingController(text: expense.notes ?? '');
    String category = expense.category;
    String paymentMethod = expense.paymentMethod;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Modifier la dépense', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  items: const [
                    DropdownMenuItem(value: 'SUPPLIES', child: Text('Fournitures')),
                    DropdownMenuItem(value: 'TRANSPORT', child: Text('Transport')),
                    DropdownMenuItem(value: 'UTILITIES', child: Text('Services publics')),
                    DropdownMenuItem(value: 'MAINTENANCE', child: Text('Maintenance')),
                    DropdownMenuItem(value: 'MARKETING', child: Text('Marketing')),
                    DropdownMenuItem(value: 'OTHER', child: Text('Autre')),
                  ],
                  onChanged: (v) => category = v ?? category,
                  decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Montant',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'CASH', child: Text('Espèces')),
                    DropdownMenuItem(value: 'MOBILE', child: Text('Mobile Money')),
                  ],
                  onChanged: (v) => paymentMethod = v ?? paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Méthode de paiement',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Référence (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final description = descriptionController.text.trim();
                          final amount = double.tryParse(amountController.text.trim());
                          if (description.isEmpty || amount == null || amount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veuillez renseigner une description et un montant valide')),
                            );
                            return;
                          }
                          try {
                            final updated = await ref.read(expenseServiceProvider).updateExpense(
                              expenseId: expense.id,
                              category: category,
                              description: description,
                              amount: amount.toStringAsFixed(2),
                              paymentMethod: paymentMethod,
                              reference: referenceController.text.trim().isEmpty ? null : referenceController.text.trim(),
                              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                            );
                            setState(() {
                              final idx = _expenses.indexWhere((e) => e.id == expense.id);
                              if (idx >= 0) {
                                _expenses[idx] = updated;
                                // Si une plage est active, on s'assure que l'élément reste dans le filtre
                                if (_selectedRange != null) {
                                  _expenses = _filterByRange(_expenses, _selectedRange!);
                                } else {
                                  _expenses = _filterByCurrentDay(_expenses);
                                }
                              }
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Dépense modifiée')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
                        child: const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
