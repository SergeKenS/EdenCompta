import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/unified_auth_service.dart';

// Provider pour le service d'authentification
final authServiceProvider = Provider<UnifiedAuthService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return UnifiedAuthService(dioClient);
});

// Provider pour l'état de l'utilisateur connecté
final currentUserProvider = StateProvider<UserModel?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.getCurrentUser();
});

// Provider pour l'état de connexion
final isLoggedInProvider = Provider<bool>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.isLoggedIn();
});

// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final UnifiedAuthService _authService;

  AuthNotifier(this._authService) : super(const AsyncValue.data(null)) {
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final user = _authService.getCurrentUser();
    state = AsyncValue.data(user);
  }

  /// Effectue la connexion
  Future<LoginResponseModel> login(String username, String password) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _authService.login(username, password);
      
      if (response.success && response.user != null) {
        state = AsyncValue.data(response.user);
      } else {
        state = const AsyncValue.data(null);
      }
      
      return response;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    try {
      await _authService.logout();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Change le mot de passe
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _authService.changePassword(currentPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  /// Rafraîchit l'état de l'utilisateur
  void refresh() {
    _loadCurrentUser();
  }
}

// Provider pour le notifier d'authentification
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

// Provider pour l'état de chargement de l'authentification
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

// Provider pour l'erreur d'authentification
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (_) => null,
    loading: () => null,
    error: (error, _) => error.toString(),
  );
});
