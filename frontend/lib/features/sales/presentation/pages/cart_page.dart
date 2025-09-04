import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  
  String _selectedPaymentMethod = 'Espèces';
  
  @override
  void dispose() {
    _phoneController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final total = cart.fold<double>(0.0, (sum, i) => sum + i.price * i.quantity);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Vider le panier',
            onPressed: _confirmClearCart,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Liste des articles
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Articles du panier
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Articles',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          ...cart.map((item) => _buildCartItem(item)),
                          
                          const Divider(),
                          
                          // Bouton ajouter élément
                          InkWell(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'AJOUTER UN NOUVEL ÉLÉMENT',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppTheme.accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Totaux
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        children: [
                          _buildTotalRow('Total', total, isMain: true),
                          const SizedBox(height: 8),
                          _buildTotalRow('Total', '\$${total.toStringAsFixed(2)}', isPrice: true),
                          const SizedBox(height: 16),
                          
                          // Actions supplémentaires
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('AJOUTER UNE TAXE'),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('AJOUTER UNE REMISE'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: const Text('AJOUTER D\'AUTRES FRAIS'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Détails du client
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DÉTAILS DU CLIENT (FACULTATIF)',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              const Text('+1'),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    hintText: 'Numéro de portable',
                                    border: UnderlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search, color: AppTheme.accentColor),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          TextField(
                            controller: _customerNameController,
                            decoration: const InputDecoration(
                              hintText: 'Nom du client',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sélection mode de paiement
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SÉLECTIONNEZ LE MODE DE PAIEMENT',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2,
                            children: [
                              _buildPaymentMethod('Espèces', Icons.money, Colors.green),
                              _buildPaymentMethod('Mobile Money', Icons.phone_iphone, Colors.teal),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bouton de paiement
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _confirmCheckout(total),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('CHARGER : \$${total.toStringAsFixed(2)}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${item.quantity} x ${item.price}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(item.price * item.quantity).toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.accentColor),
            onPressed: () {
              _editItemPrice(item);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent),
            tooltip: 'Supprimer',
            onPressed: () => _confirmRemoveItem(item),
          ),
        ],
      ),
    );
  }

  void _editItemPrice(CartItem item) {
    final priceController = TextEditingController(text: item.price.toStringAsFixed(2));
    final qtyController = TextEditingController(text: item.quantity.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier - ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix unitaire',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(qtyController.text.trim());
                final price = double.tryParse(priceController.text.trim());
                if (qty == null || qty <= 0 || price == null || price < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Valeurs invalides')),
                  );
                  return;
                }
                ref.read(cartProvider.notifier).updateItem(
                  item.id,
                  price: price,
                  quantity: qty,
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _confirmRemoveItem(CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'article'),
        content: Text('Voulez-vous supprimer \"${item.name}\" du panier ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(cartProvider.notifier).removeAll(item.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider le panier'),
        content: const Text('Voulez-vous vraiment vider tout le panier ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(cartProvider.notifier).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Panier vidé')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, dynamic value, {bool isMain = false, bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          isPrice ? value : value.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPrice ? AppTheme.accentColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String label, IconData icon, Color color) {
    final isSelected = _selectedPaymentMethod == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: isSelected 
              ? Border.all(color: color, width: 2)
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.successColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NOMBRE D\'ARTICLES : ${ref.read(cartProvider).length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                  ),
                  child: const Text('OBTENIR UN REÇU'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(cartProvider.notifier).clear();
                    context.go('/sales');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                  ),
                  child: const Text('NOUVELLE VENTE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmCheckout(double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'achat ?'),
        content: Text('Total: \$${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _processPayment(total);
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }
}
