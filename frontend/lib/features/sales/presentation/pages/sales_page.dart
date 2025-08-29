import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/product_grid.dart';
import '../widgets/category_filter.dart';
import '../widgets/cart_summary.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  final List<String> _categories = ['Tous', 'Laptop', 'Gadget'];

  // Données simulées des produits (sera remplacé par des données du backend)
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Dell E3350',
      'category': 'Laptop',
      'price': 12500.00,
      'image': null,
    },
    {
      'id': '2',
      'name': 'Astronote',
      'category': 'Gadget',
      'price': 25.00,
      'image': null,
    },
    {
      'id': '3',
      'name': 'Manette',
      'category': 'Gadget',
      'price': 29.00,
      'image': null,
    },
    {
      'id': '4',
      'name': 'Montre TK25',
      'category': 'Gadget',
      'price': 40.00,
      'image': null,
    },
  ];

  // Panier (sera géré par Riverpod plus tard)
  final List<Map<String, dynamic>> _cartItems = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Nouvelle Vente'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_cartItems.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => context.push('/sales/cart'),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Je veux vendre...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement barcode scanner
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Scanner à venir')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Filtres par catégorie
          CategoryFilter(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),

          // Liste des produits
          Expanded(
            child: ProductGrid(
              products: filteredProducts,
              onProductTap: _addToCart,
            ),
          ),

          // Résumé du panier
          if (_cartItems.isNotEmpty)
            CartSummary(
              itemCount: _cartItems.length,
              total: _calculateTotal(),
              onViewCart: () => context.push('/sales/cart'),
            ),
        ],
      ),
      floatingActionButton: _cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/sales/cart'),
              backgroundColor: AppTheme.successColor,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Aller au compteur'),
            )
          : null,
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    List<Map<String, dynamic>> filtered = _products;

    // Filtrer par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((product) => 
        product['category'] == _selectedCategory).toList();
    }

    // Filtrer par recherche
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((product) =>
        product['name'].toLowerCase().contains(searchTerm)).toList();
    }

    return filtered;
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      // Vérifier si le produit est déjà dans le panier
      final existingIndex = _cartItems.indexWhere(
        (item) => item['id'] == product['id']
      );

      if (existingIndex >= 0) {
        // Incrementer la quantité
        _cartItems[existingIndex]['quantity'] += 1;
      } else {
        // Ajouter nouveau produit
        _cartItems.add({
          ...product,
          'quantity': 1,
        });
      }
    });

    // Afficher un feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} ajouté au panier'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }
}
