import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/product_grid.dart';
import '../widgets/category_filter.dart';
import '../widgets/cart_summary.dart';
import '../providers/cart_provider.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';
import '../../../inventory/data/models/product_model.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  final List<String> _categories = ['Tous'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsNotifierProvider);
    final categoriesFuture = ref.watch(categoriesProvider);
    final cart = ref.watch(cartProvider);

    categoriesFuture.whenData((cats) {
      // Maintenir 'Tous' en tête
      final merged = ['Tous', ...cats.where((c) => c != 'Tous')];
      if (merged.toString() != _categories.toString()) {
        // éviter setState cyclique si identique
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _categories.clear();
            _categories.addAll(merged);
          });
        });
      }
    });

    final filteredProducts = productsState.when<List<ProductModel>>(
      data: (products) {
        var list = products;
        if (_selectedCategory != 'Tous') {
          list = list.where((p) => p.category == _selectedCategory).toList();
        }
        if (_searchController.text.isNotEmpty) {
          final term = _searchController.text.toLowerCase();
          list = list.where((p) => p.name.toLowerCase().contains(term)).toList();
        }
        return list;
      },
      loading: () => const [],
      error: (_, __) => const [],
    );
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Nouvelle Vente'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (cart.isNotEmpty)
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
                      '${cart.fold<int>(0, (sum, i) => sum + i.quantity)}',
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
            child: productsState.when(
              data: (_) => ProductGrid(
                products: filteredProducts,
                onAdd: (id, name, price) {
                  ref.read(cartProvider.notifier).addItem(
                    id: id,
                    name: name,
                    price: price,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name ajouté au panier'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Erreur: $e')),
            ),
          ),

          // Résumé du panier
          if (cart.isNotEmpty)
            CartSummary(
              itemCount: cart.fold<int>(0, (sum, i) => sum + i.quantity),
              total: cart.fold<double>(0.0, (sum, i) => sum + i.price * i.quantity),
              onViewCart: () => context.push('/sales/cart'),
            ),
        ],
      ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/sales/cart'),
              backgroundColor: AppTheme.successColor,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Aller au compteur'),
            )
          : null,
    );
  }
}
