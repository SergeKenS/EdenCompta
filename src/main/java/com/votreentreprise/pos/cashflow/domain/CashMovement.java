package com.votreentreprise.pos.cashflow.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "cash_movements")
public class CashMovement extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    @NotNull
    private Store store;

    @Enumerated(EnumType.STRING)
    @Column(name = "movement_type", nullable = false)
    @NotNull
    private CashMovementType movementType;

    @Enumerated(EnumType.STRING)
    @Column(name = "reason", nullable = false)
    @NotNull
    private CashMovementReason reason;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "amount", column = @Column(name = "amount", nullable = false, precision = 10, scale = 2))
    })
    @NotNull
    private Money amount;

    @Column(name = "reference", length = 100)
    @Size(max = 100)
    private String reference;

    @Column(name = "reference_type", length = 50)
    @Size(max = 50)
    private String referenceType;

    @Column(name = "description", length = 500)
    @Size(max = 500)
    private String description;

    @Column(name = "movement_date", nullable = false)
    @NotNull
    private LocalDateTime movementDate;

    @Column(name = "source_offline_id", length = 100)
    @Size(max = 100)
    private String sourceOfflineId;

    // Constructors
    public CashMovement() {}

    public CashMovement(Store store, CashMovementType movementType, CashMovementReason reason, 
                       Money amount, String reference, String referenceType, String description, 
                       String createdBy) {
        this.store = store;
        this.movementType = movementType;
        this.reason = reason;
        this.amount = amount;
        this.reference = reference;
        this.referenceType = referenceType;
        this.description = description;
        this.movementDate = LocalDateTime.now();
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public CashMovementType getMovementType() {
        return movementType;
    }

    public void setMovementType(CashMovementType movementType) {
        this.movementType = movementType;
    }

    public CashMovementReason getReason() {
        return reason;
    }

    public void setReason(CashMovementReason reason) {
        this.reason = reason;
    }

    public Money getAmount() {
        return amount;
    }

    public void setAmount(Money amount) {
        this.amount = amount;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getReferenceType() {
        return referenceType;
    }

    public void setReferenceType(String referenceType) {
        this.referenceType = referenceType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getMovementDate() {
        return movementDate;
    }

    public void setMovementDate(LocalDateTime movementDate) {
        this.movementDate = movementDate;
    }

    public String getSourceOfflineId() {
        return sourceOfflineId;
    }

    public void setSourceOfflineId(String sourceOfflineId) {
        this.sourceOfflineId = sourceOfflineId;
    }
}


