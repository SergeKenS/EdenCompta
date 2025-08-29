# EdenCompta POS - Frontend Flutter

Application mobile Flutter pour le système de point de vente EdenCompta, inspirée de l'interface Zobaze POS.

## 🎯 Architecture

### Clean Architecture
- **Data Layer**: Repositories, data sources, models
- **Domain Layer**: Entities, use cases, repositories interfaces  
- **Presentation Layer**: Pages, widgets, providers (Riverpod)

### Stack Technique
- **Framework**: Flutter 3.1+
- **Gestion d'état**: Riverpod
- **Navigation**: GoRouter
- **HTTP**: Dio
- **Stockage local**: Hive
- **Code generation**: Freezed, Json Serializable

## 🚀 Installation

### Prérequis
- Flutter SDK 3.1.0+
- Dart 3.1.0+
- Backend Spring Boot en fonctionnement

### Configuration
1. **Cloner le projet**
   ```bash
   cd frontend
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer le code**
   ```bash
   dart run build_runner build
   ```

4. **Configurer l'API**
   Modifier `lib/core/constants/app_constants.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_BACKEND_URL:8080/api';
   ```

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📱 Fonctionnalités

### ✅ Implémentées
- **Authentification**: Login + Onboarding pour nouveau magasin
- **Dashboard**: Statistiques temps réel, cartes de données
- **Ventes**: Interface POS, panier, paiements multiples
- **Inventaire**: Gestion produits, stocks, filtres
- **Navigation**: Bottom tabs avec 5 sections principales

### 🔄 En cours
- **Employés**: Gestion équipe, présences, autorisations
- **Dépenses**: Suivi financier, cashflow
- **Reporting**: Z-reports, analyses avancées
- **Intégration API**: Connexion complète au backend

## 🎨 Interface Utilisateur

### Design inspiré de Zobaze POS
- **Couleurs**: Palette bleue (#1565C0, #2196F3) 
- **Cards**: Material 3 avec coins arrondis
- **Navigation**: Bottom tabs fixes
- **Actions**: FAB pour actions rapides
- **Feedback**: SnackBars et dialogues

### Pages principales
1. **Dashboard**: Vue d'ensemble + actions rapides
2. **Ventes**: POS avec recherche, catégories, panier
3. **Inventaire**: Liste produits avec filtres et stock
4. **Employés**: Gestion équipe (à venir)
5. **Paramètres**: Configuration (à venir)

## 🔧 Configuration Backend

### Endpoints utilisés
```
POST /api/auth/login           # Connexion
POST /api/users               # Création manager
POST /api/stores              # Création magasin
GET  /api/products            # Liste produits
GET  /api/products/top-sellers # Produits populaires
POST /api/sales/receipts      # Créer vente
GET  /api/expenses/summary    # Résumé dépenses
```

### Authentification JWT
- Token stocké dans Hive
- Auto-refresh sur expiration
- Interceptors Dio pour headers

## 📝 TODO Liste

### Priorité Haute
- [ ] Intégration API complète
- [ ] Gestion offline/sync
- [ ] Tests unitaires
- [ ] Gestion erreurs robuste

### Priorité Moyenne  
- [ ] Employees & attendance
- [ ] Expenses & cashflow tracking
- [ ] Advanced reporting
- [ ] Receipt printing

### Priorité Basse
- [ ] Multi-language support
- [ ] Dark theme
- [ ] Analytics
- [ ] Push notifications

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration (à venir)
flutter test integration_test/

# Tests de widgets
flutter test test/widget_test/
```

## 📦 Build Production

```bash
# Android
flutter build apk --release

# iOS (macOS uniquement)
flutter build ios --release
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/ma-fonctionnalite`)
3. Commit les changements (`git commit -am 'Ajouter ma fonctionnalité'`)
4. Push la branche (`git push origin feature/ma-fonctionnalite`)
5. Créer une Pull Request

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour les détails.

---

**EdenCompta POS** - Système de gestion moderne pour petits commerces 🏪
