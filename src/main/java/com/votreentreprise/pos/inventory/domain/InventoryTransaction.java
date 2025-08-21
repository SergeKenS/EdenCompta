package com.votreentreprise.pos.inventory.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.Quantity;
import com.votreentreprise.pos.common.types.TransactionType;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "inventory_transactions")
public class InventoryTransaction extends AuditableEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariant variant;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", nullable = false)
    private TransactionType transactionType;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "quantity"))
    private Quantity quantity;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "unit_cost"))
    private Money unitCost;

    @Column(name = "reference_id")
    private String referenceId;

    @Column(name = "reference_type")
    private String referenceType;

    @Column(name = "source_offline_id")
    private String sourceOfflineId;

    @Column(name = "occurred_at", nullable = false)
    private LocalDateTime occurredAt = LocalDateTime.now();

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    public InventoryTransaction() {}

    public InventoryTransaction(Store store, ProductVariant variant,
                                TransactionType transactionType, Quantity quantity,
                                Money unitCost, String referenceId, String referenceType) {
        this.store = store;
        this.variant = variant;
        this.transactionType = transactionType;
        this.quantity = quantity;
        this.unitCost = unitCost;
        this.referenceId = referenceId;
        this.referenceType = referenceType;
    }

    // Getters et Setters
    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public Quantity getQuantity() {
        return quantity;
    }

    public void setQuantity(Quantity quantity) {
        this.quantity = quantity;
    }

    public Money getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(Money unitCost) {
        this.unitCost = unitCost;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public String getSourceOfflineId() {
        return sourceOfflineId;
    }

    public void setSourceOfflineId(String sourceOfflineId) {
        this.sourceOfflineId = sourceOfflineId;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    public void setOccurredAt(LocalDateTime occurredAt) {
        this.occurredAt = occurredAt;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}