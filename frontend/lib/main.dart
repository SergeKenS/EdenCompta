import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comptab_pos/app.dart';
import 'package:comptab_pos/services/auth_service.dart';
import 'package:comptab_pos/services/setup_service.dart';
import 'package:comptab_pos/screens/setup_screen.dart';
import 'package:comptab_pos/screens/pin_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive pour la base de données locale
  await Hive.initFlutter();
  
  // Initialiser SharedPreferences
  await SharedPreferences.getInstance();
  
  runApp(
    const ProviderScope(
      child: ComptabPosApp(),
    ),
  );
}

class ComptabPosApp extends ConsumerWidget {
  const ComptabPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final setupState = ref.watch(setupStateProvider);
    
    return MaterialApp.router(
      title: 'COMPTAB POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // fontFamily: 'Roboto', // Commenté jusqu'à ce que les polices soient disponibles
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // fontFamily: 'Roboto', // Commenté jusqu'à ce que les polices soient disponibles
      ),
      themeMode: ThemeMode.system,
      routerConfig: _createRouter(authState, setupState),
    );
  }

  GoRouter _createRouter(AuthState authState, SetupState setupState) {
    return GoRouter(
      initialLocation: _getInitialLocation(authState, setupState),
      redirect: (context, state) {
        return _handleRedirect(context, state, authState, setupState);
      },
      routes: [
        GoRoute(
          path: '/setup',
          name: 'setup',
          builder: (context, state) => const SetupScreen(),
        ),
        GoRoute(
          path: '/pin-login',
          name: 'pin-login',
          builder: (context, state) => const PinLoginScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          builder: (context, state) => const SalesScreen(),
        ),
        GoRoute(
          path: '/inventory',
          name: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/users',
          name: 'users',
          builder: (context, state) => const UsersScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }

  String _getInitialLocation(AuthState authState, SetupState setupState) {
    // Si c'est la première fois, aller à l'assistant de configuration
    if (setupState.isFirstTime) {
      return '/setup';
    }
    
    // Si l'utilisateur est authentifié, aller au dashboard
    if (authState.isAuthenticated) {
      return '/dashboard';
    }
    
    // Sinon, aller à la connexion par PIN
    return '/pin-login';
  }

  String? _handleRedirect(BuildContext context, GoRouterState state, AuthState authState, SetupState setupState) {
    final currentLocation = state.matchedLocation;
    
    // Si c'est la première fois et qu'on n'est pas sur /setup
    if (setupState.isFirstTime && currentLocation != '/setup') {
      return '/setup';
    }
    
    // Si la configuration est terminée mais pas connecté
    if (!setupState.isFirstTime && !authState.isAuthenticated) {
      if (currentLocation != '/pin-login') {
        return '/pin-login';
      }
    }
    
    // Si connecté et sur une page de connexion
    if (authState.isAuthenticated && (currentLocation == '/pin-login' || currentLocation == '/setup')) {
      return '/dashboard';
    }
    
    return null;
  }
}
