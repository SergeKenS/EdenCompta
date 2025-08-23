# 🚀 COMPTAB POS - Frontend Flutter

Application mobile de Point de Vente (POS) moderne et professionnelle développée en Flutter/Dart pour le projet COMPTAB.

## ✨ Fonctionnalités principales

### 🔐 Authentification et sécurité
- Connexion sécurisée avec JWT
- Gestion des rôles utilisateurs (Admin, Manager, Caissier, Gestionnaire de stock)
- Authentification biométrique (empreinte digitale)
- Gestion des sessions et verrouillage de comptes

### 📊 Tableau de bord
- Vue d'ensemble des métriques de performance
- Statistiques en temps réel (ventes, stock, utilisateurs)
- Actions rapides pour accéder aux fonctionnalités principales
- Interface intuitive et responsive

### 🛒 Gestion des ventes
- Création de reçus en temps réel
- Ajout de produits au panier
- Gestion des quantités et prix
- Support de multiples méthodes de paiement
- Finalisation et impression des reçus
- Mode hors ligne avec synchronisation

### 📦 Gestion de l'inventaire
- Catalogue de produits et variantes
- Gestion des stocks en temps réel
- Alertes de stock faible et rupture
- Import/export de données
- Scanner de codes-barres et QR codes
- Gestion des catégories

### 📈 Rapports et analyses
- Rapports de ventes détaillés
- Analyses de performance par période
- Graphiques et visualisations
- Export des données (PDF, Excel)
- Métriques de rentabilité

### 👥 Gestion des utilisateurs
- Création et gestion des comptes
- Attribution des rôles et permissions
- Suivi des activités utilisateurs
- Gestion des sessions actives
- Import/export des utilisateurs

### ⚙️ Paramètres et configuration
- Personnalisation de l'interface
- Gestion des langues et devises
- Configuration des notifications
- Sauvegarde et restauration
- Mode développeur

## 🏗️ Architecture technique

### Structure du projet
```
lib/
├── main.dart                 # Point d'entrée de l'application
├── app.dart                  # Configuration des écrans
├── models/                   # Modèles de données
│   ├── user.dart            # Modèle utilisateur
│   ├── product.dart         # Modèles produit et inventaire
│   └── sales.dart           # Modèles de vente
├── services/                 # Services métier
│   ├── api_service.dart     # Service API principal
│   ├── auth_service.dart    # Service d'authentification
│   └── sales_service.dart   # Service de vente
├── screens/                  # Écrans de l'application
│   ├── login_screen.dart    # Écran de connexion
│   ├── dashboard_screen.dart # Tableau de bord
│   ├── sales_screen.dart    # Gestion des ventes
│   ├── inventory_screen.dart # Gestion de l'inventaire
│   ├── reports_screen.dart  # Rapports et analyses
│   ├── users_screen.dart    # Gestion des utilisateurs
│   └── settings_screen.dart # Paramètres
└── widgets/                  # Composants réutilisables
    ├── loading_button.dart  # Bouton avec indicateur de chargement
    ├── metric_card.dart     # Carte de métrique
    └── navigation_drawer.dart # Menu de navigation
```

### Technologies utilisées
- **Flutter 3.x** : Framework de développement cross-platform
- **Dart 3.x** : Langage de programmation
- **Riverpod** : Gestion d'état moderne et performante
- **GoRouter** : Navigation fluide et déclarative
- **Dio** : Client HTTP robuste avec intercepteurs
- **Hive** : Base de données locale pour le cache offline
- **SharedPreferences** : Stockage des préférences utilisateur

### Intégration backend
L'application s'intègre parfaitement avec votre backend Spring Boot COMPTAB via :
- **API REST** : Endpoints standardisés pour toutes les opérations
- **JWT** : Authentification sécurisée avec tokens
- **WebSocket** : Communication en temps réel (optionnel)
- **Synchronisation** : Gestion des données offline/online

## 🚀 Installation et configuration

### Prérequis
- Flutter SDK 3.0.0 ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / VS Code avec extensions Flutter
- Backend COMPTAB en cours d'exécution

### Installation
1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd comptab_pos
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration du backend**
   - Modifier `lib/services/api_service.dart`
   - Ajuster l'URL de base selon votre environnement
   ```dart
   static const String baseUrl = 'http://localhost:8080/api';
   ```

4. **Générer les fichiers de code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Lancer l'application**
   ```bash
   flutter run
   ```

### Configuration des environnements
- **Développement** : `http://localhost:8080/api`
- **Test** : `http://test-server:8080/api`
- **Production** : `https://api.comptab.com/api`

## 📱 Utilisation

### Première connexion
1. Lancer l'application
2. Saisir vos identifiants COMPTAB
3. L'application se connecte automatiquement au backend
4. Accéder au tableau de bord

### Création d'une vente
1. Aller dans l'onglet "Ventes"
2. Cliquer sur "Nouveau reçu"
3. Rechercher et ajouter des produits
4. Ajuster les quantités et prix
5. Finaliser la vente
6. Imprimer le reçu

### Gestion de l'inventaire
1. Accéder à l'onglet "Inventaire"
2. Utiliser la barre de recherche pour trouver des produits
3. Scanner les codes-barres pour un ajout rapide
4. Modifier les informations des produits
5. Surveiller les niveaux de stock

## 🔧 Développement

### Ajout de nouvelles fonctionnalités
1. **Créer le modèle** dans `lib/models/`
2. **Implémenter le service** dans `lib/services/`
3. **Créer l'écran** dans `lib/screens/`
4. **Ajouter la route** dans `main.dart`
5. **Tester** avec `flutter test`

### Structure des modèles
```dart
@JsonSerializable()
class MonModele {
  final String id;
  final String nom;
  final DateTime dateCreation;
  
  const MonModele({
    required this.id,
    required this.nom,
    required this.dateCreation,
  });
  
  factory MonModele.fromJson(Map<String, dynamic> json) => 
      _$MonModeleFromJson(json);
  Map<String, dynamic> toJson() => _$MonModeleToJson(this);
}
```

### Gestion d'état avec Riverpod
```dart
final monServiceProvider = Provider<MonService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return MonService(apiService);
});

final monStateProvider = StateNotifierProvider<MonNotifier, MonState>((ref) {
  final service = ref.read(monServiceProvider);
  return MonNotifier(service);
});
```

## 🧪 Tests

### Tests unitaires
```bash
flutter test test/unit/
```

### Tests d'intégration
```bash
flutter test test/integration/
```

### Tests de widgets
```bash
flutter test test/widget/
```

## 📦 Build et déploiement

### Build Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### Build iOS
```bash
flutter build ios --release
```

### Build Web (optionnel)
```bash
flutter build web --release
```

## 🔒 Sécurité

- **JWT** : Tokens d'authentification sécurisés
- **HTTPS** : Communication chiffrée avec le backend
- **Validation** : Vérification des données côté client et serveur
- **Permissions** : Gestion fine des droits d'accès
- **Audit** : Traçabilité de toutes les actions

## 📊 Performance

- **Lazy loading** : Chargement à la demande des données
- **Cache local** : Stockage Hive pour les données fréquemment utilisées
- **Optimisation des images** : Compression et mise en cache
- **Gestion mémoire** : Nettoyage automatique des ressources
- **Navigation fluide** : Transitions optimisées

## 🌐 Support multi-plateformes

- **Android** : API 21+ (Android 5.0+)
- **iOS** : iOS 11.0+
- **Web** : Navigateurs modernes (Chrome, Firefox, Safari, Edge)
- **Desktop** : Windows, macOS, Linux (optionnel)

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence propriétaire COMPTAB. Tous droits réservés.

## 📞 Support

- **Documentation** : Consultez ce README et les commentaires du code
- **Issues** : Signalez les bugs via GitHub Issues
- **Email** : support@comptab.com
- **Téléphone** : +225 XX XX XX XX

## 🚀 Roadmap

### Version 1.1
- [ ] Support des taxes et remises
- [ ] Gestion des clients et commandes
- [ ] Intégration des imprimantes thermiques
- [ ] Mode caisse enregistreuse

### Version 1.2
- [ ] Application mobile native (iOS/Android)
- [ ] Synchronisation cloud
- [ ] Rapports avancés avec graphiques
- [ ] Intégration des terminaux de paiement

### Version 2.0
- [ ] Intelligence artificielle pour les prévisions
- [ ] Gestion multi-magasins
- [ ] API publique pour développeurs
- [ ] Marketplace d'applications

---

**COMPTAB POS** - Votre solution POS moderne et professionnelle 🎯
