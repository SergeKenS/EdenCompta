package com.votreentreprise.pos.expenses.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.expenses.domain.Expense;
import com.votreentreprise.pos.expenses.domain.ExpenseStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface ExpenseService {

    // CRUD operations
    Expense createExpense(UUID storeId, String category, String description, Money amount, 
                         String paymentMethod, String reference, String notes, String createdBy);

    Expense getExpenseById(UUID expenseId);

    Expense updateExpense(UUID expenseId, String category, String description, Money amount, 
                         String paymentMethod, String reference, String notes);

    void deleteExpense(UUID expenseId);

    // Workflow operations
    Expense approveExpense(UUID expenseId, String approvedBy);

    Expense rejectExpense(UUID expenseId, String reason);

    Expense cancelExpense(UUID expenseId);

    // Query operations
    List<Expense> getExpensesByStore(UUID storeId);

    Page<Expense> getExpensesByStore(UUID storeId, Pageable pageable);

    List<Expense> getExpensesByStoreAndStatus(UUID storeId, ExpenseStatus status);

    Page<Expense> getExpensesByStoreAndStatus(UUID storeId, ExpenseStatus status, Pageable pageable);

    List<Expense> getExpensesByStoreAndCategory(UUID storeId, String category);

    List<Expense> getExpensesByStoreAndDateRange(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    List<Expense> getExpensesByStoreAndStatusAndDateRange(UUID storeId, ExpenseStatus status, 
                                                         LocalDateTime startDate, LocalDateTime endDate);

    List<Expense> getPendingExpensesByStore(UUID storeId);

    List<Expense> getExpensesByPaymentMethod(UUID storeId, String paymentMethod);

    // Statistics operations
    long countExpensesByStatus(UUID storeId, ExpenseStatus status);

    Money getTotalAmountByStatus(UUID storeId, ExpenseStatus status);

    List<Object[]> getTotalAmountByCategory(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    // Integration with sessions
    void recordExpenseInSession(UUID expenseId, String sessionType);
}




