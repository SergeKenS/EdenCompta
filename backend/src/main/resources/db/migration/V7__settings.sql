-- Migration V7: Settings Module (Simplified)
-- Create settings table with only essential parameters

CREATE TABLE settings (
    id UUID PRIMARY KEY DEFAULT RANDOM_UUID(),
    store_id UUID NOT NULL,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT NOT NULL,
    setting_type VARCHAR(20) NOT NULL DEFAULT 'STRING', -- STRING, NUMBER, BOOLEAN
    description TEXT,
    is_editable BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    
    CONSTRAINT fk_settings_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT uk_settings_store_key UNIQUE (store_id, setting_key),
    CONSTRAINT chk_settings_type CHECK (setting_type IN ('STRING', 'NUMBER', 'BOOLEAN'))
);

-- Create indexes
CREATE INDEX idx_settings_store_id ON settings(store_id);
CREATE INDEX idx_settings_key ON settings(setting_key);

-- Insert default settings for the first store
INSERT INTO settings (store_id, setting_key, setting_value, setting_type, description, created_by) VALUES
-- Devise
((SELECT id FROM stores LIMIT 1), 'CURRENCY', 'EUR', 'STRING', 'Devise principale du magasin', 'system'),
-- Taux de TVA
((SELECT id FROM stores LIMIT 1), 'VAT_RATE', '20.0', 'NUMBER', 'Taux de TVA en pourcentage', 'system'),
-- Format de facture
((SELECT id FROM stores LIMIT 1), 'INVOICE_FORMAT', 'SIMPLE', 'STRING', 'Format de facture (SIMPLE, DETAILED)', 'system'),
-- Paramètres généraux
((SELECT id FROM stores LIMIT 1), 'STORE_NAME', 'Mon Magasin', 'STRING', 'Nom du magasin', 'system'),
((SELECT id FROM stores LIMIT 1), 'STORE_ADDRESS', '123 Rue de la Paix, 75001 Paris', 'STRING', 'Adresse du magasin', 'system'),
((SELECT id FROM stores LIMIT 1), 'STORE_PHONE', '+33 1 23 45 67 89', 'STRING', 'Téléphone du magasin', 'system'),
((SELECT id FROM stores LIMIT 1), 'STORE_EMAIL', 'contact@monmagasin.fr', 'STRING', 'Email du magasin', 'system'),
-- Paramètres de caisse
((SELECT id FROM stores LIMIT 1), 'RECEIPT_HEADER', 'Merci de votre visite !', 'STRING', 'En-tête des tickets de caisse', 'system'),
((SELECT id FROM stores LIMIT 1), 'RECEIPT_FOOTER', 'Rendez-vous bientôt !', 'STRING', 'Pied de page des tickets de caisse', 'system');
