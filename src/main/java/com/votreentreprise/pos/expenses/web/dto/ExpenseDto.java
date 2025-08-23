package com.votreentreprise.pos.expenses.web.dto;

import com.votreentreprise.pos.expenses.domain.Expense;
import com.votreentreprise.pos.expenses.domain.ExpenseStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public class ExpenseDto {
    private UUID id;
    private UUID storeId;
    private String category;
    private String description;
    private String amount;
    private String paymentMethod;
    private String reference;
    private String notes;
    private LocalDateTime expenseDate;
    private String approvedBy;
    private LocalDateTime approvedAt;
    private String status;
    private LocalDateTime createdAt;
    private String createdBy;
    private LocalDateTime updatedAt;

    public ExpenseDto() {}

    public ExpenseDto(UUID id, UUID storeId, String category, String description, String amount,
                     String paymentMethod, String reference, String notes, LocalDateTime expenseDate,
                     String approvedBy, LocalDateTime approvedAt, String status, LocalDateTime createdAt,
                     String createdBy, LocalDateTime updatedAt) {
        this.id = id;
        this.storeId = storeId;
        this.category = category;
        this.description = description;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.reference = reference;
        this.notes = notes;
        this.expenseDate = expenseDate;
        this.approvedBy = approvedBy;
        this.approvedAt = approvedAt;
        this.status = status;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.updatedAt = updatedAt;
    }

    public static ExpenseDto fromEntity(Expense expense) {
        return new ExpenseDto(
                expense.getId(),
                expense.getStore().getId(),
                expense.getCategory().name(),
                expense.getDescription(),
                expense.getAmount() != null ? expense.getAmount().getAmount().toString() : null,
                expense.getPaymentMethod(),
                expense.getReference(),
                expense.getNotes(),
                expense.getExpenseDate(),
                expense.getApprovedBy(),
                expense.getApprovedAt(),
                expense.getStatus().name(),
                expense.getCreatedAt(),
                expense.getCreatedBy(),
                expense.getUpdatedAt()
        );
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getStoreId() { return storeId; }
    public void setStoreId(UUID storeId) { this.storeId = storeId; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAmount() { return amount; }
    public void setAmount(String amount) { this.amount = amount; }

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

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}




