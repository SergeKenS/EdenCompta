package com.votreentreprise.pos.utils;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.inventory.domain.Product;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import com.votreentreprise.pos.store.domain.Store;

import java.math.BigDecimal;
import java.util.UUID;

public class TestDataBuilder {

    public static final UUID TEST_STORE_ID = UUID.fromString("550e8400-e29b-41d4-a716-446655440000");
    public static final UUID TEST_PRODUCT_A_ID = UUID.fromString("550e8400-e29b-41d4-a716-446655440001");
    public static final UUID TEST_VARIANT_A1_ID = UUID.fromString("550e8400-e29b-41d4-a716-446655440010");
    public static final UUID TEST_VARIANT_A2_ID = UUID.fromString("550e8400-e29b-41d4-a716-446655440011");
    public static final UUID TEST_VARIANT_B1_ID = UUID.fromString("550e8400-e29b-41d4-a716-446655440012");

    public static Store createTestStore() {
        Store store = new Store("Magasin Test");
        store.setId(TEST_STORE_ID);
        store.setAddress("123 Rue Test");
        store.setPhone("0123456789");
        return store;
    }

    public static Product createTestProduct(Store store, String name) {
        Product product = new Product(store, name);
        product.setDescription("Description de " + name);
        product.setCategory("FOOD");
        return product;
    }

    public static ProductVariant createTestVariant(Product product, String name, String sku) {
        ProductVariant variant = new ProductVariant(product, name, sku);
        variant.setBarcode("123456789012" + sku.substring(sku.length() - 1));
        return variant;
    }

    public static GoodsReceipt createTestReceipt(Store store, String createdBy) {
        return new GoodsReceipt(store, createdBy);
    }

    public static GoodsReceiptLine createTestReceiptLine(GoodsReceipt receipt, ProductVariant variant,
                                                         double quantity, double unitCost, int lineNumber) {
        return new GoodsReceiptLine(
                receipt,
                variant,
                Quantity.of(BigDecimal.valueOf(quantity)),
                Money.of(BigDecimal.valueOf(unitCost)),
                lineNumber
        );
    }

    public static Quantity quantity(double value) {
        return Quantity.of(BigDecimal.valueOf(value));
    }

    public static Money money(double amount) {
        return Money.of(BigDecimal.valueOf(amount));
    }
}