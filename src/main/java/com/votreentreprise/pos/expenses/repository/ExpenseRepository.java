package com.votreentreprise.pos.expenses.repository;

import com.votreentreprise.pos.expenses.domain.Expense;
import com.votreentreprise.pos.expenses.domain.ExpenseStatus;
import com.votreentreprise.pos.expenses.domain.ExpenseCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ExpenseRepository extends JpaRepository<Expense, UUID> {

    // Find expenses by store
    List<Expense> findByStore_IdOrderByExpenseDateDesc(UUID storeId);
    
    Page<Expense> findByStore_IdOrderByExpenseDateDesc(UUID storeId, Pageable pageable);

    // Find expenses by store and status
    List<Expense> findByStore_IdAndStatusOrderByExpenseDateDesc(UUID storeId, ExpenseStatus status);
    
    Page<Expense> findByStore_IdAndStatusOrderByExpenseDateDesc(UUID storeId, ExpenseStatus status, Pageable pageable);

    // Find expenses by store and category
    List<Expense> findByStore_IdAndCategoryOrderByExpenseDateDesc(UUID storeId, ExpenseCategory category);
    
    Page<Expense> findByStore_IdAndCategoryOrderByExpenseDateDesc(UUID storeId, ExpenseCategory category, Pageable pageable);

    // Find expenses by store and date range
    @Query("SELECT e FROM Expense e WHERE e.store.id = :storeId AND e.expenseDate BETWEEN :startDate AND :endDate ORDER BY e.expenseDate DESC")
    List<Expense> findByStoreAndDateRange(@Param("storeId") UUID storeId, 
                                         @Param("startDate") LocalDateTime startDate, 
                                         @Param("endDate") LocalDateTime endDate);

    // Find expenses by store, status and date range
    @Query("SELECT e FROM Expense e WHERE e.store.id = :storeId AND e.status = :status AND e.expenseDate BETWEEN :startDate AND :endDate ORDER BY e.expenseDate DESC")
    List<Expense> findByStoreAndStatusAndDateRange(@Param("storeId") UUID storeId, 
                                                   @Param("status") ExpenseStatus status,
                                                   @Param("startDate") LocalDateTime startDate, 
                                                   @Param("endDate") LocalDateTime endDate);

    // Find pending expenses by store
    List<Expense> findByStore_IdAndStatusOrderByCreatedAtAsc(UUID storeId, ExpenseStatus status);

    // Find expenses by payment method
    List<Expense> findByStore_IdAndPaymentMethodOrderByExpenseDateDesc(UUID storeId, String paymentMethod);

    // Count expenses by status for a store
    @Query("SELECT COUNT(e) FROM Expense e WHERE e.store.id = :storeId AND e.status = :status")
    long countByStoreAndStatus(@Param("storeId") UUID storeId, @Param("status") ExpenseStatus status);

    // Sum total amount by status for a store
    @Query("SELECT COALESCE(SUM(e.amount.amount), 0) FROM Expense e WHERE e.store.id = :storeId AND e.status = :status")
    Double sumAmountByStoreAndStatus(@Param("storeId") UUID storeId, @Param("status") ExpenseStatus status);

    // Sum total amount by category for a store and date range
    @Query("SELECT e.category, COALESCE(SUM(e.amount.amount), 0) FROM Expense e " +
           "WHERE e.store.id = :storeId AND e.expenseDate BETWEEN :startDate AND :endDate " +
           "GROUP BY e.category ORDER BY SUM(e.amount.amount) DESC")
    List<Object[]> sumAmountByCategoryForStoreAndDateRange(@Param("storeId") UUID storeId, 
                                                           @Param("startDate") LocalDateTime startDate, 
                                                           @Param("endDate") LocalDateTime endDate);
}
