import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/dashboard_header.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Implement profile
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec informations du magasin
              const DashboardHeader(),
              const SizedBox(height: 20),
              
              // Actions rapides
              Text(
                'Actions rapides',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      title: 'Nouvelle Vente',
                      icon: Icons.add_shopping_cart,
                      color: AppTheme.successColor,
                      onTap: () {
                        context.go('/sales');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: QuickActionCard(
                      title: 'Ajouter Produit',
                      icon: Icons.add_box,
                      color: AppTheme.accentColor,
                      onTap: () {
                        context.go('/inventory');
                      },
                    ),
                  ),
                  Expanded(
                    child: QuickActionCard(
                      title: 'Gérer Dépenses',
                      icon: Icons.account_balance_wallet,
                      color: AppTheme.warningColor,
                      onTap: () {
                        context.go('/expenses');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Statistiques principales
              Text(
                'Statistiques d\'aujourd\'hui',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Grille de cartes de statistiques
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  const DashboardCard(
                    title: 'Ventes Totales',
                    value: '\$1,250.00',
                    subtitle: '+15% vs hier',
                    icon: Icons.trending_up,
                    color: AppTheme.successColor,
                    isPositive: true,
                  ),
                  const DashboardCard(
                    title: 'Transactions',
                    value: '24',
                    subtitle: '8 en cours',
                    icon: Icons.receipt_long,
                    color: AppTheme.accentColor,
                  ),
                  const DashboardCard(
                    title: 'Produits Vendus',
                    value: '156',
                    subtitle: '12 catégories',
                    icon: Icons.inventory_2,
                    color: AppTheme.warningColor,
                  ),
                  const DashboardCard(
                    title: 'Clients',
                    value: '18',
                    subtitle: '3 nouveaux',
                    icon: Icons.people,
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Section produits populaires
              Text(
                'Produits les plus vendus',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      _buildTopProductItem('Astronote', '25', '\$25.00'),
                      const Divider(),
                      _buildTopProductItem('Manette', '18', '\$29.00'),
                      const Divider(),
                      _buildTopProductItem('Montre TK25', '12', '\$40.00'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Section alertes
              Text(
                'Alertes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    children: [
                      _buildAlertItem(
                        'Stock faible',
                        '3 produits ont un stock inférieur à 5',
                        Icons.warning,
                        AppTheme.warningColor,
                      ),
                      const Divider(),
                      _buildAlertItem(
                        'Dettes en attente',
                        '2 clients ont des dettes non réglées',
                        Icons.account_balance_wallet,
                        AppTheme.errorColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopProductItem(String name, String quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$quantity vendus',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.successColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String subtitle, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textSecondaryColor,
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    // TODO: Implement data refresh
    await Future.delayed(const Duration(seconds: 1));
  }
}
