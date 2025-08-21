package com.votreentreprise.pos.inventory.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import jakarta.persistence.*;

@Entity
@Table(name = "product_variants")
public class ProductVariant extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(unique = true)
    private String sku;

    @Column(nullable = false)
    private String name;

    private String barcode;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    public ProductVariant() {}

    public ProductVariant(Product product, String name, String sku) {
        this.product = product;
        this.name = name;
        this.sku = sku;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
}