import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  
  String _selectedPaymentMethod = 'Espèces';
  
  // Données simulées du panier
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Astronote',
      'price': 25.0,
      'quantity': 2,
    },
    {
      'id': '2',
      'name': 'Montre TK25',
      'price': 40.0,
      'quantity': 1,
    },
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Retourner à la page de vente pour modifier
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
                          
                          ..._cartItems.map((item) => _buildCartItem(item)),
                          
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
                                  onPressed: () {
                                    // TODO: Ajouter une taxe
                                  },
                                  child: const Text('AJOUTER UNE TAXE'),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Ajouter une remise
                                  },
                                  child: const Text('AJOUTER UNE REMISE'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              // TODO: Ajouter d'autres frais
                            },
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
                                onPressed: () {
                                  // TODO: Rechercher le client
                                },
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
                              _buildPaymentMethod('Carte de débit', Icons.credit_card, Colors.orange),
                              _buildPaymentMethod('Carte de crédit', Icons.credit_card, Colors.orange),
                              _buildPaymentMethod('Crédit', Icons.account_balance_wallet, Colors.teal),
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
                  onPressed: _processPayment,
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

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${item['quantity']} x ${item['price']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(item['price'] * item['quantity']).toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.accentColor),
            onPressed: () {
              // TODO: Éditer l'article
            },
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

  double _calculateTotal() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    return total;
  }

  void _processPayment() {
    // TODO: Implémenter le traitement du paiement
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
              '\$${_calculateTotal().toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID DE RÉCEPTION : BD-28',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'NOMBRE D\'ARTICLES : ${_cartItems.length}',
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
                    // TODO: Obtenir un reçu
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
                    // TODO: Nouvelle vente
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
}
