import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'permission_service.dart';
import '../widgets/access_denied_dialog.dart';

mixin PageProtectionMixin<T extends StatefulWidget> on State<T> {
  
  /// Vérifie si l'utilisateur peut accéder à la page et affiche un message d'erreur si nécessaire
  bool checkAccess(bool hasPermission) {
    if (!hasPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessDeniedDialog.show(context).then((_) {
          // Retourner à la page précédente après avoir fermé le popup
          if (context.mounted) {
            context.go('/dashboard');
          }
        });
      });
      return false;
    }
    return true;
  }
  
  /// Vérifie l'accès aux employés
  bool checkEmployeesAccess() {
    return checkAccess(PermissionService.canAccessEmployees());
  }
  
  /// Vérifie l'accès aux paramètres
  bool checkSettingsAccess() {
    return checkAccess(PermissionService.canAccessSettings());
  }
  
  /// Vérifie l'accès aux clients
  bool checkCustomersAccess() {
    return checkAccess(PermissionService.canAccessCustomers());
  }
  
  /// Vérifie l'accès aux produits les plus vendus
  bool checkTopProductsAccess() {
    return checkAccess(PermissionService.canAccessTopProducts());
  }
  
  /// Vérifie l'accès et initialise la page si autorisé
  bool checkAccessAndInitialize(bool hasPermission, VoidCallback onInitialize) {
    if (hasPermission) {
      onInitialize();
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessDeniedDialog.show(context).then((_) {
          // Retourner à la page précédente après avoir fermé le popup
          if (context.mounted) {
            context.go('/dashboard');
          }
        });
      });
      return false;
    }
  }
}
