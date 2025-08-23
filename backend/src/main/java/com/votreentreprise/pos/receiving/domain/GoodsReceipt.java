package com.votreentreprise.pos.receiving.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.ReceiptStatusType;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "goods_receipts")
public class GoodsReceipt extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "reference")
    private String reference;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ReceiptStatusType status = ReceiptStatusType.DRAFT;

    @Column(name = "received_at", nullable = false)
    private LocalDateTime receivedAt = LocalDateTime.now();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "total_cost"))
    private Money totalCost = Money.zero();

    @Column(name = "source_offline_id")
    private String sourceOfflineId;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "supplier_name")
    private String supplierName;

    @Column(name = "supplier_reference")
    private String supplierReference;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @OneToMany(mappedBy = "receipt", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<GoodsReceiptLine> lines = new ArrayList<>();

    public GoodsReceipt() {}

    public GoodsReceipt(Store store, String createdBy) {
        this.store = store;
        this.createdBy = createdBy;
    }

    // Getters et Setters
    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public ReceiptStatusType getStatus() {
        return status;
    }

    public void setStatus(ReceiptStatusType status) {
        this.status = status;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(LocalDateTime receivedAt) {
        this.receivedAt = receivedAt;
    }

    public Money getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(Money totalCost) {
        this.totalCost = totalCost;
    }

    public String getSourceOfflineId() {
        return sourceOfflineId;
    }

    public void setSourceOfflineId(String sourceOfflineId) {
        this.sourceOfflineId = sourceOfflineId;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getSupplierReference() {
        return supplierReference;
    }

    public void setSupplierReference(String supplierReference) {
        this.supplierReference = supplierReference;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<GoodsReceiptLine> getLines() {
        return lines;
    }

    public void setLines(List<GoodsReceiptLine> lines) {
        this.lines = lines;
    }

    // Méthodes métier
    public void addLine(GoodsReceiptLine line) {
        lines.add(line);
        line.setReceipt(this);
    }

    public void removeLine(GoodsReceiptLine line) {
        lines.remove(line);
        line.setReceipt(null);
    }

    public boolean canBeModified() {
        return status == ReceiptStatusType.DRAFT;
    }

    public void markAsReceived() {
        this.status = ReceiptStatusType.RECEIVED;
        this.receivedAt = LocalDateTime.now();
    }
}