-- Migration V8: RBAC (Role-Based Access Control) System
-- Ajout du système de permissions granulaire

-- Table des rôles
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "key" VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(128) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des permissions
CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "key" VARCHAR(64) NOT NULL UNIQUE,
    name VARCHAR(128) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table de liaison rôles-permissions
CREATE TABLE role_permissions (
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- Table de liaison utilisateurs-rôles
CREATE TABLE user_roles (
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Index pour les performances
CREATE INDEX idx_roles_key ON roles(key);
CREATE INDEX idx_permissions_key ON permissions(key);
CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_role_permissions_permission_id ON role_permissions(permission_id);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);

-- Triggers pour updated_at
CREATE OR REPLACE FUNCTION update_roles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_permissions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_roles_updated_at
    BEFORE UPDATE ON roles
    FOR EACH ROW
    EXECUTE FUNCTION update_roles_updated_at();

CREATE TRIGGER trigger_permissions_updated_at
    BEFORE UPDATE ON permissions
    FOR EACH ROW
    EXECUTE FUNCTION update_permissions_updated_at();

-- Insertion des rôles de base (upsert pour éviter les doublons)
INSERT INTO roles ("key", name) VALUES
    ('MANAGER', 'Gestionnaire'),
    ('CASHIER', 'Caissier'),
    ('STOCK_CLERK', 'Employé de stock')
ON CONFLICT ("key") DO NOTHING;

-- Insertion des permissions de base (upsert pour éviter les doublons)
INSERT INTO permissions ("key", name) VALUES
    -- Permissions d'inventaire
    ('INVENTORY.ADD', 'Ajouter des produits'),
    ('INVENTORY.EDIT', 'Modifier des produits'),
    ('INVENTORY.DELETE', 'Supprimer des produits'),
    ('INVENTORY.RECEIVE', 'Réceptionner des marchandises'),
    
    -- Permissions de vente
    ('SALE.MAKE', 'Effectuer des ventes'),
    ('SALE.REFUND', 'Effectuer des remboursements'),
    
    -- Permissions de caisse
    ('CASH.OPEN', 'Ouvrir une session de caisse'),
    ('CASH.CLOSE', 'Fermer une session de caisse'),
    
    -- Permissions de rapports
    ('REPORTS.VIEW', 'Consulter les rapports'),
    
    -- Permissions de configuration
    ('SETTINGS.MANAGE', 'Gérer les paramètres')
ON CONFLICT ("key") DO NOTHING;

-- Liaison des rôles aux permissions
-- MANAGER : toutes les permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r."key" = 'MANAGER'
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- CASHIER : permissions de vente et caisse
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r."key" = 'CASHIER' 
  AND p."key" IN ('SALE.MAKE', 'SALE.REFUND', 'CASH.OPEN', 'CASH.CLOSE')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- STOCK_CLERK : permissions d'inventaire
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r."key" = 'STOCK_CLERK' 
  AND p."key" IN ('INVENTORY.ADD', 'INVENTORY.EDIT', 'INVENTORY.RECEIVE')
ON CONFLICT (role_id, permission_id) DO NOTHING;

-- Attribution automatique des rôles aux utilisateurs existants basée sur leur role actuel
-- MANAGER existant → rôle MANAGER
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u, roles r
WHERE u.role = 'MANAGER' AND r."key" = 'MANAGER'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- CASHIER existant → rôle CASHIER
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u, roles r
WHERE u.role = 'CASHIER' AND r."key" = 'CASHIER'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- STOCK_MANAGER existant → rôle STOCK_CLERK
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u, roles r
WHERE u.role = 'STOCK_MANAGER' AND r."key" = 'STOCK_CLERK'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- ADMIN et SUPER_ADMIN existants → rôle MANAGER (pour la compatibilité)
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u, roles r
WHERE u.role IN ('ADMIN', 'SUPER_ADMIN') AND r."key" = 'MANAGER'
ON CONFLICT (user_id, role_id) DO NOTHING;
