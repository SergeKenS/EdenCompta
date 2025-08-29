import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../data/services/inventory_service.dart';

// Provider pour le service d'inventaire
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return InventoryService(dioClient);
});

// Notifier pour gérer l'état des produits
class ProductsNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final InventoryService _inventoryService;

  ProductsNotifier(this._inventoryService) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  /// Charge la liste des produits
  Future<void> loadProducts({
    String? search,
    String? category,
    bool? isActive,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final products = await _inventoryService.getProducts(
        search: search,
        category: category,
        isActive: isActive,
      );
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Ajoute un nouveau produit
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final newProduct = await _inventoryService.createProduct(productData);
      
      // Ajouter le produit à la liste existante
      state.whenData((products) {
        state = AsyncValue.data([...products, newProduct]);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Met à jour un produit
  Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
    try {
      final updatedProduct = await _inventoryService.updateProduct(productId, productData);
      
      // Mettre à jour le produit dans la liste
      state.whenData((products) {
        final updatedProducts = products.map((product) {
          return product.id == productId ? updatedProduct : product;
        }).toList();
        state = AsyncValue.data(updatedProducts);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Supprime un produit
  Future<void> deleteProduct(String productId) async {
    try {
      await _inventoryService.deleteProduct(productId);
      
      // Supprimer le produit de la liste
      state.whenData((products) {
        final updatedProducts = products.where((product) => product.id != productId).toList();
        state = AsyncValue.data(updatedProducts);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Rafraîchit la liste des produits
  Future<void> refresh() async {
    await loadProducts();
  }
}

// Provider pour le notifier des produits
final productsNotifierProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<ProductModel>>>((ref) {
  final inventoryService = ref.read(inventoryServiceProvider);
  return ProductsNotifier(inventoryService);
});

// Notifier pour gérer l'état des variantes d'un produit
class ProductVariantsNotifier extends StateNotifier<AsyncValue<List<ProductVariantModel>>> {
  final InventoryService _inventoryService;
  final String _productId;

  ProductVariantsNotifier(this._inventoryService, this._productId) : super(const AsyncValue.loading()) {
    loadVariants();
  }

  /// Charge les variantes du produit
  Future<void> loadVariants() async {
    state = const AsyncValue.loading();
    
    try {
      final variants = await _inventoryService.getProductVariants(_productId);
      state = AsyncValue.data(variants);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Ajoute une nouvelle variante
  Future<void> addVariant(Map<String, dynamic> variantData) async {
    try {
      final newVariant = await _inventoryService.createProductVariant(variantData);
      
      state.whenData((variants) {
        state = AsyncValue.data([...variants, newVariant]);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Met à jour une variante
  Future<void> updateVariant(String variantId, Map<String, dynamic> variantData) async {
    try {
      final updatedVariant = await _inventoryService.updateProductVariant(variantId, variantData);
      
      state.whenData((variants) {
        final updatedVariants = variants.map((variant) {
          return variant.id == variantId ? updatedVariant : variant;
        }).toList();
        state = AsyncValue.data(updatedVariants);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Met à jour le stock d'une variante
  Future<void> updateStock(String variantId, int newStock, String reason) async {
    try {
      final updatedVariant = await _inventoryService.updateStock(variantId, newStock, reason);
      
      state.whenData((variants) {
        final updatedVariants = variants.map((variant) {
          return variant.id == variantId ? updatedVariant : variant;
        }).toList();
        state = AsyncValue.data(updatedVariants);
      });
    } catch (error) {
      rethrow;
    }
  }

  /// Supprime une variante
  Future<void> deleteVariant(String variantId) async {
    try {
      await _inventoryService.deleteProductVariant(variantId);
      
      state.whenData((variants) {
        final updatedVariants = variants.where((variant) => variant.id != variantId).toList();
        state = AsyncValue.data(updatedVariants);
      });
    } catch (error) {
      rethrow;
    }
  }
}

// Provider famille pour les variantes d'un produit spécifique
final productVariantsNotifierProvider = StateNotifierProvider.family<ProductVariantsNotifier, AsyncValue<List<ProductVariantModel>>, String>((ref, productId) {
  final inventoryService = ref.read(inventoryServiceProvider);
  return ProductVariantsNotifier(inventoryService, productId);
});

// Provider pour les catégories
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final inventoryService = ref.read(inventoryServiceProvider);
  return inventoryService.getCategories();
});

// Provider pour les produits filtrés
final filteredProductsProvider = Provider.family<AsyncValue<List<ProductModel>>, ProductFilter>((ref, filter) {
  final productsState = ref.watch(productsNotifierProvider);
  
  return productsState.when(
    data: (products) {
      var filteredProducts = products;
      
      // Filtrer par recherche
      if (filter.search != null && filter.search!.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.name.toLowerCase().contains(filter.search!.toLowerCase()) ||
                 (product.description?.toLowerCase().contains(filter.search!.toLowerCase()) ?? false);
        }).toList();
      }
      
      // Filtrer par catégorie
      if (filter.category != null && filter.category!.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) {
          return product.category == filter.category;
        }).toList();
      }
      
      // Filtrer par statut actif
      if (filter.isActive != null) {
        filteredProducts = filteredProducts.where((product) {
          return product.isActive == filter.isActive;
        }).toList();
      }
      
      return AsyncValue.data(filteredProducts);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Classe pour les filtres de produits
class ProductFilter {
  final String? search;
  final String? category;
  final bool? isActive;

  const ProductFilter({
    this.search,
    this.category,
    this.isActive,
  });

  ProductFilter copyWith({
    String? search,
    String? category,
    bool? isActive,
  }) {
    return ProductFilter(
      search: search ?? this.search,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
    );
  }
}
