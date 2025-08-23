-- Types pour les réceptions
CREATE TYPE receipt_status_type AS ENUM ('DRAFT', 'RECEIVED', 'CANCELLED');

-- Table des réceptions de marchandises
CREATE TABLE goods_receipts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    reference VARCHAR(100), -- Numéro de bon de livraison, etc.
    status receipt_status_type NOT NULL DEFAULT 'DRAFT',
    received_at TIMESTAMP NOT NULL DEFAULT NOW(),
    total_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
    source_offline_id VARCHAR(255), -- Pour l'idempotence
    created_by VARCHAR(255),
    supplier_name VARCHAR(255),
    supplier_reference VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des lignes de réception
CREATE TABLE goods_receipt_lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    receipt_id UUID NOT NULL REFERENCES goods_receipts(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    quantity_received DECIMAL(10,3) NOT NULL CHECK (quantity_received > 0),
    unit_cost_effective DECIMAL(10,2) NOT NULL CHECK (unit_cost_effective >= 0),
    line_total DECIMAL(10,2) NOT NULL,
    line_number INTEGER NOT NULL,
    expiry_date DATE,
    batch_number VARCHAR(100),
    notes TEXT,
    UNIQUE(receipt_id, line_number)
);

-- Index pour performance
CREATE INDEX idx_goods_receipts_store_date ON goods_receipts(store_id, received_at);
CREATE INDEX idx_goods_receipts_status ON goods_receipts(status);
CREATE INDEX idx_goods_receipt_lines_variant ON goods_receipt_lines(variant_id);

-- Trigger pour mettre à jour updated_at
CREATE TRIGGER update_goods_receipts_updated_at BEFORE UPDATE ON goods_receipts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Fonction pour calculer le total de réception
CREATE OR REPLACE FUNCTION calculate_goods_receipt_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE goods_receipts 
    SET total_cost = (
        SELECT COALESCE(SUM(line_total), 0)
        FROM goods_receipt_lines 
        WHERE receipt_id = NEW.receipt_id
    )
    WHERE id = NEW.receipt_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour recalculer le total automatiquement
CREATE TRIGGER calculate_goods_receipt_total_trigger
    AFTER INSERT OR UPDATE OR DELETE ON goods_receipt_lines
    FOR EACH ROW EXECUTE FUNCTION calculate_goods_receipt_total();