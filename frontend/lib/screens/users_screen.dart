import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:comptab_pos/widgets/navigation_drawer.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Ajouter un nouvel utilisateur
            },
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche et filtres
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Rechercher un utilisateur',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // TODO: Implémenter la recherche
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: 'all',
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Tous les rôles')),
                        DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                        DropdownMenuItem(value: 'manager', child: Text('Manager')),
                        DropdownMenuItem(value: 'cashier', child: Text('Caissier')),
                        DropdownMenuItem(value: 'stockManager', child: Text('Gestionnaire de stock')),
                      ],
                      onChanged: (value) {
                        // TODO: Filtrer par rôle
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: 'all',
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Tous les statuts')),
                        DropdownMenuItem(value: 'active', child: Text('Actif')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactif')),
                        DropdownMenuItem(value: 'suspended', child: Text('Suspendu')),
                        DropdownMenuItem(value: 'locked', child: Text('Verrouillé')),
                      ],
                      onChanged: (value) {
                        // TODO: Filtrer par statut
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistiques rapides
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people,
                            size: 32,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Total utilisateurs',
                            style: TextStyle(fontSize: 14),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 32,
                            color: Colors.green[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Utilisateurs actifs',
                            style: TextStyle(fontSize: 14),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 32,
                            color: Colors.red[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Comptes verrouillés',
                            style: TextStyle(fontSize: 14),
                          ),
                          const Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Liste des utilisateurs
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text(
                            'Utilisateurs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Importer des utilisateurs
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Importer'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Exporter la liste
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Exporter'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 0, // TODO: Remplacer par la vraie liste
                        itemBuilder: (context, index) {
                          return const ListTile(
                            title: Text('Aucun utilisateur'),
                            subtitle: Text('Ajoutez des utilisateurs pour commencer'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Ajouter un nouvel utilisateur
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
