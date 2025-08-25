import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comptab_pos/services/api_service.dart';

class SetupService {
  final ApiService _apiService;

  SetupService(this._apiService);

  // Vérifier si c'est la première connexion
  Future<bool> isFirstTimeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    final setupCompleted = prefs.getBool('setup_completed');
    return setupCompleted != true;
  }

  // Marquer la configuration comme terminée
  Future<void> markSetupAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setup_completed', true);
  }

  // Sauvegarder les informations de la caissière
  Future<bool> saveCashierInfo({
    required String firstName,
    required String lastName,
    required String pin,
  }) async {
    try {
      // Sauvegarder uniquement en local pour le moment
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cashier_first_name', firstName);
      await prefs.setString('cashier_last_name', lastName);
      await prefs.setString('cashier_pin', pin);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sauvegarder les informations du magasin
  Future<bool> saveStoreInfo({
    required String storeName,
    required String address,
    required String phone,
    required String email,
  }) async {
    try {
      // Sauvegarder uniquement en local pour le moment
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('store_name', storeName);
      await prefs.setString('store_address', address);
      await prefs.setString('store_phone', phone);
      await prefs.setString('store_email', email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sauvegarder les moyens de paiement
  Future<bool> savePaymentMethods(List<String> paymentMethods) async {
    try {
      // Sauvegarder uniquement en local pour le moment
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('payment_methods', paymentMethods);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Enregistrer le device
  Future<bool> registerDevice({
    required String deviceName,
    required String deviceId,
  }) async {
    try {
      // Sauvegarder uniquement en local pour le moment
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_name', deviceName);
      await prefs.setString('device_id', deviceId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtenir les informations sauvegardées
  Future<Map<String, String?>> getSavedSetupInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'cashier_first_name': prefs.getString('cashier_first_name'),
      'cashier_last_name': prefs.getString('cashier_last_name'),
      'store_name': prefs.getString('store_name'),
      'store_address': prefs.getString('store_address'),
      'store_phone': prefs.getString('store_phone'),
      'store_email': prefs.getString('store_email'),
      'device_name': prefs.getString('device_name'),
      'device_id': prefs.getString('device_id'),
    };
  }

  // Obtenir les moyens de paiement sauvegardés
  Future<List<String>> getSavedPaymentMethods() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('payment_methods') ?? [];
  }
}

// Provider pour SetupService
final setupServiceProvider = Provider<SetupService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return SetupService(apiService);
});

// Provider pour l'état de configuration
final setupStateProvider = StateNotifierProvider<SetupNotifier, SetupState>((ref) {
  final setupService = ref.read(setupServiceProvider);
  return SetupNotifier(setupService);
});

// État de configuration
class SetupState {
  final bool isLoading;
  final bool isFirstTime;
  final int currentStep;
  final String? error;
  final Map<String, String?> setupInfo;

  const SetupState({
    this.isLoading = false,
    this.isFirstTime = true,
    this.currentStep = 0,
    this.error,
    this.setupInfo = const {},
  });

  SetupState copyWith({
    bool? isLoading,
    bool? isFirstTime,
    int? currentStep,
    String? error,
    Map<String, String?>? setupInfo,
  }) {
    return SetupState(
      isLoading: isLoading ?? this.isLoading,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      currentStep: currentStep ?? this.currentStep,
      error: error ?? this.error,
      setupInfo: setupInfo ?? this.setupInfo,
    );
  }
}

// Notifier pour l'état de configuration
class SetupNotifier extends StateNotifier<SetupState> {
  final SetupService _setupService;

  SetupNotifier(this._setupService) : super(const SetupState()) {
    _checkSetupStatus();
  }

  Future<void> _checkSetupStatus() async {
    final isFirstTime = await _setupService.isFirstTimeSetup();
    final setupInfo = await _setupService.getSavedSetupInfo();
    
    state = state.copyWith(
      isFirstTime: isFirstTime,
      setupInfo: setupInfo,
    );
  }

  Future<void> nextStep() async {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> completeSetup() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _setupService.markSetupAsCompleted();
      state = state.copyWith(
        isLoading: false,
        isFirstTime: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de la finalisation de la configuration',
      );
    }
  }
}
