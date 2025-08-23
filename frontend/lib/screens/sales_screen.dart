import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decimal/decimal.dart';
import 'package:comptab_pos/models/sales.dart';
import 'package:comptab_pos/services/sales_service.dart';
import 'package:comptab_pos/services/auth_service.dart';
import 'package:comptab_pos/widgets/navigation_drawer.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  
  Receipt? _currentReceipt;
  List<ReceiptLine> _cartItems = [];
  Decimal _total = Decimal.zero;
  String? _selectedVariantId;
  String? _selectedVariantName;
  Decimal _selectedVariantPrice = Decimal.zero;

  @override
  void initState() {
    super.initState();
    _quantityController.text = '1';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createNewReceipt() async {
    final authState = ref.read(authStateProvider);
    final user = authState.user;
    
    if (user == null) return;

    final receiptNumber = DateTime.now().millisecondsSinceEpoch.toString();
    
    await ref.read(salesStateProvider.notifier).createReceipt(
      storeId: user.storeId,
      createdBy: user.username,
      receiptNumber: receiptNumber,
    );

    final salesState = ref.read(salesStateProvider);
    setState(() {
      _currentReceipt = salesState.currentReceipt;
      _cartItems = [];
      _total = Decimal.zero;
    });
  }

  void _addToCart() {
    if (_selectedVariantId == null || _quantityController.text.isEmpty) return;

    final quantity = Decimal.tryParse(_quantityController.text) ?? Decimal.one;
    final price = _selectedVariantPrice;

    final cartItem = ReceiptLine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      receiptId: _currentReceipt?.id ?? '',
      variantId: _selectedVariantId!,
      productName: 'Produit', // TODO: Récupérer le nom du produit
      variantName: _selectedVariantName ?? '',
      quantity: quantity,
      unitPrice: price,
      taxRate: Decimal.zero, // TODO: Implémenter la gestion des taxes
      createdAt: DateTime.now(),
    );

    setState(() {
      _cartItems.add(cartItem);
      _total = _cartItems.fold(
        Decimal.zero,
        (sum, item) => sum + item.total,
      );
    });

    // Réinitialiser les champs
    _selectedVariantId = null;
    _selectedVariantName = null;
    _selectedVariantPrice = Decimal.zero;
    _quantityController.text = '1';
    _priceController.clear();
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _total = _cartItems.fold(
        Decimal.zero,
        (sum, item) => sum + item.total,
      );
    });
  }

  Future<void> _finalizeReceipt() async {
    if (_currentReceipt == null || _cartItems.isEmpty) return;

    final authState = ref.read(authStateProvider);
    final user = authState.user;
    
    if (user == null) return;

    // Ajouter toutes les lignes au reçu
    for (final item in _cartItems) {
      await ref.read(salesStateProvider.notifier).addLineToReceipt(
        variantId: item.variantId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      );
    }

    // Finaliser le reçu
    await ref.read(salesStateProvider.notifier).finalizeReceipt(user.username);

    // Afficher le reçu finalisé
    final salesState = ref.read(salesStateProvider);
    if (salesState.currentReceipt != null) {
      _showReceiptDialog(salesState.currentReceipt!);
    }

    // Réinitialiser l'écran
    setState(() {
      _currentReceipt = null;
      _cartItems = [];
      _total = Decimal.zero;
    });
  }

  void _showReceiptDialog(Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reçu finalisé'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Numéro: ${receipt.receiptNumber}'),
            Text('Total: ${receipt.total} FCFA'),
            Text('Statut: ${receipt.status.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Imprimer le reçu
            },
            child: const Text('Imprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventes'),
        actions: [
          if (_currentReceipt != null)
            TextButton.icon(
              onPressed: _finalizeReceipt,
              icon: const Icon(Icons.check),
              label: const Text('Finaliser'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      body: Row(
        children: [
          // Panneau de gauche - Création de reçus
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // En-tête
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nouvelle vente',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_currentReceipt == null)
                        ElevatedButton.icon(
                          onPressed: _createNewReceipt,
                          icon: const Icon(Icons.add),
                          label: const Text('Nouveau reçu'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (_currentReceipt != null) ...[
                    // Informations du reçu
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reçu #${_currentReceipt!.receiptNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Créé le: ${_currentReceipt!.createdAt.toString().substring(0, 19)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Formulaire d'ajout de produits
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ajouter un produit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Recherche de produits
                              TextFormField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  labelText: 'Rechercher un produit',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // TODO: Implémenter la recherche de produits
                                },
                              ),
                              const SizedBox(height: 16),

                              // Sélection de variante
                              DropdownButtonFormField<String>(
                                value: _selectedVariantId,
                                decoration: const InputDecoration(
                                  labelText: 'Variante',
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  // TODO: Récupérer les variantes depuis l'API
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text('Variante 1 - 1000 FCFA'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2',
                                    child: Text('Variante 2 - 1500 FCFA'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedVariantId = value;
                                    if (value == '1') {
                                      _selectedVariantName = 'Variante 1';
                                      _selectedVariantPrice = Decimal.fromInt(1000);
                                    } else if (value == '2') {
                                      _selectedVariantName = 'Variante 2';
                                      _selectedVariantPrice = Decimal.fromInt(1500);
                                    }
                                    _priceController.text = _selectedVariantPrice.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _quantityController,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantité',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Quantité requise';
                                        }
                                        if (Decimal.tryParse(value) == null) {
                                          return 'Quantité invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _priceController,
                                      decoration: const InputDecoration(
                                        labelText: 'Prix unitaire',
                                        border: OutlineInputBorder(),
                                        suffixText: 'FCFA',
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Prix requis';
                                        }
                                        if (Decimal.tryParse(value) == null) {
                                          return 'Prix invalide';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _addToCart,
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Ajouter au panier'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Message d'instruction
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.point_of_sale,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Commencez une nouvelle vente',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Cliquez sur "Nouveau reçu" pour commencer',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Panneau de droite - Panier
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panier',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_cartItems.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Panier vide',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Ajoutez des produits pour commencer',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // Liste des articles
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(item.productName),
                                subtitle: Text('${item.quantity} x ${item.unitPrice} FCFA'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${item.total} FCFA',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _removeFromCart(index),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Total et actions
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '$_total FCFA',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _cartItems.isNotEmpty ? _finalizeReceipt : null,
                                  icon: const Icon(Icons.payment),
                                  label: const Text('Finaliser la vente'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
