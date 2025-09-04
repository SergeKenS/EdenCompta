import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/setting_model.dart';
import '../../data/models/store_settings_model.dart';
import '../../data/services/dev_settings_service.dart';

// Provider pour le service des paramètres
final settingsServiceProvider = Provider<DevSettingsService>((ref) {
  return DevSettingsService();
});

// Provider pour la liste des paramètres
final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<List<SettingModel>>>((ref) {
  final service = ref.read(settingsServiceProvider);
  return SettingsNotifier(service);
});

// Provider pour les paramètres du magasin
final storeSettingsProvider = StateNotifierProvider<StoreSettingsNotifier, AsyncValue<StoreSettingsModel?>>((ref) {
  final service = ref.read(settingsServiceProvider);
  return StoreSettingsNotifier(service);
});

// Notifier pour gérer l'état des paramètres
class SettingsNotifier extends StateNotifier<AsyncValue<List<SettingModel>>> {
  final DevSettingsService _service;

  SettingsNotifier(this._service) : super(const AsyncValue.loading());

  /// Charge tous les paramètres
  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    
    try {
      await _service.initialize();
      final settings = await _service.getAllSettings();
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Met à jour un paramètre
  Future<void> updateSetting(SettingModel setting) async {
    try {
      await _service.updateSetting(setting);
      // Recharger les paramètres
      await loadSettings();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Rafraîchit la liste
  Future<void> refresh() async {
    await loadSettings();
  }
}

// Notifier pour gérer l'état des paramètres du magasin
class StoreSettingsNotifier extends StateNotifier<AsyncValue<StoreSettingsModel?>> {
  final DevSettingsService _service;

  StoreSettingsNotifier(this._service) : super(const AsyncValue.loading());

  /// Charge les paramètres du magasin
  Future<void> loadStoreSettings() async {
    state = const AsyncValue.loading();
    
    try {
      await _service.initialize();
      final storeSettings = await _service.getStoreSettings();
      state = AsyncValue.data(storeSettings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Met à jour les paramètres du magasin
  Future<void> updateStoreSettings(StoreSettingsModel settings) async {
    try {
      await _service.updateStoreSettings(settings);
      state = AsyncValue.data(settings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Rafraîchit les paramètres
  Future<void> refresh() async {
    await loadStoreSettings();
  }
}
