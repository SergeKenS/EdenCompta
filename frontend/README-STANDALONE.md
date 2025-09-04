# 🚀 Guide d'utilisation du Frontend en Mode Standalone

## 📋 Vue d'ensemble

Ce guide explique comment tester le frontend EdenCompta indépendamment du backend, en utilisant des données simulées et un service d'authentification de développement.

## ✅ Prérequis

- Flutter SDK 3.1.0 ou supérieur
- Un éditeur de code (VS Code, Android Studio, etc.)
- Git (pour cloner le projet)

## 🚀 Démarrage rapide

### 1. Installation des dépendances

```bash
cd frontend
flutter pub get
```

### 2. Lancement en mode développement

```bash
flutter run
```

**Note importante** : Le frontend est configuré pour fonctionner en mode standalone par défaut. Vous n'avez pas besoin de démarrer le backend.

## 🔧 Configuration

### Mode de développement

Le mode standalone est activé par défaut dans `lib/core/config/dev_config.dart` :

```dart
class DevConfig {
  /// Active le mode développement (sans backend)
  static const bool enableDevMode = true;
  
  /// Utilisateur de test par défaut
  static const String defaultTestUsername = 'admin';
  static const String defaultTestPassword = 'admin';
}
```

### Basculement vers le mode production

Pour utiliser le backend réel, modifiez `enableDevMode` à `false` dans le fichier de configuration.

## 🔐 Authentification

### Identifiants de test

En mode standalone, vous pouvez vous connecter avec :

- **Username** : `admin` (ou n'importe quoi)
- **Password** : `admin` (ou n'importe quoi)

### Fonctionnalités simulées

- ✅ Connexion/déconnexion
- ✅ Stockage local des données utilisateur
- ✅ Navigation entre les écrans
- ✅ Interface utilisateur complète

## 📱 Fonctionnalités disponibles

### ✅ Écrans fonctionnels

- **Authentification** : Connexion simulée
- **Dashboard** : Interface principale
- **Inventaire** : Gestion des produits (données simulées)
- **Ventes** : Interface de vente (données simulées)

### ⚠️ Limitations en mode standalone

- Les données ne sont pas persistantes entre les sessions
- Pas de synchronisation avec une base de données
- Les opérations CRUD sont simulées
- Pas de validation côté serveur

## 🛠️ Architecture technique

### Services utilisés

- **UnifiedAuthService** : Bascule automatiquement entre le mode réel et le mode dev
- **DevAuthService** : Simule l'authentification et les opérations
- **Hive** : Stockage local des données

### Structure des données

Les modèles de données sont identiques à ceux utilisés avec le backend, permettant une transition transparente.

## 🔄 Passage en mode production

Pour basculer vers le mode production :

1. Modifiez `DevConfig.enableDevMode = false`
2. Assurez-vous que le backend est démarré sur `http://localhost:8080`
3. Redémarrez l'application

## 🐛 Dépannage

### Problèmes courants

1. **Erreur de connexion** : Vérifiez que le mode dev est activé
2. **Données manquantes** : Les données sont simulées, redémarrez l'app si nécessaire
3. **Erreurs de compilation** : Exécutez `flutter clean && flutter pub get`

### Logs de débogage

Les logs de développement sont activés par défaut. Consultez la console pour plus d'informations.

## 📚 Ressources additionnelles

- [Documentation Flutter](https://docs.flutter.dev/)
- [Documentation Riverpod](https://riverpod.dev/)
- [Documentation Hive](https://docs.hivedb.dev/)

## 🤝 Contribution

Pour contribuer au développement :

1. Testez d'abord en mode standalone
2. Assurez-vous que les tests passent
3. Testez avec le backend avant de soumettre

---

**Note** : Ce mode standalone est destiné au développement et aux tests. Pour la production, utilisez toujours le backend complet.
