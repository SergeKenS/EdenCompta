-- Types pour les dépenses
CREATE TYPE expense_category AS ENUM ('SUPPLIES', 'TRANSPORT', 'UTILITIES', 'MAINTENANCE', 'MARKETING', 'OTHER');

-- Table des dépenses d'exploitation
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    session_id UUID REFERENCES cash_sessions(id), -- NULL si pas payé en cash
    
    category expense_category NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    paid_via payment_method NOT NULL,
    
    -- Références
    reference VARCHAR(255), -- Numéro de facture, ticket, etc.
    supplier_name VARCHAR(255),
    
    -- Dates
    occurred_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(255),
    
    -- Idempotence
    source_offline_id VARCHAR(255),
    
    -- Justificatifs
    receipt_url TEXT, -- URL vers scan du justificatif
    notes TEXT
);

-- Index pour performance
CREATE INDEX idx_expenses_store_date ON expenses(store_id, occurred_at);
CREATE INDEX idx_expenses_category ON expenses(category);
CREATE INDEX idx_expenses_session ON expenses(session_id);
CREATE INDEX idx_expenses_paid_via ON expenses(paid_via);

-- Contrainte : si payé en cash, doit avoir une session
ALTER TABLE expenses ADD CONSTRAINT check_cash_session 
    CHECK (
        (paid_via = 'CASH' AND session_id IS NOT NULL) OR 
        (paid_via != 'CASH')
    );

-- Vue pour les dépenses avec informations de session
CREATE VIEW expenses_with_session AS
SELECT 
    e.*,
    cs.device_id,
    cs.opened_by as session_opened_by,
    cs.opened_at as session_opened_at
FROM expenses e
LEFT JOIN cash_sessions cs ON e.session_id = cs.id;

-- Fonction pour créer automatiquement le mouvement de caisse pour dépenses CASH
CREATE OR REPLACE FUNCTION create_cash_movement_for_expense()
RETURNS TRIGGER AS $$
BEGIN
    -- Si c'est une dépense en cash avec session, créer le mouvement
    IF NEW.paid_via = 'CASH' AND NEW.session_id IS NOT NULL THEN
        INSERT INTO cash_movements (
            session_id,
            type,
            reason,
            amount,
            reference,
            reference_type,
            description,
            created_by,
            occurred_at
        ) VALUES (
            NEW.session_id,
            'OUT',
            'EXPENSE',
            NEW.amount,
            NEW.id::text,
            'EXPENSE',
            NEW.description,
            NEW.created_by,
            NEW.occurred_at
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_cash_movement_for_expense_trigger
    AFTER INSERT ON expenses
    FOR EACH ROW EXECUTE FUNCTION create_cash_movement_for_expense();

-- Fonction pour supprimer le mouvement de caisse si dépense supprimée
CREATE OR REPLACE FUNCTION remove_cash_movement_for_expense()
RETURNS TRIGGER AS $$
BEGIN
    -- Supprimer le mouvement de caisse associé
    DELETE FROM cash_movements 
    WHERE reference = OLD.id::text 
    AND reference_type = 'EXPENSE' 
    AND reason = 'EXPENSE';
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_cash_movement_for_expense_trigger
    AFTER DELETE ON expenses
    FOR EACH ROW EXECUTE FUNCTION remove_cash_movement_for_expense();