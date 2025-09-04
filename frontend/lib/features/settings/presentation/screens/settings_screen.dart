import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/permissions/page_protection_mixin.dart';
import '../../data/models/store_settings_model.dart';
import '../../data/services/dev_settings_service.dart';
import '../providers/settings_provider.dart';
import '../widgets/simple_setting_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> 
    with PageProtectionMixin {
  @override
  void initState() {
    super.initState();
    // Initialiser le service et charger les paramètres
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsServiceProvider).initialize();
      ref.read(storeSettingsProvider.notifier).loadStoreSettings();
      
      // Vérifier les permissions après l'initialisation
      checkSettingsAccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeSettingsState = ref.watch(storeSettingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(storeSettingsProvider.notifier).loadStoreSettings();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              _buildHeader(),
              const SizedBox(height: 24),
              
              // Paramètres du magasin
              storeSettingsState.when(
                data: (storeSettings) {
                  if (storeSettings != null) {
                    return _buildStoreSettings(storeSettings);
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildErrorState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuration du magasin',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paramètres essentiels pour votre activité',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSettings(StoreSettingsModel storeSettings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Informations du magasin
        _buildSection(
          'Informations du magasin',
          Icons.store,
          [
            SimpleSettingTile(
              icon: Icons.business,
              title: 'Nom du magasin',
              value: storeSettings.storeName,
              onTap: () => _editSetting('Nom du magasin', storeSettings.storeName),
            ),
            SimpleSettingTile(
              icon: Icons.location_on,
              title: 'Adresse',
              value: storeSettings.storeAddress,
              onTap: () => _editSetting('Adresse', storeSettings.storeAddress),
            ),
            SimpleSettingTile(
              icon: Icons.phone,
              title: 'Téléphone',
              value: storeSettings.storePhone ?? 'Non renseigné',
              onTap: () => _editSetting('Téléphone', storeSettings.storePhone ?? ''),
            ),
            SimpleSettingTile(
              icon: Icons.email,
              title: 'Email',
              value: storeSettings.storeEmail ?? 'Non renseigné',
              onTap: () => _editSetting('Email', storeSettings.storeEmail ?? ''),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Paramètres commerciaux
        _buildSection(
          'Paramètres commerciaux',
          Icons.euro,
          [
            SimpleSettingTile(
              icon: Icons.currency_exchange,
              title: 'Devise',
              value: storeSettings.currency,
              onTap: () => _editSetting('Devise', storeSettings.currency),
            ),
            SimpleSettingTile(
              icon: Icons.receipt_long,
              title: 'Taux de TVA',
              value: '${storeSettings.taxRate}%',
              onTap: () => _editSetting('Taux de TVA', storeSettings.taxRate),
            ),
            SimpleSettingTile(
              icon: Icons.description,
              title: 'Format de facture',
              value: storeSettings.invoiceFormat,
              onTap: () => _editSetting('Format de facture', storeSettings.invoiceFormat),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(storeSettingsProvider.notifier).loadStoreSettings();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _editSetting(String title, String currentValue) {
    // TODO: Implémenter l'édition des paramètres
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Édition de $title')),
    );
  }
}


