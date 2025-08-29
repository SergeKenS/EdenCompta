import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/services/onboarding_service.dart';

// Provider pour le service d'onboarding
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return OnboardingService(dioClient);
});

// Notifier pour gérer l'état d'onboarding
class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  final OnboardingService _onboardingService;

  OnboardingNotifier(this._onboardingService) : super(const AsyncValue.data(null));

  /// Crée un magasin et son manager
  Future<OnboardingResponse> createStoreAndManager({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String storeName,
    String? storeAddress,
    String? storePhone,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _onboardingService.createStoreAndManager(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        storeName: storeName,
        storeAddress: storeAddress,
        storePhone: storePhone,
      );
      
      state = const AsyncValue.data(null);
      return response;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Vérifie si un email est disponible
  Future<bool> checkEmailAvailability(String email) async {
    try {
      return await _onboardingService.isEmailAvailable(email);
    } catch (error) {
      return false; // En cas d'erreur, considérer comme non disponible
    }
  }
}

// Provider pour le notifier d'onboarding
final onboardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
  final onboardingService = ref.read(onboardingServiceProvider);
  return OnboardingNotifier(onboardingService);
});

// Provider pour l'état de chargement de l'onboarding
final onboardingLoadingProvider = Provider<bool>((ref) {
  return ref.watch(onboardingNotifierProvider).isLoading;
});

// Provider pour l'erreur d'onboarding
final onboardingErrorProvider = Provider<String?>((ref) {
  final onboardingState = ref.watch(onboardingNotifierProvider);
  return onboardingState.when(
    data: (_) => null,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
});
