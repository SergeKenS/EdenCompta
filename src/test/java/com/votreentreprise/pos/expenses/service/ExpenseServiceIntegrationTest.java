package com.votreentreprise.pos.expenses.service;

import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.expenses.domain.Expense;
import com.votreentreprise.pos.expenses.domain.ExpenseStatus;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.utils.TestDataBuilder;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Transactional
@ActiveProfiles("test")
class ExpenseServiceIntegrationTest {

    @Autowired
    private ExpenseService expenseService;

    @Autowired
    private SessionService sessionService;

    private UUID testStoreId;
    private String testUserId;

    @BeforeEach
    void setUp() {
        testStoreId = TestDataBuilder.TEST_STORE_ID;
        testUserId = "test-user";
    }

    @Test
    void shouldCreateExpense() {
        // Given
        String category = "SUPPLIES";
        String description = "Fournitures de bureau";
        Money amount = Money.of(new BigDecimal("25.50"));
        String paymentMethod = "CASH";
        String reference = "SUPPLIES-001";
        String notes = "Achat de stylos et papier";

        // When
        Expense expense = expenseService.createExpense(
                testStoreId, category, description, amount, 
                paymentMethod, reference, notes, testUserId
        );

        // Then
        assertThat(expense).isNotNull();
        assertThat(expense.getId()).isNotNull();
        assertThat(expense.getStore().getId()).isEqualTo(testStoreId);
        assertThat(expense.getCategory().name()).isEqualTo(category);
        assertThat(expense.getDescription()).isEqualTo(description);
        assertThat(expense.getAmount()).isEqualTo(amount);
        assertThat(expense.getPaymentMethod()).isEqualTo(paymentMethod);
        assertThat(expense.getReference()).isEqualTo(reference);
        assertThat(expense.getNotes()).isEqualTo(notes);
        assertThat(expense.getStatus()).isEqualTo(ExpenseStatus.PENDING);
        assertThat(expense.getCreatedBy()).isEqualTo(testUserId);
        assertThat(expense.getCreatedAt()).isNotNull();
    }

    @Test
    void shouldNotCreateExpenseWithInvalidAmount() {
        // Given
        String category = "SUPPLIES";
        String description = "Fournitures de bureau";
        Money invalidAmount = Money.of(new BigDecimal("0.00"));
        String paymentMethod = "CASH";

        // When & Then
        assertThatThrownBy(() -> expenseService.createExpense(
                testStoreId, category, description, invalidAmount, 
                paymentMethod, null, null, testUserId
        )).isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
          .hasMessageContaining("Le montant de la dépense doit être supérieur à 0");
    }

    @Test
    void shouldNotCreateExpenseWithInvalidCategory() {
        // Given
        String invalidCategory = "INVALID_CATEGORY";
        String description = "Fournitures de bureau";
        Money amount = Money.of(new BigDecimal("25.50"));
        String paymentMethod = "CASH";

        // When & Then
        assertThatThrownBy(() -> expenseService.createExpense(
                testStoreId, invalidCategory, description, amount, 
                paymentMethod, null, null, testUserId
        )).isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
          .hasMessageContaining("Catégorie de dépense invalide");
    }

    @Test
    void shouldUpdateExpense() {
        // Given
        Expense expense = createTestExpense();
        String newDescription = "Fournitures de bureau mises à jour";
        Money newAmount = Money.of(new BigDecimal("30.00"));

        // When
        Expense updatedExpense = expenseService.updateExpense(
                expense.getId(),
                expense.getCategory().name(),
                newDescription,
                newAmount,
                expense.getPaymentMethod(),
                expense.getReference(),
                expense.getNotes()
        );

        // Then
        assertThat(updatedExpense.getDescription()).isEqualTo(newDescription);
        assertThat(updatedExpense.getAmount()).isEqualTo(newAmount);
        assertThat(updatedExpense.getUpdatedAt()).isAfterOrEqualTo(expense.getCreatedAt());
    }

    @Test
    void shouldNotUpdateApprovedExpense() {
        // Given
        Expense expense = createTestExpense();
        expenseService.approveExpense(expense.getId(), "manager");

        // When & Then
        assertThatThrownBy(() -> expenseService.updateExpense(
                expense.getId(),
                expense.getCategory().name(),
                "Nouvelle description",
                expense.getAmount(),
                expense.getPaymentMethod(),
                expense.getReference(),
                expense.getNotes()
        )).isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
          .hasMessageContaining("Impossible de modifier une dépense approuvée");
    }

    @Test
    void shouldApproveExpense() {
        // Given
        Expense expense = createTestExpense();
        String approvedBy = "manager";

        // When
        Expense approvedExpense = expenseService.approveExpense(expense.getId(), approvedBy);

        // Then
        assertThat(approvedExpense.getStatus()).isEqualTo(ExpenseStatus.APPROVED);
        assertThat(approvedExpense.getApprovedBy()).isEqualTo(approvedBy);
        assertThat(approvedExpense.getApprovedAt()).isNotNull();
    }

    @Test
    void shouldRejectExpense() {
        // Given
        Expense expense = createTestExpense();
        String reason = "Montant trop élevé";

        // When
        Expense rejectedExpense = expenseService.rejectExpense(expense.getId(), reason);

        // Then
        assertThat(rejectedExpense.getStatus()).isEqualTo(ExpenseStatus.REJECTED);
        assertThat(rejectedExpense.getNotes()).contains(reason);
    }

    @Test
    void shouldCancelExpense() {
        // Given
        Expense expense = createTestExpense();

        // When
        Expense cancelledExpense = expenseService.cancelExpense(expense.getId());

        // Then
        assertThat(cancelledExpense.getStatus()).isEqualTo(ExpenseStatus.CANCELLED);
    }

    @Test
    void shouldGetExpensesByStore() {
        // Given
        createTestExpense();
        createTestExpense();

        // When
        List<Expense> expenses = expenseService.getExpensesByStore(testStoreId);

        // Then
        assertThat(expenses).hasSizeGreaterThanOrEqualTo(2);
        assertThat(expenses).allMatch(expense -> expense.getStore().getId().equals(testStoreId));
    }

    @Test
    void shouldGetExpensesByStatus() {
        // Given
        Expense expense1 = createTestExpense();
        Expense expense2 = createTestExpense();
        expenseService.approveExpense(expense1.getId(), "manager");

        // When
        List<Expense> pendingExpenses = expenseService.getExpensesByStoreAndStatus(testStoreId, ExpenseStatus.PENDING);
        List<Expense> approvedExpenses = expenseService.getExpensesByStoreAndStatus(testStoreId, ExpenseStatus.APPROVED);

        // Then
        assertThat(pendingExpenses).anyMatch(expense -> expense.getId().equals(expense2.getId()));
        assertThat(approvedExpenses).anyMatch(expense -> expense.getId().equals(expense1.getId()));
    }

    @Test
    void shouldGetPendingExpenses() {
        // Given
        createTestExpense();
        createTestExpense();

        // When
        List<Expense> pendingExpenses = expenseService.getPendingExpensesByStore(testStoreId);

        // Then
        assertThat(pendingExpenses).hasSizeGreaterThanOrEqualTo(2);
        assertThat(pendingExpenses).allMatch(Expense::isPending);
    }

    @Test
    void shouldGetExpensesByCategory() {
        // Given
        createTestExpense(); // SUPPLIES
        createTestExpense(); // SUPPLIES

        // When
        List<Expense> suppliesExpenses = expenseService.getExpensesByStoreAndCategory(testStoreId, "SUPPLIES");

        // Then
        assertThat(suppliesExpenses).hasSizeGreaterThanOrEqualTo(2);
        assertThat(suppliesExpenses).allMatch(expense -> expense.getCategory().name().equals("SUPPLIES"));
    }

    @Test
    void shouldGetExpensesByDateRange() {
        // Given
        createTestExpense();
        createTestExpense();

        LocalDateTime startDate = LocalDateTime.now().minusDays(1);
        LocalDateTime endDate = LocalDateTime.now().plusDays(1);

        // When
        List<Expense> expenses = expenseService.getExpensesByStoreAndDateRange(testStoreId, startDate, endDate);

        // Then
        assertThat(expenses).hasSizeGreaterThanOrEqualTo(2);
    }

    @Test
    void shouldCountExpensesByStatus() {
        // Given
        createTestExpense();
        createTestExpense();

        // When
        long pendingCount = expenseService.countExpensesByStatus(testStoreId, ExpenseStatus.PENDING);

        // Then
        assertThat(pendingCount).isGreaterThanOrEqualTo(2);
    }

    @Test
    void shouldGetTotalAmountByStatus() {
        // Given
        createTestExpense(); // 25.50
        createTestExpense(); // 25.50

        // When
        Money totalPending = expenseService.getTotalAmountByStatus(testStoreId, ExpenseStatus.PENDING);

        // Then
        assertThat(totalPending.getAmount()).isGreaterThanOrEqualTo(new BigDecimal("51.00"));
    }

    @Test
    void shouldRecordExpenseInSession() {
        // Given
        Expense expense = createTestExpense();
        
        // Open a cash session
        sessionService.openCashSession(testStoreId, testUserId, Money.of(new BigDecimal("100.00")));

        // When
        expenseService.recordExpenseInSession(expense.getId(), "CASH");

        // Then - No exception should be thrown
        assertThat(expense).isNotNull();
    }

    @Test
    void shouldNotRecordExpenseInSessionWhenNoSessionOpen() {
        // Given
        Expense expense = createTestExpense();

        // When & Then
        assertThatThrownBy(() -> expenseService.recordExpenseInSession(expense.getId(), "CASH"))
                .isInstanceOf(com.votreentreprise.pos.common.exceptions.BusinessException.class)
                .hasMessageContaining("Aucune session cash ouverte pour ce magasin");
    }

    // Helper method
    private Expense createTestExpense() {
        return expenseService.createExpense(
                testStoreId,
                "SUPPLIES",
                "Fournitures de bureau - Test",
                Money.of(new BigDecimal("25.50")),
                "CASH",
                "TEST-" + UUID.randomUUID().toString().substring(0, 8),
                "Dépense de test",
                testUserId
        );
    }
}
