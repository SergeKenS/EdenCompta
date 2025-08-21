package com.votreentreprise.pos.receiving.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.inventory.domain.ProductVariant;
import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
@Table(name = "goods_receipt_lines",
        uniqueConstraints = @UniqueConstraint(columnNames = {"receipt_id", "line_number"}))
public class GoodsReceiptLine extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receipt_id", nullable = false)
    private GoodsReceipt receipt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "quantity_received"))
    private Quantity quantityReceived;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "unit_cost_effective"))
    private Money unitCostEffective;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "line_total"))
    private Money lineTotal;

    @Column(name = "line_number", nullable = false)
    private Integer lineNumber;

    @Column(name = "expiry_date")
    private LocalDate expiryDate;

    @Column(name = "batch_number")
    private String batchNumber;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    public GoodsReceiptLine() {}

    public GoodsReceiptLine(GoodsReceipt receipt, ProductVariant variant,
                            Quantity quantityReceived, Money unitCostEffective,
                            Integer lineNumber) {
        this.receipt = receipt;
        this.variant = variant;
        this.quantityReceived = quantityReceived;
        this.unitCostEffective = unitCostEffective;
        this.lineNumber = lineNumber;
        calculateLineTotal();
    }

    // Getters et Setters
    public GoodsReceipt getReceipt() {
        return receipt;
    }

    public void setReceipt(GoodsReceipt receipt) {
        this.receipt = receipt;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public Quantity getQuantityReceived() {
        return quantityReceived;
    }

    public void setQuantityReceived(Quantity quantityReceived) {
        this.quantityReceived = quantityReceived;
        calculateLineTotal();
    }

    public Money getUnitCostEffective() {
        return unitCostEffective;
    }

    public void setUnitCostEffective(Money unitCostEffective) {
        this.unitCostEffective = unitCostEffective;
        calculateLineTotal();
    }

    public Money getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(Money lineTotal) {
        this.lineTotal = lineTotal;
    }

    public Integer getLineNumber() {
        return lineNumber;
    }

    public void setLineNumber(Integer lineNumber) {
        this.lineNumber = lineNumber;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Méthodes métier
    public void calculateLineTotal() {
        if (quantityReceived != null && unitCostEffective != null) {
            this.lineTotal = unitCostEffective.multiply(quantityReceived.getValue());
        }
    }

    @PrePersist
    @PreUpdate
    private void prePersist() {
        calculateLineTotal();
    }
}