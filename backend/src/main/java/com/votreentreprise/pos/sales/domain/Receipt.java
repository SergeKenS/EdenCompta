package com.votreentreprise.pos.sales.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.ReceiptStatus;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "receipts")
public class Receipt extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(name = "receipt_number", nullable = false)
    private String receiptNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ReceiptStatus status = ReceiptStatus.DRAFT;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "subtotal"))
    private Money subtotal = Money.zero();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "tax_amount"))
    private Money taxAmount = Money.zero();

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "total_amount"))
    private Money totalAmount = Money.zero();

    @Column(name = "source_offline_id")
    private String sourceOfflineId;

    @Column(name = "finalized_at")
    private LocalDateTime finalizedAt;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @OneToMany(mappedBy = "receipt", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReceiptLine> lines = new ArrayList<>();

    @OneToMany(mappedBy = "receipt", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Payment> payments = new ArrayList<>();

    public Receipt() {}

    public Receipt(Store store, String receiptNumber, String createdBy) {
        this.store = store;
        this.receiptNumber = receiptNumber;
        this.createdBy = createdBy;
    }

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }

    public String getReceiptNumber() { return receiptNumber; }
    public void setReceiptNumber(String receiptNumber) { this.receiptNumber = receiptNumber; }

    public ReceiptStatus getStatus() { return status; }
    public void setStatus(ReceiptStatus status) { this.status = status; }

    public Money getSubtotal() { return subtotal; }
    public void setSubtotal(Money subtotal) { this.subtotal = subtotal; }

    public Money getTaxAmount() { return taxAmount; }
    public void setTaxAmount(Money taxAmount) { this.taxAmount = taxAmount; }

    public Money getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Money totalAmount) { this.totalAmount = totalAmount; }

    public String getSourceOfflineId() { return sourceOfflineId; }
    public void setSourceOfflineId(String sourceOfflineId) { this.sourceOfflineId = sourceOfflineId; }

    public LocalDateTime getFinalizedAt() { return finalizedAt; }
    public void setFinalizedAt(LocalDateTime finalizedAt) { this.finalizedAt = finalizedAt; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<ReceiptLine> getLines() { return lines; }
    public void setLines(List<ReceiptLine> lines) { this.lines = lines; }

    public List<Payment> getPayments() { return payments; }
    public void setPayments(List<Payment> payments) { this.payments = payments; }

    public void addLine(ReceiptLine line) {
        lines.add(line);
        line.setReceipt(this);
        recalculateTotals();
    }

    public void removeLine(ReceiptLine line) {
        lines.remove(line);
        line.setReceipt(null);
        recalculateTotals();
    }

    public void addPayment(Payment payment) {
        payments.add(payment);
        payment.setReceipt(this);
    }

    public boolean canBeModified() { return status == ReceiptStatus.DRAFT; }

    public void finalizeReceipt() {
        this.status = ReceiptStatus.FINALIZED;
        this.finalizedAt = LocalDateTime.now();
    }

    public void recalculateTotals() {
        Money newSubtotal = Money.zero();
        for (ReceiptLine line : lines) {
            if (line.getLineTotal() != null) {
                newSubtotal = newSubtotal.add(line.getLineTotal());
            }
        }
        this.subtotal = newSubtotal;
        // Taxe simple (ex: 0) à compléter selon configuration fiscale
        this.taxAmount = Money.zero();
        this.totalAmount = this.subtotal.add(this.taxAmount);
    }
}


