-- Types pour la gestion de sessions par type de paiement
CREATE TYPE session_status AS ENUM ('OPEN', 'CLOSED');
CREATE TYPE movement_type AS ENUM ('IN', 'OUT');
CREATE TYPE movement_reason AS ENUM ('SALE', 'REFUND', 'EXPENSE', 'DEPOSIT', 'WITHDRAWAL', 'ADJUSTMENT');

-- Table des sessions espèces (CASH)
CREATE TABLE cash_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    user_id VARCHAR(255) NOT NULL,
    opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMP,
    initial_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_in DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_out DECIMAL(10,2) NOT NULL DEFAULT 0,
    real_closing_amount DECIMAL(10,2),
    discrepancy DECIMAL(10,2),
    note TEXT,
    status session_status NOT NULL DEFAULT 'OPEN',
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contrainte : une seule session ouverte par store
    CONSTRAINT unique_open_cash_session UNIQUE(store_id, status) 
        DEFERRABLE INITIALLY DEFERRED
);

-- Table des sessions mobile (MOBILE)
CREATE TABLE mobile_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    user_id VARCHAR(255) NOT NULL,
    opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMP,
    initial_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_in DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_out DECIMAL(10,2) NOT NULL DEFAULT 0,
    real_closing_amount DECIMAL(10,2),
    discrepancy DECIMAL(10,2),
    note TEXT,
    status session_status NOT NULL DEFAULT 'OPEN',
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contrainte : une seule session ouverte par store
    CONSTRAINT unique_open_mobile_session UNIQUE(store_id, status) 
        DEFERRABLE INITIALLY DEFERRED
);

-- Table des sessions autres (OTHER)
CREATE TABLE other_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    user_id VARCHAR(255) NOT NULL,
    opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMP,
    initial_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_in DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_out DECIMAL(10,2) NOT NULL DEFAULT 0,
    real_closing_amount DECIMAL(10,2),
    discrepancy DECIMAL(10,2),
    note TEXT,
    status session_status NOT NULL DEFAULT 'OPEN',
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contrainte : une seule session ouverte par store
    CONSTRAINT unique_open_other_session UNIQUE(store_id, status) 
        DEFERRABLE INITIALLY DEFERRED
);

-- Table des mouvements (générique pour tous les types)
CREATE TABLE session_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL, -- Référence vers la session appropriée
    session_type VARCHAR(20) NOT NULL CHECK (session_type IN ('CASH', 'MOBILE', 'OTHER')),
    type movement_type NOT NULL,
    reason movement_reason NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    reference VARCHAR(255), -- ID du reçu, de la dépense, etc.
    reference_type VARCHAR(50), -- Type de référence
    description TEXT,
    created_by VARCHAR(255),
    occurred_at TIMESTAMP NOT NULL DEFAULT NOW(),
    source_offline_id VARCHAR(255) -- Pour l'idempotence
);

-- Index pour performance
CREATE INDEX idx_cash_sessions_store ON cash_sessions(store_id);
CREATE INDEX idx_cash_sessions_status ON cash_sessions(status);
CREATE INDEX idx_cash_sessions_date ON cash_sessions(opened_at);

CREATE INDEX idx_mobile_sessions_store ON mobile_sessions(store_id);
CREATE INDEX idx_mobile_sessions_status ON mobile_sessions(status);
CREATE INDEX idx_mobile_sessions_date ON mobile_sessions(opened_at);

CREATE INDEX idx_other_sessions_store ON other_sessions(store_id);
CREATE INDEX idx_other_sessions_status ON other_sessions(status);
CREATE INDEX idx_other_sessions_date ON other_sessions(opened_at);

CREATE INDEX idx_session_movements_session ON session_movements(session_id, session_type);
CREATE INDEX idx_session_movements_date ON session_movements(occurred_at);
CREATE INDEX idx_session_movements_reference ON session_movements(reference, reference_type);

-- Triggers pour mettre à jour updated_at
CREATE TRIGGER update_cash_sessions_updated_at BEFORE UPDATE ON cash_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mobile_sessions_updated_at BEFORE UPDATE ON mobile_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_other_sessions_updated_at BEFORE UPDATE ON other_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Fonctions pour contraindre une seule session ouverte par type
CREATE OR REPLACE FUNCTION check_single_open_cash_session()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'OPEN' THEN
        IF EXISTS (
            SELECT 1 FROM cash_sessions 
            WHERE store_id = NEW.store_id 
            AND status = 'OPEN' 
            AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
        ) THEN
            RAISE EXCEPTION 'Une session espèces est déjà ouverte pour ce magasin';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_single_open_mobile_session()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'OPEN' THEN
        IF EXISTS (
            SELECT 1 FROM mobile_sessions 
            WHERE store_id = NEW.store_id 
            AND status = 'OPEN' 
            AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
        ) THEN
            RAISE EXCEPTION 'Une session mobile est déjà ouverte pour ce magasin';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_single_open_other_session()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'OPEN' THEN
        IF EXISTS (
            SELECT 1 FROM other_sessions 
            WHERE store_id = NEW.store_id 
            AND status = 'OPEN' 
            AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
        ) THEN
            RAISE EXCEPTION 'Une session autre est déjà ouverte pour ce magasin';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers pour les contraintes
CREATE TRIGGER check_single_open_cash_session_trigger
    BEFORE INSERT OR UPDATE ON cash_sessions
    FOR EACH ROW EXECUTE FUNCTION check_single_open_cash_session();

CREATE TRIGGER check_single_open_mobile_session_trigger
    BEFORE INSERT OR UPDATE ON mobile_sessions
    FOR EACH ROW EXECUTE FUNCTION check_single_open_mobile_session();

CREATE TRIGGER check_single_open_other_session_trigger
    BEFORE INSERT OR UPDATE ON other_sessions
    FOR EACH ROW EXECUTE FUNCTION check_single_open_other_session();