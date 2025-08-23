-- Migration pour les mouvements de trésorerie
CREATE TABLE cash_movements (
    id UUID PRIMARY KEY DEFAULT RANDOM_UUID(),
    store_id UUID NOT NULL,
    movement_type VARCHAR(20) NOT NULL,
    reason VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reference VARCHAR(100),
    reference_type VARCHAR(50),
    description VARCHAR(500),
    movement_date TIMESTAMP NOT NULL,
    source_offline_id VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    created_by VARCHAR(100),
    
    CONSTRAINT fk_cash_movements_store FOREIGN KEY (store_id) REFERENCES stores(id),
    CONSTRAINT chk_cash_movements_amount CHECK (amount > 0),
    CONSTRAINT chk_cash_movements_type CHECK (movement_type IN ('IN', 'OUT')),
    CONSTRAINT chk_cash_movements_reason CHECK (reason IN (
        'SALE', 'REFUND', 'EXPENSE', 'DEPOSIT', 'WITHDRAWAL', 'ADJUSTMENT'
    ))
);

-- Index pour les performances
CREATE INDEX idx_cash_movements_store_id ON cash_movements(store_id);
CREATE INDEX idx_cash_movements_date ON cash_movements(movement_date);
CREATE INDEX idx_cash_movements_type ON cash_movements(movement_type);
CREATE INDEX idx_cash_movements_reason ON cash_movements(reason);
CREATE INDEX idx_cash_movements_store_date ON cash_movements(store_id, movement_date);
CREATE INDEX idx_cash_movements_source_offline_id ON cash_movements(store_id, source_offline_id);

-- Index unique pour l'idempotence
CREATE UNIQUE INDEX idx_cash_movements_idempotency ON cash_movements(store_id, source_offline_id) 
WHERE source_offline_id IS NOT NULL;

