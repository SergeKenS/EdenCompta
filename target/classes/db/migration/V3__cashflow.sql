-- Types pour la gestion de caisse
CREATE TYPE cash_session_status AS ENUM ('OPEN', 'CLOSED');
CREATE TYPE cash_movement_type AS ENUM ('IN', 'OUT');
CREATE TYPE cash_movement_reason AS ENUM ('SALE', 'REFUND', 'EXPENSE', 'DEPOSIT', 'WITHDRAWAL', 'ADJUSTMENT');

-- Table des sessions de caisse
CREATE TABLE cash_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    device_id VARCHAR(100) NOT NULL, -- Terminal/caisse spécifique
    status cash_session_status NOT NULL DEFAULT 'OPEN',
    
    -- Ouverture
    opened_by VARCHAR(255) NOT NULL,
    opened_at TIMESTAMP NOT NULL DEFAULT NOW(),
    opening_float DECIMAL(10,2) NOT NULL DEFAULT 0,
    
    -- Fermeture
    closed_by VARCHAR(255),
    closed_at TIMESTAMP,
    expected_cash DECIMAL(10,2), -- Calculé automatiquement
    declared_cash DECIMAL(10,2), -- Déclaré par l'utilisateur
    variance DECIMAL(10,2), -- Différence entre attendu et déclaré
    closing_note TEXT,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    -- Contrainte : une seule session ouverte par store/device
    CONSTRAINT unique_open_session UNIQUE(store_id, device_id, status) 
        DEFERRABLE INITIALLY DEFERRED
);

-- Table des mouvements de caisse
CREATE TABLE cash_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES cash_sessions(id),
    type cash_movement_type NOT NULL,
    reason cash_movement_reason NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    reference VARCHAR(255), -- ID du reçu, de la dépense, etc.
    reference_type VARCHAR(50), -- Type de référence
    description TEXT,
    created_by VARCHAR(255),
    occurred_at TIMESTAMP NOT NULL DEFAULT NOW(),
    source_offline_id VARCHAR(255) -- Pour l'idempotence
);

-- Index pour performance
CREATE INDEX idx_cash_sessions_store_device ON cash_sessions(store_id, device_id);
CREATE INDEX idx_cash_sessions_status ON cash_sessions(status);
CREATE INDEX idx_cash_sessions_date ON cash_sessions(opened_at);
CREATE INDEX idx_cash_movements_session ON cash_movements(session_id);
CREATE INDEX idx_cash_movements_date ON cash_movements(occurred_at);
CREATE INDEX idx_cash_movements_reference ON cash_movements(reference, reference_type);

-- Trigger pour mettre à jour updated_at
CREATE TRIGGER update_cash_sessions_updated_at BEFORE UPDATE ON cash_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Fonction pour contraindre une seule session ouverte
CREATE OR REPLACE FUNCTION check_single_open_session()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier qu'il n'y a pas déjà une session ouverte pour ce store/device
    IF NEW.status = 'OPEN' THEN
        IF EXISTS (
            SELECT 1 FROM cash_sessions 
            WHERE store_id = NEW.store_id 
            AND device_id = NEW.device_id 
            AND status = 'OPEN' 
            AND id != COALESCE(NEW.id, '00000000-0000-0000-0000-000000000000'::uuid)
        ) THEN
            RAISE EXCEPTION 'Une session de caisse est déjà ouverte pour ce magasin/terminal';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_single_open_session_trigger
    BEFORE INSERT OR UPDATE ON cash_sessions
    FOR EACH ROW EXECUTE FUNCTION check_single_open_session();

-- Fonction pour calculer le cash attendu
CREATE OR REPLACE FUNCTION calculate_expected_cash(session_uuid UUID)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    opening_amount DECIMAL(10,2);
    total_in DECIMAL(10,2);
    total_out DECIMAL(10,2);
BEGIN
    -- Récupérer le montant d'ouverture
    SELECT opening_float INTO opening_amount 
    FROM cash_sessions 
    WHERE id = session_uuid;
    
    -- Calculer total IN
    SELECT COALESCE(SUM(amount), 0) INTO total_in
    FROM cash_movements 
    WHERE session_id = session_uuid AND type = 'IN';
    
    -- Calculer total OUT
    SELECT COALESCE(SUM(amount), 0) INTO total_out
    FROM cash_movements 
    WHERE session_id = session_uuid AND type = 'OUT';
    
    RETURN opening_amount + total_in - total_out;
END;
$$ LANGUAGE plpgsql;