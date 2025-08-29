# Système RBAC (Role-Based Access Control) - EdenCompta

## Vue d'ensemble

Le système RBAC a été ajouté de manière non-intrusive au projet existant pour fournir un contrôle d'accès granulaire basé sur les permissions. Il s'intègre parfaitement avec l'architecture existante sans casser les fonctionnalités actuelles.

## Architecture

### Tables de base de données

- `roles` : Définition des rôles (MANAGER, CASHIER, STOCK_CLERK)
- `permissions` : Définition des permissions granulaire
- `role_permissions` : Liaison entre rôles et permissions
- `user_roles` : Attribution des rôles aux utilisateurs

### Entités JPA

- `Role` : Entité pour les rôles
- `Permission` : Entité pour les permissions
- `UserRole` : Entité de liaison utilisateur-rôle

### Services

- `AuthorizationService` : Service principal pour la gestion des autorisations
- `CustomUserDetailsService` : Intégration avec Spring Security

## Permissions disponibles

### Inventaire
- `INVENTORY.ADD` : Ajouter des produits
- `INVENTORY.EDIT` : Modifier des produits
- `INVENTORY.DELETE` : Supprimer des produits
- `INVENTORY.RECEIVE` : Réceptionner des marchandises

### Ventes
- `SALE.MAKE` : Effectuer des ventes
- `SALE.REFUND` : Effectuer des remboursements

### Caisse
- `CASH.OPEN` : Ouvrir une session de caisse
- `CASH.CLOSE` : Fermer une session de caisse

### Rapports
- `REPORTS.VIEW` : Consulter les rapports

### Configuration
- `SETTINGS.MANAGE` : Gérer les paramètres

## Rôles et permissions

### MANAGER
- **Toutes les permissions** : Accès complet à toutes les fonctionnalités

### CASHIER
- `SALE.MAKE` : Effectuer des ventes
- `SALE.REFUND` : Effectuer des remboursements
- `CASH.OPEN` : Ouvrir une session de caisse
- `CASH.CLOSE` : Fermer une session de caisse

### STOCK_CLERK
- `INVENTORY.ADD` : Ajouter des produits
- `INVENTORY.EDIT` : Modifier des produits
- `INVENTORY.RECEIVE` : Réceptionner des marchandises

## Utilisation

### Backend - Annotations @PreAuthorize

```java
@PreAuthorize("hasAuthority('INVENTORY.ADD')")
@PostMapping("/inventory/items")
public ResponseEntity<ItemDto> createItem(@RequestBody CreateItemRequest request) {
    // Logique métier
}

@PreAuthorize("hasAuthority('SALE.MAKE')")
@PostMapping("/sales/receipts")
public ResponseEntity<ReceiptDto> createReceipt(@RequestBody CreateReceiptRequest request) {
    // Logique métier
}

@PreAuthorize("hasAuthority('REPORTS.VIEW')")
@GetMapping("/reporting/z-report")
public ResponseEntity<ZReportDto> generateZReport(@RequestParam UUID storeId) {
    // Logique métier
}
```

### Endpoint pour récupérer les permissions

```http
GET /api/users/me/permissions
Authorization: Bearer <jwt-token>

Response:
["INVENTORY.ADD", "SALE.MAKE", "CASH.OPEN", ...]
```

### Service d'autorisation

```java
@Autowired
private AuthorizationService authorizationService;

// Vérifier une permission
boolean canAddInventory = authorizationService.hasPermission(userId, "INVENTORY.ADD");

// Vérifier plusieurs permissions (au moins une)
boolean canManageInventory = authorizationService.hasAnyPermission(userId, 
    "INVENTORY.ADD", "INVENTORY.EDIT", "INVENTORY.DELETE");

// Récupérer toutes les permissions
Set<String> permissions = authorizationService.getPermissionsForUser(userId);
```

## Migration et déploiement

### Migration Flyway

La migration `V8__rbac.sql` :
1. Crée les tables RBAC
2. Insère les rôles et permissions de base
3. Mappe les utilisateurs existants vers les nouveaux rôles
4. Utilise des upserts pour éviter les doublons

### Déploiement sécurisé

1. **Feature Flag** : Les annotations `@PreAuthorize` peuvent être activées progressivement
2. **Fallback** : Le système existant continue de fonctionner
3. **Compatibilité** : Les utilisateurs existants sont automatiquement mappés

## Tests

### Tests d'intégration

```bash
# Lancer les tests RBAC
mvn test -Dtest=RbacIntegrationTest

# Tests spécifiques
mvn test -Dtest=RbacIntegrationTest#testManagerHasAllPermissions
```

### Tests manuels

1. Créer un utilisateur CASHIER
2. Vérifier qu'il peut accéder aux ventes mais pas aux rapports
3. Tester l'endpoint `/api/users/me/permissions`

## Ajout d'une nouvelle permission

### 1. Ajouter la permission en base

```sql
INSERT INTO permissions (key, name) VALUES 
('NEW_FEATURE.ACCESS', 'Accéder à la nouvelle fonctionnalité');
```

### 2. Lier aux rôles

```sql
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.key = 'MANAGER' AND p.key = 'NEW_FEATURE.ACCESS';
```

### 3. Utiliser dans le code

```java
@PreAuthorize("hasAuthority('NEW_FEATURE.ACCESS')")
@GetMapping("/new-feature")
public ResponseEntity<NewFeatureDto> getNewFeature() {
    // Logique métier
}
```

### 4. Tester

```java
@Test
void testNewFeaturePermission() {
    assertThat(authorizationService.hasPermission(userId, "NEW_FEATURE.ACCESS")).isTrue();
}
```

## Bonnes pratiques

### Sécurité
- **Toujours vérifier côté serveur** : Les contrôles frontend sont uniquement pour l'UX
- **Utiliser des permissions granulaire** : Éviter les permissions trop larges
- **Logger les actions sensibles** : Tracer les accès aux fonctionnalités critiques

### Performance
- **Cache des permissions** : Les permissions sont mises en cache par utilisateur
- **Requêtes optimisées** : Utilisation de requêtes SQL optimisées pour les permissions

### Maintenance
- **Documentation** : Maintenir cette documentation à jour
- **Tests** : Ajouter des tests pour chaque nouvelle permission
- **Migration** : Toujours tester les migrations en environnement de développement

## Dépannage

### Problèmes courants

1. **Permission refusée** : Vérifier que l'utilisateur a le bon rôle
2. **Cache obsolète** : Redémarrer l'application pour vider le cache
3. **Migration échouée** : Vérifier les logs Flyway

### Logs utiles

```yaml
logging:
  level:
    com.votreentreprise.pos.rbac: DEBUG
    org.springframework.security: DEBUG
```

## Évolution future

- **Permissions dynamiques** : Interface d'administration pour gérer les permissions
- **Permissions contextuelles** : Permissions basées sur le magasin ou l'heure
- **Audit trail** : Traçabilité complète des accès et modifications
