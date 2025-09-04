import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/product_model.dart';
import '../providers/inventory_provider.dart';

class InventoryProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const InventoryProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variantsState = ref.watch(productVariantsNotifierProvider(product.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: variantsState.when(
                  loading: () => _buildInfo(context, price: null, stock: null, margin: null),
                  error: (e, st) => _buildInfo(context, price: null, stock: null, margin: null),
                  data: (variants) {
                    final price = variants.isNotEmpty ? variants.first.price : null;
                    final stock = variants.fold<int>(0, (sum, v) => sum + v.stock);
                    // marge optionnelle si cost > 0
                    double? margin;
                    if (variants.isNotEmpty && variants.first.cost > 0) {
                      margin = ((variants.first.price - variants.first.cost) / variants.first.cost) * 100.0;
                    }
                    return _buildInfo(context, price: price, stock: stock, margin: margin);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: variantsState.when(
                  loading: () => const Text(
                    '... ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  error: (e, st) => const Text(
                    'N/A',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  data: (variants) => Text(
                    variants.isNotEmpty ? '< ${variants.first.price.toStringAsFixed(2)} >' : 'N/A',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, {double? price, int? stock, double? margin}) {
    final bool isOutOfStock = (stock ?? 0) == 0;
    final bool isLowStock = (stock ?? 0) <= 5 && !isOutOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              price != null ? '\$${price.toStringAsFixed(2)}' : 'Prix indisponible',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: price != null ? AppTheme.accentColor : AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (margin != null) ...[
              const SizedBox(width: 8),
              Text(
                '(${margin.toStringAsFixed(0)}%)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.successColor,
                    ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              stock != null ? '$stock En stock' : 'Stock: N/A',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isOutOfStock
                        ? AppTheme.errorColor
                        : isLowStock
                            ? AppTheme.warningColor
                            : AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (isOutOfStock || isLowStock) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? AppTheme.errorColor.withOpacity(0.1)
                      : AppTheme.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOutOfStock ? 'Stock épuisé' : 'Stock faible',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isOutOfStock ? AppTheme.errorColor : AppTheme.warningColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
