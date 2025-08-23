# POS Backend - API Documentation

## Vue d'ensemble

Backend Spring Boot pour système de Point de Vente (POS) avec gestion complète des magasins, utilisateurs, inventaire, ventes, sessions de caisse et flux de trésorerie.

## Technologies

- **Spring Boot 3.2.0** avec Java 17
- **PostgreSQL** (production) / **H2** (tests)
- **Flyway** pour les migrations
- **JWT** pour l'authentification
- **Spring Security** avec RBAC

## Installation

```bash
# Cloner le projet
git clone <repository-url>
cd Comptab

# Configurer la base de données PostgreSQL
# Créer la base 'pos_db' et l'utilisateur 'pos_user'

# Lancer l'application
mvn spring-boot:run
```

## Configuration

### Base de données
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/pos_db
    username: pos_user
    password: pos_password
```

### JWT
```yaml
app:
  jwt:
    secret: votre-secret-jwt-super-securise
    expiration: 86400000  # 24h
```

## API Endpoints

### 🔐 Authentification

#### POST /api/auth/login
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Réponse :**
```json
{
  "success": true,
  "message": "Connexion réussie",
  "user": {
    "id": "uuid",
    "username": "admin",
    "role": "ADMIN",
    "storeId": "uuid"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

### 👥 Utilisateurs

#### GET /api/users
**Headers :** `Authorization: Bearer <token>`

#### POST /api/users
```json
{
  "username": "nouveau_user",
  "password": "password123",
  "role": "CASHIER",
  "storeId": "uuid"
}
```

### 🏪 Magasins

#### GET /api/stores
#### GET /api/stores/{storeId}

### 📦 Inventaire

#### GET /api/inventory/products
#### POST /api/inventory/products
```json
{
  "name": "Produit Test",
  "description": "Description du produit",
  "category": "FOOD",
  "storeId": "uuid"
}
```

#### GET /api/inventory/variants
#### POST /api/inventory/variants
```json
{
  "productId": "uuid",
  "name": "Variante 1",
  "sku": "SKU-001",
  "barcode": "1234567890123"
}
```

### 🛒 Ventes

#### POST /api/sales/receipts
```json
{
  "storeId": "uuid",
  "lines": [
    {
      "variantId": "uuid",
      "quantity": 2,
      "unitPrice": 10.50
    }
  ],
  "paymentMethod": "CASH",
  "createdBy": "user123"
}
```

#### GET /api/sales/receipts/{receiptId}

### 📥 Réception

#### POST /api/receiving/receipts
```json
{
  "storeId": "uuid",
  "sourceOfflineId": "OFFLINE-001",
  "createdBy": "user123"
}
```

#### POST /api/receiving/receipts/{receiptId}/lines
```json
{
  "variantId": "uuid",
  "quantity": 100,
  "unitCost": 5.25,
  "batchNumber": "BATCH-001",
  "notes": "Réception normale"
}
```

### 💰 Flux de Trésorerie

#### POST /api/cashflow/stores/{storeId}/cash-in
```json
{
  "reason": "SALES",
  "amount": 1500.00,
  "reference": "RECEIPT-001",
  "referenceType": "RECEIPT",
  "description": "Vente du jour",
  "createdBy": "user123",
  "sourceOfflineId": "OFFLINE-001"
}
```

#### POST /api/cashflow/stores/{storeId}/cash-out
```json
{
  "reason": "EXPENSE",
  "amount": 250.00,
  "reference": "EXPENSE-001",
  "referenceType": "EXPENSE",
  "description": "Achat fournitures",
  "createdBy": "user123",
  "sourceOfflineId": "OFFLINE-002"
}
```

#### GET /api/cashflow/stores/{storeId}/summary?startDate=2024-01-01T00:00:00&endDate=2024-01-31T23:59:59

### 💼 Sessions de Caisse

#### POST /api/sessions/cash/open
```json
{
  "storeId": "uuid",
  "initialAmount": 1000.00,
  "userId": "user123"
}
```

#### POST /api/sessions/cash/{sessionId}/close
```json
{
  "realClosingAmount": 1250.00,
  "note": "Fermeture normale"
}
```

#### POST /api/sessions/cash/{sessionId}/movements
```json
{
  "type": "IN",
  "reason": "SALES",
  "amount": 150.00,
  "reference": "RECEIPT-001",
  "referenceType": "RECEIPT",
  "createdBy": "user123"
}
```

### 📊 Reporting

#### GET /api/reporting/daily-summary?storeId=uuid&date=2024-01-15
#### GET /api/reporting/session-totals?sessionId=uuid
#### GET /api/reporting/z-report?storeId=uuid&startDate=2024-01-01T00:00:00&endDate=2024-01-31T23:59:59

### 💸 Dépenses

#### POST /api/expenses
```json
{
  "storeId": "uuid",
  "category": "UTILITIES",
  "description": "Facture électricité",
  "amount": 150.00,
  "paymentMethod": "BANK_TRANSFER",
  "reference": "INV-001",
  "notes": "Facture mensuelle",
  "createdBy": "user123"
}
```

#### GET /api/expenses?storeId=uuid&status=PENDING

## Rôles et Permissions

- **SUPER_ADMIN** : Accès complet
- **ADMIN** : Gestion magasin + reporting
- **MANAGER** : Gestion équipe + reporting
- **CASHIER** : Ventes + sessions de caisse

## Codes d'Erreur

- `400` : Requête invalide
- `401` : Non authentifié
- `403` : Non autorisé
- `404` : Ressource non trouvée
- `409` : Conflit (ex: idempotence)
- `500` : Erreur serveur

## Tests

```bash
# Tests unitaires
mvn test

# Tests d'intégration
mvn test -Dtest=*IntegrationTest

# Tests avec couverture
mvn test jacoco:report
```

## Déploiement

```bash
# Build
mvn clean package

# Docker
docker build -t pos-backend .
docker run -p 8080:8080 pos-backend
```

## Prochaines Étapes

1. ✅ Backend complet (95%)
2. 🔄 Tests d'intégration complets
3. 📱 Frontend Flutter (priorité)
4. 🚀 Déploiement production
5. 📈 Monitoring & métriques


