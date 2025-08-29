import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = item['isLowStock'] == true || item['stock'] <= 5;
    final bool isOutOfStock = item['isOutOfStock'] == true || item['stock'] == 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image du produit (cercle rouge)
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
              
              // Informations du produit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        Text(
                          '\$${(item['price'] as double).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item['margin'] != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '(${item['margin']}%)',
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
                          '${item['stock']} En stock',
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
                                color: isOutOfStock 
                                    ? AppTheme.errorColor 
                                    : AppTheme.warningColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Prix en bouton bleu (comme dans les screenshots)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '< ${(item['price'] as double).toStringAsFixed(2)} >',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
