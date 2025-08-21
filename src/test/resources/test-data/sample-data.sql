-- Créer un magasin de test
INSERT INTO stores (id, name, address, phone, created_at, updated_at)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Magasin Test', '123 Rue Test', '0123456789', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Créer des produits de test
INSERT INTO products (id, store_id, name, description, category, is_active, created_at, updated_at)
VALUES
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Produit A', 'Description A', 'FOOD', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'Produit B', 'Description B', 'FOOD', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Créer des variantes de test
INSERT INTO product_variants (id, product_id, sku, name, barcode, is_active, created_at, updated_at)
VALUES
  ('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440001', 'SKU-A-001', 'Variante A1', '1234567890123', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'SKU-A-002', 'Variante A2', '1234567890124', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
  ('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', 'SKU-B-001', 'Variante B1', '1234567890125', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);