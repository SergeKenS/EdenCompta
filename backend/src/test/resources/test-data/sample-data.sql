-- Créer un magasin de test
INSERT INTO stores (id, name, address, phone, created_at, updated_at)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Magasin Test', '123 Rue Test', '0123456789', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Créer des produits de test
INSERT INTO products (id, store_id, name, description, category, is_active, created_at, updated_at)
VALUES
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Produit A', 'Description A', 'FOOD', true, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'Produit B', 'Description B', 'FOOD', true, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Créer des variantes de test
INSERT INTO product_variants (id, product_id, sku, name, barcode, is_active, created_at, updated_at)
VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 'SKU-A-001', 'Variante A1', '1234567890123', true, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'SKU-A-002', 'Variante A2', '1234567890124', true, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', 'SKU-B-001', 'Variante B1', '1234567890125', true, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Données RBAC pour les tests
-- Créer les rôles
INSERT INTO roles (id, "key", name, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440100', 'MANAGER', 'Gestionnaire', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440101', 'CASHIER', 'Caissier', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440102', 'STOCK_CLERK', 'Employé de stock', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Créer les permissions
INSERT INTO permissions (id, "key", name, created_at, updated_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440200', 'INVENTORY.ADD', 'Ajouter des produits', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440201', 'INVENTORY.EDIT', 'Modifier des produits', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440202', 'INVENTORY.DELETE', 'Supprimer des produits', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440203', 'INVENTORY.RECEIVE', 'Réceptionner des marchandises', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440204', 'SALE.MAKE', 'Effectuer des ventes', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440205', 'SALE.REFUND', 'Effectuer des remboursements', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440206', 'CASH.OPEN', 'Ouvrir une session de caisse', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440207', 'CASH.CLOSE', 'Fermer une session de caisse', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440208', 'REPORTS.VIEW', 'Consulter les rapports', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
  ('550e8400-e29b-41d4-a716-446655440209', 'SETTINGS.MANAGE', 'Gérer les paramètres', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- Liaison des rôles aux permissions
-- MANAGER : toutes les permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440200'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440201'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440202'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440203'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440204'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440205'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440206'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440207'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440208'),
  ('550e8400-e29b-41d4-a716-446655440100', '550e8400-e29b-41d4-a716-446655440209');

-- CASHIER : permissions de vente et caisse
INSERT INTO role_permissions (role_id, permission_id) VALUES
  ('550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440204'),
  ('550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440205'),
  ('550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440206'),
  ('550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440207');

-- STOCK_CLERK : permissions d'inventaire
INSERT INTO role_permissions (role_id, permission_id) VALUES
  ('550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440200'),
  ('550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440201'),
  ('550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440203');

-- Créer un utilisateur de test avec les permissions nécessaires
INSERT INTO users (id, username, email, password_hash, first_name, last_name, role, status, store_id, created_at, updated_at, created_by)
VALUES ('550e8400-e29b-41d4-a716-446655440300', 'admin', 'admin@test.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'Admin', 'Test', 'MANAGER', 'ACTIVE', '550e8400-e29b-41d4-a716-446655440000', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 'system');

-- Attribuer le rôle MANAGER à l'utilisateur admin
INSERT INTO user_roles (id, user_id, role_id, created_at, created_by)
VALUES ('550e8400-e29b-41d4-a716-446655440400', '550e8400-e29b-41d4-a716-446655440300', '550e8400-e29b-41d4-a716-446655440100', CURRENT_TIMESTAMP(), 'system');