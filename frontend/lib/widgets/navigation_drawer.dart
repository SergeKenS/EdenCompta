import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:comptab_pos/services/auth_service.dart';

class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Drawer(
      child: Column(
        children: [
          // En-tête du drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.initials ?? 'U',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.fullName ?? 'Utilisateur',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.role.name.toUpperCase() ?? 'ROLE',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Navigation principale
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _NavigationItem(
                  icon: Icons.dashboard,
                  title: 'Tableau de bord',
                  isSelected: GoRouterState.of(context).matchedLocation == '/dashboard',
                  onTap: () => context.go('/dashboard'),
                ),
                _NavigationItem(
                  icon: Icons.point_of_sale,
                  title: 'Ventes',
                  isSelected: GoRouterState.of(context).matchedLocation == '/sales',
                  onTap: () => context.go('/sales'),
                ),
                _NavigationItem(
                  icon: Icons.inventory_2,
                  title: 'Inventaire',
                  isSelected: GoRouterState.of(context).matchedLocation == '/inventory',
                  onTap: () => context.go('/inventory'),
                ),
                _NavigationItem(
                  icon: Icons.analytics,
                  title: 'Rapports',
                  isSelected: GoRouterState.of(context).matchedLocation == '/reports',
                  onTap: () => context.go('/reports'),
                ),
                _NavigationItem(
                  icon: Icons.people,
                  title: 'Utilisateurs',
                  isSelected: GoRouterState.of(context).matchedLocation == '/users',
                  onTap: () => context.go('/users'),
                ),
                _NavigationItem(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  isSelected: GoRouterState.of(context).matchedLocation == '/settings',
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),

          // Section inférieure
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Aide'),
                  onTap: () {
                    // TODO: Implémenter l'aide
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('À propos'),
                  onTap: () {
                    // TODO: Afficher les informations sur l'application
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(authStateProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Déconnexion'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[800],
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
