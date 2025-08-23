-- Migration V5: Expenses Module
-- Create expenses table

CREATE TABLE expenses (
    id UUID PRIMARY KEY,
    store_id UUID NOT NULL,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(500) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    reference VARCHAR(100),
    notes VARCHAR(1000),
    expense_date TIMESTAMP NOT NULL,
    approved_by VARCHAR(100),
    approved_at TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by VARCHAR(100),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT fk_expenses_store FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
    CONSTRAINT chk_expenses_amount CHECK (amount > 0),
    CONSTRAINT chk_expenses_status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED'))
);

-- Create indexes
CREATE INDEX idx_expenses_store_id ON expenses(store_id);
CREATE INDEX idx_expenses_category ON expenses(category);
CREATE INDEX idx_expenses_status ON expenses(status);
CREATE INDEX idx_expenses_payment_method ON expenses(payment_method);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date);
CREATE INDEX idx_expenses_created_at ON expenses(created_at);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_expenses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_expenses_updated_at
    BEFORE UPDATE ON expenses
    FOR EACH ROW
    EXECUTE FUNCTION update_expenses_updated_at();

-- Insert sample expense categories if they don't exist
-- Note: These will be managed by the application, but we can provide some defaults
INSERT INTO expenses (id, store_id, category, description, amount, payment_method, reference, notes, expense_date, status, created_by)
SELECT 
    gen_random_uuid(),
    s.id,
    'SUPPLIES',
    'Fournitures de bureau - Test',
    25.50,
    'CASH',
    'TEST-SUPPLIES-001',
    'Dépense de test pour validation',
    NOW(),
    'APPROVED',
    'system'
FROM stores s
WHERE NOT EXISTS (SELECT 1 FROM expenses WHERE store_id = s.id)
LIMIT 1;




