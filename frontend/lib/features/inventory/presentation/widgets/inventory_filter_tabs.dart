import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InventoryFilterTabs extends StatelessWidget {
  final TabController tabController;
  final Function(int) onTabChanged;

  const InventoryFilterTabs({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            onTap: onTabChanged,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.textSecondaryColor,
            indicatorColor: AppTheme.primaryColor,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'TOUS'),
              Tab(text: 'CATÉGORIE'),
              Tab(text: 'MODIFICATEURS'),
              Tab(text: 'INGRÉDIENTS'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Filtres supplémentaires (puces)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Tous', true),
                const SizedBox(width: 8),
                _buildFilterChip('Stock faible', false),
                const SizedBox(width: 8),
                _buildFilterChip('Expiré', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: isSelected 
            ? Border.all(color: AppTheme.primaryColor)
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
