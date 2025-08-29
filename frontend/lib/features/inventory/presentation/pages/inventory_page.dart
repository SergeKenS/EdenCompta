import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/inventory_item_card.dart';
import '../widgets/inventory_filter_tabs.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedFilter = 'Tous';
  
  // Données simulées de l'inventaire
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': '1',
      'name': 'Astronote',
      'price': 25.00,
      'stock': 3,
      'category': 'Gadget',
      'isLowStock': true,
    },
    {
      'id': '2',
      'name': 'Dell E3350',
      'price': 12500.00,
      'stock': 0,
      'category': 'Laptop',
      'isOutOfStock': true,
    },
    {
      'id': '3',
      'name': 'Manette',
      'price': 29.00,
      'stock': 16,
      'category': 'Gadget',
      'margin': 44.83,
    },
    {
      'id': '4',
      'name': 'Montre TK25',
      'price': 40.00,
      'stock': 2,
      'category': 'Gadget',
      'margin': 55.00,
      'isLowStock': true,
    },
  ];

  final List<String> _categories = ['Laptop', 'Gadget'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('GESTION DE L\'INVENTAIRE'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Focus sur la barre de recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Onglets de filtrage
          InventoryFilterTabs(
            tabController: _tabController,
            onTabChanged: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    _selectedFilter = 'Tous';
                    break;
                  case 1:
                    _selectedFilter = 'Stock faible';
                    break;
                  case 2:
                    _selectedFilter = 'Expiré';
                    break;
                  case 3:
                    _selectedFilter = 'Catégories';
                    break;
                }
              });
            },
          ),
          
          // Si l'onglet catégories est sélectionné, afficher les catégories
          if (_selectedFilter == 'Catégories')
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: _categories.map((category) => 
                  _buildCategoryItem(category)).toList(),
              ),
            )
          else
            // Liste des produits
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return InventoryItemCard(
                    item: item,
                    onTap: () => _showItemDetails(item),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // TODO: Supprimer la catégorie
                },
              ),
              const Icon(Icons.keyboard_arrow_down),
              const Icon(Icons.keyboard_arrow_up),
            ],
          ),
          onTap: () {
            // TODO: Voir les produits de cette catégorie
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    List<Map<String, dynamic>> filtered = _inventoryItems;

    switch (_selectedFilter) {
      case 'Stock faible':
        filtered = filtered.where((item) => 
          item['isLowStock'] == true || item['stock'] <= 5).toList();
        break;
      case 'Expiré':
        // TODO: Filtrer par produits expirés
        filtered = [];
        break;
      case 'Catégories':
        return [];
    }

    // Filtrer par recherche si nécessaire
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((item) =>
        item['name'].toLowerCase().contains(searchTerm)).toList();
    }

    return filtered;
  }

  void _showItemDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
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
                const SizedBox(height: 20),
                
                Text(
                  item['name'],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Catégorie: ${item['category']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailCard('Prix', '\$${item['price'].toStringAsFixed(2)}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailCard('Stock', '${item['stock']} En stock'),
                    ),
                  ],
                ),
                
                if (item['margin'] != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard('Marge', '${item['margin']}%'),
                ],
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Éditer le produit
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Éditer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Supprimer le produit
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Supprimer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewProduct() {
    // TODO: Navigation vers la page d'ajout de produit
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouter un nouveau produit - À venir'),
      ),
    );
  }
}
