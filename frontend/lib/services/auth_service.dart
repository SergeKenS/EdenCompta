import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comptab_pos/models/user.dart';
import 'package:comptab_pos/services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // Connexion utilisateur
  Future<LoginResult> login(String username, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = User.fromJson(data['user']);
        final token = data['token'] as String;

        // Sauvegarder le token et les données utilisateur
        await _saveAuthData(token, user);

        return LoginResult.success(user, token);
      } else {
        return LoginResult.failure('Échec de la connexion');
      }
    } catch (e) {
      return LoginResult.failure('Erreur de connexion: ${e.toString()}');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null;
  }

  // Obtenir l'utilisateur connecté
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      try {
        final userMap = Map<String, dynamic>.from(
          userData as Map<String, dynamic>
        );
        return User.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Obtenir le token actuel
  Future<String?> getCurrentToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Sauvegarder les données d'authentification
  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', user.toJson().toString());
  }

  // Changer le mot de passe
  Future<bool> changePassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _apiService.post('/auth/change-password', data: {
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Réinitialiser le mot de passe
  Future<bool> resetPassword(
    String userId,
    String newPassword,
    String resetBy,
  ) async {
    try {
      final response = await _apiService.post('/auth/reset-password', data: {
        'userId': userId,
        'newPassword': newPassword,
        'resetBy': resetBy,
      });

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Déverrouiller un compte
  Future<bool> unlockAccount(String userId) async {
    try {
      final response = await _apiService.post('/auth/unlock-account/$userId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Connexion par PIN pour les caissiers
  Future<LoginResult> loginWithPin(String pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPin = prefs.getString('cashier_pin');
      
      if (savedPin == pin) {
        // Créer un utilisateur caissier temporaire
        final user = User(
          id: 'cashier_${DateTime.now().millisecondsSinceEpoch}',
          username: 'caissier',
          firstName: prefs.getString('cashier_first_name') ?? '',
          lastName: prefs.getString('cashier_last_name') ?? '',
          email: '',
          role: UserRole.cashier,
          status: UserStatus.active,
          storeId: prefs.getString('store_id') ?? 'default_store',
          createdAt: DateTime.now(),
          loginAttempts: 0,
        );
        
        // Générer un token temporaire
        final token = 'cashier_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Sauvegarder les données d'authentification
        await _saveAuthData(token, user);
        
        return LoginResult.success(user, token);
      } else {
        return LoginResult.failure('Code PIN incorrect');
      }
    } catch (e) {
      return LoginResult.failure('Erreur lors de la connexion: ${e.toString()}');
    }
  }
}

// Résultat de la connexion
class LoginResult {
  final bool success;
  final User? user;
  final String? token;
  final String? errorMessage;

  LoginResult.success(this.user, this.token)
      : success = true,
        errorMessage = null;

  LoginResult.failure(this.errorMessage)
      : success = false,
        user = null,
        token = null;
}

// Provider pour AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthService(apiService);
});

// Provider pour l'état d'authentification
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

// État d'authentification
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Notifier pour l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      final user = await _authService.getCurrentUser();
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
      );
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.login(username, password);

    if (result.success) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: result.errorMessage,
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState();
  }

  Future<void> loginWithPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.loginWithPin(pin);

    if (result.success) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result.user,
        error: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: result.errorMessage,
      );
    }
  }
}
