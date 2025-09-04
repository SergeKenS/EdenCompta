import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/inventory_item_card.dart';
import '../widgets/inventory_filter_tabs.dart';
import '../../data/models/product_model.dart';
import '../providers/inventory_provider.dart';
import '../widgets/inventory_product_card.dart';

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
                    _selectedFilter = 'Catégories';
                    break;
                  case 2:
                    _selectedFilter = 'Expiré';
                    break;
                  case 3:
                    _selectedFilter = 'Stock faible';
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Catégories',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentColor,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addCategory,
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._categories.map((category) => _buildCategoryItem(category)).toList(),
                ],
              ),
            )
          else
            // Liste des produits
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final productsState = ref.watch(productsNotifierProvider);
                  return productsState.when(
                    data: (products) {
                      // Appliquer filtres simples côté client pour cette vue
                      Iterable<ProductModel> list = products;
                      if (_selectedFilter == 'Stock faible') {
                        // Note: sans stock agrégé côté API, on affiche tous
                      } else if (_selectedFilter == 'Expiré') {
                        // Placeholder: pas de notion d'expiration côté modèle actuel
                        list = const [];
                      }
                      if (_searchController.text.isNotEmpty) {
                        final term = _searchController.text.toLowerCase();
                        list = list.where((p) => p.name.toLowerCase().contains(term));
                      }
                      final items = list.toList();
                      if (items.isEmpty) {
                        return const Center(child: Text('Aucun produit'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final product = items[index];
                          return InventoryProductCard(
                            product: product,
                            onTap: () => _showProductDetails(product),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Erreur: $e')),
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
                icon: const Icon(Icons.edit, color: AppTheme.accentColor),
                tooltip: 'Renommer',
                onPressed: () => _renameCategory(category),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDeleteCategory(category);
                },
              ),
            ],
          ),
          onTap: () {
            // TODO: Voir les produits de cette catégorie
          },
        ),
      ),
    );
  }

  void _confirmDeleteCategory(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la catégorie'),
        content: Text('Voulez-vous vraiment supprimer la catégorie \"$category\" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _categories.remove(category);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Catégorie \"$category\" supprimée')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _renameCategory(String oldName) {
    final TextEditingController controller = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Renommer la catégorie'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nouveau nom',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer un nom valide')),
                  );
                  return;
                }
                if (newName == oldName) {
                  Navigator.of(context).pop();
                  return;
                }
                if (_categories.contains(newName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cette catégorie existe déjà')),
                  );
                  return;
                }
                setState(() {
                  final idx = _categories.indexOf(oldName);
                  if (idx >= 0) {
                    _categories[idx] = newName;
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Catégorie renommée en \"$newName\"')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
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
                          Navigator.of(context).pop();
                          _editProduct(item);
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
                          Navigator.of(context).pop();
                          _confirmDeleteProduct(item);
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

  void _editProduct(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']?.toString() ?? '');
    final priceController = TextEditingController(text: (item['price'] as double).toStringAsFixed(2));
    final stockController = TextEditingController(text: (item['stock'] as int).toString());
    String category = item['category']?.toString() ?? (_categories.isNotEmpty ? _categories.first : 'Gadget');

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
            left: AppConstants.defaultPadding,
            right: AppConstants.defaultPadding,
            top: AppConstants.defaultPadding,
          ),
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
              Text('Modifier le produit', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => category = v ?? category,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
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
                      onPressed: () {
                        final name = nameController.text.trim();
                        final price = double.tryParse(priceController.text.trim());
                        final stock = int.tryParse(stockController.text.trim());
                        if (name.isEmpty || price == null || stock == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez renseigner tous les champs')),
                          );
                          return;
                        }
                        setState(() {
                          final idx = _inventoryItems.indexWhere((e) => e['id'] == item['id']);
                          if (idx >= 0) {
                            _inventoryItems[idx] = {
                              'id': item['id'],
                              'name': name,
                              'price': price,
                              'stock': stock,
                              'category': category,
                            };
                          }
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produit modifié')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteProduct(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le produit'),
          content: Text('Voulez-vous vraiment supprimer \"${item['name']}\" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _inventoryItems.removeWhere((e) => e['id'] == item['id']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produit supprimé')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _addCategory() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle catégorie'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Nom de la catégorie',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = categoryController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer un nom de catégorie')),
                  );
                  return;
                }
                if (_categories.contains(name)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cette catégorie existe déjà')),
                  );
                  return;
                }
                setState(() {
                  _categories.add(name);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Catégorie "$name" ajoutée')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final nameController = TextEditingController();
        final priceController = TextEditingController();
        final stockController = TextEditingController(text: '0');
        String category = _categories.isNotEmpty ? _categories.first : 'Gadget';

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppConstants.defaultPadding,
            right: AppConstants.defaultPadding,
            top: AppConstants.defaultPadding,
          ),
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
              Text('Nouveau produit', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => category = v ?? category,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
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
                        final name = nameController.text.trim();
                        final price = double.tryParse(priceController.text.trim());
                        final stock = int.tryParse(stockController.text.trim());
                        if (name.isEmpty || price == null || stock == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez renseigner tous les champs')),
                          );
                          return;
                        }
                        try {
                          final inventoryService = ref.read(inventoryServiceProvider);
                          // TODO: storeId réel si requis par l'API
                          final product = await inventoryService.createProduct({
                            'name': name,
                            'category': category,
                            'isActive': true,
                          });
                          await inventoryService.createProductVariant({
                            'productId': product.id,
                            'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch}',
                            'name': name,
                            'price': price,
                            'cost': 0,
                            'stock': stock,
                            'isActive': true,
                          });
                          await ref.read(productsNotifierProvider.notifier).refresh();
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produit ajouté')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showProductDetails(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Catégorie: ${product.category}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondaryColor)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _editProduct(product);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Éditer'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _confirmDeleteProduct(product);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Supprimer'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(ProductModel product) {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String category = product.category;

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
            left: AppConstants.defaultPadding,
            right: AppConstants.defaultPadding,
            top: AppConstants.defaultPadding,
          ),
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
              Text('Modifier le produit', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du produit',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix (1ère variante)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock (1ère variante)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => category = v ?? category,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
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
                        final name = nameController.text.trim();
                        final price = priceController.text.trim().isEmpty ? null : double.tryParse(priceController.text.trim());
                        final stock = stockController.text.trim().isEmpty ? null : int.tryParse(stockController.text.trim());
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Le nom est requis')),
                          );
                          return;
                        }
                        try {
                          final inventoryService = ref.read(inventoryServiceProvider);
                          await inventoryService.updateProduct(product.id, {
                            'name': name,
                            'category': category,
                          });
                          // Mettre à jour la première variante si renseignée
                          final variants = await inventoryService.getProductVariants(product.id);
                          if (variants.isEmpty) {
                            if (price != null || stock != null) {
                              await inventoryService.createProductVariant({
                                'productId': product.id,
                                'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch}',
                                'name': name,
                                'price': price ?? 0,
                                'cost': 0,
                                'stock': stock ?? 0,
                                'isActive': true,
                              });
                            }
                          } else {
                            final v = variants.first;
                            await inventoryService.updateProductVariant(v.id, {
                              'name': name,
                              if (price != null) 'price': price,
                              if (stock != null) 'stock': stock,
                              'isActive': true,
                            });
                          }
                          await ref.read(productsNotifierProvider.notifier).refresh();
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produit modifié')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le produit'),
          content: Text('Voulez-vous vraiment supprimer "${product.name}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref.read(inventoryServiceProvider).deleteProduct(product.id);
                  await ref.read(productsNotifierProvider.notifier).refresh();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Produit supprimé')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
