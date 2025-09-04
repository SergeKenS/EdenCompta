import 'package:hive/hive.dart';
import '../models/setting_model.dart';
import '../models/store_settings_model.dart';

class DevSettingsService {
  static const String _settingsBox = 'settings_box';
  static const String _storeSettingsBox = 'store_settings_box';
  
  /// Initialise le service avec des paramètres par défaut
  Future<void> initialize() async {
    final settingsBox = Hive.box(_settingsBox);
    final storeBox = Hive.box(_storeSettingsBox);
    
    if (settingsBox.isEmpty) {
      await _createDefaultSettings();
    }
    
    if (storeBox.isEmpty) {
      await _createDefaultStoreSettings();
    }
  }
  
  /// Crée les paramètres par défaut
  Future<void> _createDefaultSettings() async {
    final defaultSettings = [
      SettingModel(
        id: 'setting-001',
        key: 'tax_rate',
        value: '20.0',
        category: 'TAX',
        description: 'Taux de TVA par défaut (%)',
        dataType: 'NUMBER',
        isEditable: true,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      SettingModel(
        id: 'setting-002',
        key: 'invoice_prefix',
        value: 'FACT',
        category: 'INVOICE',
        description: 'Préfixe des numéros de facture',
        dataType: 'STRING',
        isEditable: true,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      SettingModel(
        id: 'setting-003',
        key: 'currency',
        value: 'EUR',
        category: 'GENERAL',
        description: 'Devise par défaut',
        dataType: 'STRING',
        isEditable: true,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      SettingModel(
        id: 'setting-004',
        key: 'language',
        value: 'fr',
        category: 'GENERAL',
        description: 'Langue de l\'interface',
        dataType: 'STRING',
        isEditable: true,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      SettingModel(
        id: 'setting-005',
        key: 'enable_notifications',
        value: 'true',
        category: 'NOTIFICATION',
        description: 'Activer les notifications',
        dataType: 'BOOLEAN',
        isEditable: true,
        storeId: 'store-001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    
    final box = Hive.box(_settingsBox);
    for (final setting in defaultSettings) {
      await box.put(setting.id, setting.toJson());
    }
  }
  
  /// Crée les paramètres du magasin par défaut
  Future<void> _createDefaultStoreSettings() async {
    final storeSettings = StoreSettingsModel(
      id: 'store-001',
      storeName: 'EdenCompta Store',
      storeAddress: '123 Rue du Commerce, 75001 Paris, France',
      storePhone: '+33 1 23 45 67 89',
      storeEmail: 'contact@edencompta.com',
      currency: 'EUR',
      taxRate: '20.0',
      invoiceFormat: 'SIMPLE',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final box = Hive.box(_storeSettingsBox);
    await box.put('store', storeSettings.toJson());
  }
  
  /// Récupère tous les paramètres
  Future<List<SettingModel>> getAllSettings() async {
    final box = Hive.box(_settingsBox);
    final settings = <SettingModel>[];
    
    for (final key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        settings.add(SettingModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    
    return settings;
  }
  
  /// Récupère un paramètre par clé
  Future<SettingModel?> getSettingByKey(String key) async {
    final allSettings = await getAllSettings();
    try {
      return allSettings.firstWhere((setting) => setting.key == key);
    } catch (e) {
      return null;
    }
  }
  
  /// Met à jour un paramètre
  Future<SettingModel> updateSetting(SettingModel setting) async {
    final box = Hive.box(_settingsBox);
    final updatedSetting = setting.copyWith(
      updatedAt: DateTime.now(),
    );
    
    await box.put(updatedSetting.id, updatedSetting.toJson());
    return updatedSetting;
  }
  
  /// Récupère les paramètres du magasin
  Future<StoreSettingsModel?> getStoreSettings() async {
    final box = Hive.box(_storeSettingsBox);
    final data = box.get('store');
    
    if (data != null) {
      return StoreSettingsModel.fromJson(Map<String, dynamic>.from(data));
    }
    
    return null;
  }
  
  /// Met à jour les paramètres du magasin
  Future<StoreSettingsModel> updateStoreSettings(StoreSettingsModel settings) async {
    final box = Hive.box(_storeSettingsBox);
    final updatedSettings = settings.copyWith(
      updatedAt: DateTime.now(),
    );
    
    await box.put('store', updatedSettings.toJson());
    return updatedSettings;
  }
  
  /// Récupère les paramètres par catégorie
  Future<List<SettingModel>> getSettingsByCategory(String category) async {
    final allSettings = await getAllSettings();
    return allSettings.where((setting) => setting.category == category).toList();
  }
}
