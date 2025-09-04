import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/dashboard/presentation/pages/main_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/sales/presentation/pages/cart_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/employees/presentation/screens/employee_list_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/expenses/presentation/pages/expenses_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter().router;
});

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: _getInitialRoute(),
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        
        // Main shell route avec bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            return MainPage(child: child);
          },
          routes: [
            // Dashboard
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
            
            // Sales
            GoRoute(
              path: '/sales',
              name: 'sales',
              builder: (context, state) => const SalesPage(),
              routes: [
                GoRoute(
                  path: 'cart',
                  name: 'cart',
                  builder: (context, state) => const CartPage(),
                ),
              ],
            ),
            
            // Inventory
            GoRoute(
              path: '/inventory',
              name: 'inventory',
              builder: (context, state) => const InventoryPage(),
            ),
            
            // Expenses
            GoRoute(
              path: '/expenses',
              name: 'expenses',
              builder: (context, state) => const ExpensesPage(),
            ),
            
            // Employees (à implémenter)
            GoRoute(
              path: '/employees',
              name: 'employees',
              builder: (context, state) => const EmployeeListScreen(),
            ),
            
            // Settings (à implémenter)
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = _isUserLoggedIn();
        final isFirstLaunch = _isFirstLaunch();
        
        // Si c'est le premier lancement, aller à l'onboarding
        if (isFirstLaunch) {
          return '/onboarding';
        }
        
        // Si pas connecté, aller au login
        if (!isLoggedIn) {
          return '/login';
        }
        
        // Si sur login ou onboarding mais connecté, aller au dashboard
        if ((state.matchedLocation == '/login' || state.matchedLocation == '/onboarding') && isLoggedIn) {
          return '/dashboard';
        }
        
        return null;
      },
    );
  }

  String _getInitialRoute() {
    final isFirstLaunch = _isFirstLaunch();
    final isLoggedIn = _isUserLoggedIn();
    
    if (isFirstLaunch) {
      return '/onboarding';
    } else if (isLoggedIn) {
      return '/dashboard';
    } else {
      return '/login';
    }
  }

  bool _isFirstLaunch() {
    final box = Hive.box(AppConstants.settingsBox);
    return box.get(AppConstants.firstLaunchKey, defaultValue: true);
  }

  bool _isUserLoggedIn() {
    final box = Hive.box(AppConstants.authBox);
    final token = box.get(AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }
}
