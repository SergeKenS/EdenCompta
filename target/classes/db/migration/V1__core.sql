-- Extensions PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Types énumérés
CREATE TYPE transaction_type AS ENUM ('SALE', 'REFUND', 'PURCHASE', 'ADJUSTMENT', 'WASTE');
CREATE TYPE payment_method AS ENUM ('CASH', 'CARD', 'MOBILE', 'OTHER');
CREATE TYPE receipt_status AS ENUM ('DRAFT', 'FINALIZED', 'CANCELLED');

-- Table des magasins
CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des produits
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des variantes de produits
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id),
    sku VARCHAR(100) UNIQUE,
    name VARCHAR(255) NOT NULL,
    barcode VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des niveaux d'inventaire
CREATE TABLE inventory_levels (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    quantity_on_hand DECIMAL(10,3) NOT NULL DEFAULT 0,
    average_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
    last_updated TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(store_id, variant_id)
);

-- Table des transactions d'inventaire
CREATE TABLE inventory_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    transaction_type transaction_type NOT NULL,
    quantity DECIMAL(10,3) NOT NULL,
    unit_cost DECIMAL(10,2),
    reference_id UUID, -- ID de la transaction source (reçu, réception, etc.)
    reference_type VARCHAR(50), -- Type de référence (RECEIPT, GOODS_RECEIPT, etc.)
    source_offline_id VARCHAR(255), -- Pour l'idempotence
    occurred_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(255),
    notes TEXT
);

-- Table des reçus de vente
CREATE TABLE receipts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    receipt_number VARCHAR(100) NOT NULL,
    status receipt_status NOT NULL DEFAULT 'DRAFT',
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    source_offline_id VARCHAR(255), -- Pour l'idempotence
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    finalized_at TIMESTAMP,
    created_by VARCHAR(255),
    customer_name VARCHAR(255),
    notes TEXT,
    UNIQUE(store_id, receipt_number)
);

-- Table des lignes de reçu
CREATE TABLE receipt_lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    receipt_id UUID NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    quantity DECIMAL(10,3) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    unit_cost DECIMAL(10,2), -- Coût au moment de la vente (pour COGS)
    line_number INTEGER NOT NULL,
    UNIQUE(receipt_id, line_number)
);

-- Table des paiements
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    receipt_id UUID NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
    payment_method payment_method NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reference VARCHAR(255), -- Numéro de transaction, etc.
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Table des entrées COGS (Cost of Goods Sold)
CREATE TABLE cogs_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    store_id UUID NOT NULL REFERENCES stores(id),
    receipt_line_id UUID NOT NULL REFERENCES receipt_lines(id),
    variant_id UUID NOT NULL REFERENCES product_variants(id),
    quantity_sold DECIMAL(10,3) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    total_cogs DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Index pour performance
CREATE INDEX idx_inventory_levels_store_variant ON inventory_levels(store_id, variant_id);
CREATE INDEX idx_inventory_transactions_store_date ON inventory_transactions(store_id, occurred_at);
CREATE INDEX idx_inventory_transactions_variant ON inventory_transactions(variant_id);
CREATE INDEX idx_receipts_store_date ON receipts(store_id, created_at);
CREATE INDEX idx_receipts_status ON receipts(status);
CREATE INDEX idx_product_variants_sku ON product_variants(sku);
CREATE INDEX idx_product_variants_barcode ON product_variants(barcode);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_stores_updated_at BEFORE UPDATE ON stores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_product_variants_updated_at BEFORE UPDATE ON product_variants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();