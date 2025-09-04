import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../inventory/data/models/product_model.dart';
import '../../../inventory/presentation/providers/inventory_provider.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(String id, String name, double price) onAdd;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Aucun produit trouvé',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onAdd: onAdd,
        );
      },
    );
  }
}

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final void Function(String id, String name, double price) onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variantsState = ref.watch(productVariantsNotifierProvider(product.id));

    double? price;
    final isLoading = variantsState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    variantsState.whenData((variants) {
      if (variants.isNotEmpty) {
        price = variants.first.price;
      }
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            const Expanded(
              flex: 3,
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE53E3E),
                  child: Icon(Icons.shopping_bag, color: Colors.white, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Nom du produit
            Expanded(
              flex: 1,
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Prix
            Text(
              isLoading
                  ? 'Chargement...'
                  : (price != null
                      ? '\$${price!.toStringAsFixed(2)}'
                      : 'Prix indisponible'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: price != null ? AppTheme.successColor : AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            // Bouton d'ajout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (price != null)
                    ? () => onAdd(product.id, product.name, price!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  (price != null) ? '< ${price!.toStringAsFixed(2)} >' : 'Indisponible',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
