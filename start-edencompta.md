# 🚀 Guide de démarrage - EdenCompta POS

## 📋 Prérequis

### **Logiciels requis :**
- ☕ **Java 17** (pour le backend Spring Boot)
- 🎯 **Maven 3.6+** (gestion des dépendances Java)
- 🐘 **PostgreSQL 15+** (base de données)
- 🎨 **Flutter 3.1+** (pour le frontend)
- 🐳 **Docker** (optionnel, mais recommandé pour PostgreSQL)

## 🗄️ **Étape 1 : Démarrer la base de données PostgreSQL**

### **Option A : Avec Docker (Recommandé)**

```bash
# Aller dans le répertoire backend
cd backend

# Démarrer PostgreSQL avec Docker Compose
docker-compose up -d

# Vérifier que PostgreSQL est démarré
docker-compose ps
```

### **Option B : Installation locale PostgreSQL**

Si vous préférez installer PostgreSQL localement :

1. **Installer PostgreSQL 15+**
2. **Créer la base de données :**
```sql
CREATE DATABASE pos_db;
CREATE USER pos_user WITH PASSWORD 'pos_password';
GRANT ALL PRIVILEGES ON DATABASE pos_db TO pos_user;
```

## ⚙️ **Étape 2 : Démarrer le Backend (Spring Boot)**

```bash
# Dans le répertoire backend
cd backend

# Installer les dépendances et démarrer
mvn clean install
mvn spring-boot:run

# Alternative avec Maven Wrapper (si disponible)
./mvnw spring-boot:run
```

**Le backend démarre sur :** `http://localhost:8080`

### **🔍 Vérification du backend :**
- **Health check :** `http://localhost:8080/actuator/health`
- **API docs :** `http://localhost:8080/swagger-ui/index.html`

## 📱 **Étape 3 : Démarrer le Frontend (Flutter)**

```bash
# Dans le répertoire frontend
cd frontend

# Installer les dépendances
flutter pub get

# Générer les fichiers de code (si nécessaire)
dart run build_runner build

# Démarrer l'application
flutter run -d web
# ou pour une application bureau
flutter run -d windows
```

**Le frontend démarre sur :** `http://localhost:3000` (ou port assigné par Flutter)

## 🔐 **Comptes de test disponibles**

Le système est initialisé avec des comptes de test :

### **Super Administrateur :**
- **Email :** `admin@pos.com`
- **Username :** `admin`
- **Mot de passe :** `admin123`
- **Rôle :** SUPER_ADMIN

### **Manager :**
- **Email :** `manager1@pos.com`
- **Username :** `manager1`
- **Mot de passe :** `admin123`
- **Rôle :** MANAGER

### **Caissier :**
- **Email :** `cashier1@pos.com`
- **Username :** `cashier1`
- **Mot de passe :** `admin123`
- **Rôle :** CASHIER

### **Gestionnaire Stock :**
- **Email :** `stock1@pos.com`
- **Username :** `stock1`
- **Mot de passe :** `admin123`
- **Rôle :** STOCK_MANAGER

## 🎯 **Utilisation de l'application**

### **Premier démarrage :**

1. **Ouvrir le frontend** dans votre navigateur
2. **Choisir :** "J'ai déjà un compte" (pour utiliser les comptes de test)
3. **Se connecter avec :** `admin@pos.com` / `admin123`
4. **Explorer l'interface** : Dashboard, Inventaire, Ventes, etc.

### **Créer un nouveau magasin :**

1. **Choisir :** "Créer mon magasin" sur la page de connexion
2. **Remplir** les informations demandées
3. **Se connecter** avec l'email utilisé lors de la création

## 🔧 **Résolution de problèmes**

### **Backend ne démarre pas :**

```bash
# Vérifier Java
java -version

# Vérifier Maven
mvn -version

# Vérifier PostgreSQL
docker-compose logs postgres
```

### **Frontend ne démarre pas :**

```bash
# Vérifier Flutter
flutter doctor

# Nettoyer et reinstaller
flutter clean
flutter pub get
```

### **Problèmes de base de données :**

```bash
# Redémarrer PostgreSQL
docker-compose down
docker-compose up -d

# Vérifier les logs
docker-compose logs postgres
```

### **Erreurs de connexion frontend/backend :**

1. **Vérifier** que le backend est sur `http://localhost:8080`
2. **Vérifier** le fichier `frontend/lib/core/constants/app_constants.dart`
3. **S'assurer** que `baseUrl = 'http://localhost:8080/api'`

## 📚 **Documentation API**

Une fois le backend démarré, la documentation Swagger est disponible sur :
`http://localhost:8080/swagger-ui/index.html`

## 🛠️ **Architecture technique**

### **Backend :**
- **Framework :** Spring Boot 3.2.0
- **Base de données :** PostgreSQL 15
- **Migration :** Flyway
- **Sécurité :** JWT + Spring Security
- **Port :** 8080

### **Frontend :**
- **Framework :** Flutter 3.1+
- **État :** Riverpod
- **Navigation :** GoRouter
- **Storage :** Hive
- **HTTP :** Dio

## 🚀 **Prêt à utiliser !**

Votre application EdenCompta POS est maintenant fonctionnelle !

**URLs importantes :**
- **Frontend :** `http://localhost:3000` (ou port Flutter)
- **Backend API :** `http://localhost:8080/api`
- **API Docs :** `http://localhost:8080/swagger-ui/index.html`
- **Database :** `localhost:5432/pos_db`
