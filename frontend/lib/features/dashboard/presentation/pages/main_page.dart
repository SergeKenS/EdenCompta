import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class MainPage extends StatefulWidget {
  final Widget child;
  
  const MainPage({
    super.key,
    required this.child,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    _NavigationItem(
      icon: Icons.shopping_cart,
      label: 'Ventes',
      route: '/sales',
    ),
    _NavigationItem(
      icon: Icons.inventory,
      label: 'Inventaire',
      route: '/inventory',
    ),
    _NavigationItem(
      icon: Icons.people,
      label: 'Employés',
      route: '/employees',
    ),
    _NavigationItem(
      icon: Icons.settings,
      label: 'Paramètres',
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        backgroundColor: Colors.white,
        elevation: 8,
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final route = _navigationItems[index].route;
    context.go(route);
  }
}

class _NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  _NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
