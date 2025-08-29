import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Sections avec triangles comme dans les screenshots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildCategorySection('Laptop', 1, Icons.laptop),
                const SizedBox(height: 8),
                _buildCategorySection('Gadget', 3, Icons.devices),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, int count, IconData icon) {
    final isSelected = selectedCategory == category || 
                      (selectedCategory == 'Tous' && category == 'Laptop');
    
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Row(
          children: [
            // Triangle noir (flèche)
            Container(
              width: 0,
              height: 0,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 6, color: Colors.transparent),
                  bottom: BorderSide(width: 6, color: Colors.transparent),
                  left: BorderSide(width: 10, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Nom de la catégorie
            Expanded(
              child: Text(
                '$category ($count)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                ),
              ),
            ),
            
            // Checkbox ou triangle pour indiquer la sélection
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),
            
            // Triangle de droite pour indiquer expansion/collapse
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
