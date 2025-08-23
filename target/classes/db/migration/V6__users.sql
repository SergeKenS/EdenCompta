-- Migration V6: Users & Authentication Module
-- Create users table

CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    store_id UUID,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING_ACTIVATION',
    last_login TIMESTAMP,
    password_changed_at TIMESTAMP,
    failed_login_attempts INTEGER DEFAULT 0,
    account_locked_until TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT fk_users_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE SET NULL,
    CONSTRAINT chk_users_role CHECK (role IN ('SUPER_ADMIN', 'ADMIN', 'MANAGER', 'CASHIER', 'STOCK_MANAGER', 'ACCOUNTANT', 'VIEWER')),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'LOCKED', 'PENDING_ACTIVATION', 'EXPIRED')),
    CONSTRAINT chk_users_password_length CHECK (LENGTH(password_hash) >= 60),
    CONSTRAINT chk_users_username_length CHECK (LENGTH(username) >= 3 AND LENGTH(username) <= 50)
);

-- Create indexes for performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_store_id ON users(store_id);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_last_login ON users(last_login);
CREATE INDEX idx_users_failed_logins ON users(failed_login_attempts, account_locked_until);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_users_updated_at();

-- Insert default super admin user
-- Password: admin123 (BCrypt hash)
INSERT INTO users (
    id, username, email, password_hash, first_name, last_name, 
    role, status, created_by
) VALUES (
    gen_random_uuid(),
    'admin',
    'admin@pos.com',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa',
    'Super',
    'Administrateur',
    'SUPER_ADMIN',
    'ACTIVE',
    'system'
);

-- Insert sample users for testing
INSERT INTO users (
    id, username, email, password_hash, first_name, last_name, 
    role, status, store_id, created_by
) VALUES 
(
    gen_random_uuid(),
    'manager1',
    'manager1@pos.com',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa',
    'Jean',
    'Dupont',
    'MANAGER',
    'ACTIVE',
    (SELECT id FROM stores LIMIT 1),
    'admin'
),
(
    gen_random_uuid(),
    'cashier1',
    'cashier1@pos.com',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa',
    'Marie',
    'Martin',
    'CASHIER',
    'ACTIVE',
    (SELECT id FROM stores LIMIT 1),
    'admin'
),
(
    gen_random_uuid(),
    'stock1',
    'stock1@pos.com',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa',
    'Pierre',
    'Durand',
    'STOCK_MANAGER',
    'ACTIVE',
    (SELECT id FROM stores LIMIT 1),
    'admin'
);




