package com.votreentreprise.pos.expenses.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.expenses.domain.ExpenseCategory;
import com.votreentreprise.pos.store.domain.Store;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "expenses")
public class Expense extends AuditableEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id", nullable = false)
    @NotNull
    private Store store;

    @Column(name = "category", nullable = false)
    @Enumerated(EnumType.STRING)
    @NotNull
    private ExpenseCategory category;

    @Column(name = "description", nullable = false, length = 500)
    @Size(min = 1, max = 500)
    @NotNull
    private String description;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "amount", column = @Column(name = "amount", nullable = false, precision = 10, scale = 2))
    })
    @NotNull
    private Money amount;

    @Column(name = "payment_method", nullable = false, length = 50)
    @Size(max = 50)
    @NotNull
    private String paymentMethod;

    @Column(name = "reference", length = 100)
    @Size(max = 100)
    private String reference;

    @Column(name = "notes", length = 1000)
    @Size(max = 1000)
    private String notes;

    @Column(name = "expense_date", nullable = false)
    @NotNull
    private LocalDateTime expenseDate;

    @Column(name = "approved_by", length = 100)
    @Size(max = 100)
    private String approvedBy;

    @Column(name = "approved_at")
    private LocalDateTime approvedAt;

    @Column(name = "status", nullable = false, length = 20)
    @Enumerated(EnumType.STRING)
    @NotNull
    private ExpenseStatus status;

    // Constructors
    public Expense() {
        this.status = ExpenseStatus.PENDING;
        this.expenseDate = LocalDateTime.now();
    }

    public Expense(Store store, ExpenseCategory category, String description, Money amount, 
                   String paymentMethod, String reference, String notes) {
        this();
        this.store = store;
        this.category = category;
        this.description = description;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.reference = reference;
        this.notes = notes;
    }

    public Expense(Store store, ExpenseCategory category, String description, Money amount, 
                   String paymentMethod, String reference, String notes, String createdBy) {
        this();
        this.store = store;
        this.category = category;
        this.description = description;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.reference = reference;
        this.notes = notes;
        this.createdBy = createdBy;
    }

    // Business methods
    public void approve(String approvedBy) {
        if (this.status != ExpenseStatus.PENDING) {
            throw new IllegalStateException("Seules les dépenses en attente peuvent être approuvées");
        }
        this.status = ExpenseStatus.APPROVED;
        this.approvedBy = approvedBy;
        this.approvedAt = LocalDateTime.now();
    }

    public void reject(String reason) {
        if (this.status != ExpenseStatus.PENDING) {
            throw new IllegalStateException("Seules les dépenses en attente peuvent être rejetées");
        }
        this.status = ExpenseStatus.REJECTED;
        this.notes = (this.notes != null ? this.notes + "\n" : "") + "Rejeté: " + reason;
    }

    public void cancel() {
        if (this.status == ExpenseStatus.APPROVED) {
            throw new IllegalStateException("Les dépenses approuvées ne peuvent pas être annulées");
        }
        this.status = ExpenseStatus.CANCELLED;
    }

    public boolean isPending() {
        return ExpenseStatus.PENDING.equals(this.status);
    }

    public boolean isApproved() {
        return ExpenseStatus.APPROVED.equals(this.status);
    }

    public boolean isRejected() {
        return ExpenseStatus.REJECTED.equals(this.status);
    }

    public boolean isCancelled() {
        return ExpenseStatus.CANCELLED.equals(this.status);
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public Store getStore() { return store; }
    public void setStore(Store store) { this.store = store; }

    public ExpenseCategory getCategory() { return category; }
    public void setCategory(ExpenseCategory category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Money getAmount() { return amount; }
    public void setAmount(Money amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getExpenseDate() { return expenseDate; }
    public void setExpenseDate(LocalDateTime expenseDate) { this.expenseDate = expenseDate; }

    public String getApprovedBy() { return approvedBy; }
    public void setApprovedBy(String approvedBy) { this.approvedBy = approvedBy; }

    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }

    public ExpenseStatus getStatus() { return status; }
    public void setStatus(ExpenseStatus status) { this.status = status; }
}
