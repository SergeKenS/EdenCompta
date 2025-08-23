import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:comptab_pos/widgets/navigation_drawer.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaire'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Ajouter un nouveau produit
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // TODO: Scanner un code-barres
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
                          labelText: 'Rechercher un produit',
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
                        DropdownMenuItem(value: 'all', child: Text('Toutes les catégories')),
                        DropdownMenuItem(value: 'electronics', child: Text('Électronique')),
                        DropdownMenuItem(value: 'clothing', child: Text('Vêtements')),
                        DropdownMenuItem(value: 'food', child: Text('Alimentation')),
                      ],
                      onChanged: (value) {
                        // TODO: Filtrer par catégorie
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
                            Icons.inventory_2,
                            size: 32,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Total produits',
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
                            Icons.warning,
                            size: 32,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Stock faible',
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
                            Icons.error,
                            size: 32,
                            color: Colors.red[600],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Rupture',
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

            // Liste des produits
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
                            'Produits',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Importer des produits
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Importer'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Exporter l'inventaire
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
                            title: Text('Aucun produit'),
                            subtitle: Text('Ajoutez des produits pour commencer'),
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
          // TODO: Ajouter un nouveau produit
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
