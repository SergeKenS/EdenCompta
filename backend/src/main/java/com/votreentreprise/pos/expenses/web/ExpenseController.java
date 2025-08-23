package com.votreentreprise.pos.expenses.web;

import com.votreentreprise.pos.expenses.service.ExpenseService;
import com.votreentreprise.pos.expenses.web.dto.ExpenseDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/expenses")
public class ExpenseController {

    private final ExpenseService expenseService;

    public ExpenseController(ExpenseService expenseService) {
        this.expenseService = expenseService;
    }

    // CRUD operations
    @PostMapping
    public ResponseEntity<ExpenseDto> createExpense(@RequestBody CreateExpenseRequest request) {
        var expense = expenseService.createExpense(
                request.storeId(),
                request.category(),
                request.description(),
                com.votreentreprise.pos.common.types.Money.of(request.amount()),
                request.paymentMethod(),
                request.reference(),
                request.notes(),
                request.createdBy()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(ExpenseDto.fromEntity(expense));
    }

    @GetMapping("/{expenseId}")
    public ResponseEntity<ExpenseDto> getExpense(@PathVariable UUID expenseId) {
        var expense = expenseService.getExpenseById(expenseId);
        return ResponseEntity.ok(ExpenseDto.fromEntity(expense));
    }

    @PutMapping("/{expenseId}")
    public ResponseEntity<ExpenseDto> updateExpense(@PathVariable UUID expenseId, 
                                                   @RequestBody UpdateExpenseRequest request) {
        var expense = expenseService.updateExpense(
                expenseId,
                request.category(),
                request.description(),
                com.votreentreprise.pos.common.types.Money.of(request.amount()),
                request.paymentMethod(),
                request.reference(),
                request.notes()
        );
        return ResponseEntity.ok(ExpenseDto.fromEntity(expense));
    }

    @DeleteMapping("/{expenseId}")
    public ResponseEntity<Void> deleteExpense(@PathVariable UUID expenseId) {
        expenseService.deleteExpense(expenseId);
        return ResponseEntity.noContent().build();
    }

    // Workflow operations
    @PostMapping("/{expenseId}/approve")
    public ResponseEntity<ExpenseDto> approveExpense(@PathVariable UUID expenseId,
                                                    @RequestBody ApproveExpenseRequest request) {
        var expense = expenseService.approveExpense(expenseId, request.approvedBy());
        return ResponseEntity.ok(ExpenseDto.fromEntity(expense));
    }

    @PostMapping("/{expenseId}/reject")
    public ResponseEntity<ExpenseDto> rejectExpense(@PathVariable UUID expenseId,
                                                   @RequestBody RejectExpenseRequest request) {
        var expense = expenseService.rejectExpense(expenseId, request.reason());
        return ResponseEntity.ok(ExpenseDto.fromEntity(expense));
    }

    @PostMapping("/{expenseId}/cancel")
    public ResponseEntity<ExpenseDto> cancelExpense(@PathVariable UUID expenseId) {
        var expense = expenseService.cancelExpense(expenseId);
        return ResponseEntity.ok(ExpenseDto.fromEntity(expense));
    }

    // Query operations
    @GetMapping
    public ResponseEntity<List<ExpenseDto>> getExpensesByStore(@RequestParam UUID storeId) {
        var expenses = expenseService.getExpensesByStore(storeId);
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/paged")
    public ResponseEntity<Page<ExpenseDto>> getExpensesByStorePaged(@RequestParam UUID storeId, 
                                                                   Pageable pageable) {
        var expenses = expenseService.getExpensesByStore(storeId, pageable);
        var dtos = expenses.map(ExpenseDto::fromEntity);
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/by-status")
    public ResponseEntity<List<ExpenseDto>> getExpensesByStatus(@RequestParam UUID storeId,
                                                               @RequestParam String status) {
        var expenses = expenseService.getExpensesByStoreAndStatus(storeId, 
                com.votreentreprise.pos.expenses.domain.ExpenseStatus.valueOf(status.toUpperCase()));
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/by-category")
    public ResponseEntity<List<ExpenseDto>> getExpensesByCategory(@RequestParam UUID storeId,
                                                                @RequestParam String category) {
        var expenses = expenseService.getExpensesByStoreAndCategory(storeId, category);
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/by-date-range")
    public ResponseEntity<List<ExpenseDto>> getExpensesByDateRange(@RequestParam UUID storeId,
                                                                  @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
                                                                  @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        var expenses = expenseService.getExpensesByStoreAndDateRange(storeId, startDate, endDate);
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/pending")
    public ResponseEntity<List<ExpenseDto>> getPendingExpenses(@RequestParam UUID storeId) {
        var expenses = expenseService.getPendingExpensesByStore(storeId);
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/by-payment-method")
    public ResponseEntity<List<ExpenseDto>> getExpensesByPaymentMethod(@RequestParam UUID storeId,
                                                                      @RequestParam String paymentMethod) {
        var expenses = expenseService.getExpensesByPaymentMethod(storeId, paymentMethod);
        var dtos = expenses.stream().map(ExpenseDto::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    // Statistics operations
    @GetMapping("/stats/count-by-status")
    public ResponseEntity<Long> getExpenseCountByStatus(@RequestParam UUID storeId,
                                                       @RequestParam String status) {
        var count = expenseService.countExpensesByStatus(storeId, 
                com.votreentreprise.pos.expenses.domain.ExpenseStatus.valueOf(status.toUpperCase()));
        return ResponseEntity.ok(count);
    }

    @GetMapping("/stats/total-by-status")
    public ResponseEntity<String> getTotalAmountByStatus(@RequestParam UUID storeId,
                                                        @RequestParam String status) {
        var total = expenseService.getTotalAmountByStatus(storeId, 
                com.votreentreprise.pos.expenses.domain.ExpenseStatus.valueOf(status.toUpperCase()));
        return ResponseEntity.ok(total.getAmount().toString());
    }

    @GetMapping("/stats/by-category")
    public ResponseEntity<List<Object[]>> getTotalAmountByCategory(@RequestParam UUID storeId,
                                                                 @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
                                                                 @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        var totals = expenseService.getTotalAmountByCategory(storeId, startDate, endDate);
        return ResponseEntity.ok(totals);
    }

    // Request DTOs
    public record CreateExpenseRequest(
            UUID storeId,
            String category,
            String description,
            java.math.BigDecimal amount,
            String paymentMethod,
            String reference,
            String notes,
            String createdBy
    ) {}

    public record UpdateExpenseRequest(
            String category,
            String description,
            java.math.BigDecimal amount,
            String paymentMethod,
            String reference,
            String notes
    ) {}

    public record ApproveExpenseRequest(String approvedBy) {}

    public record RejectExpenseRequest(String reason) {}
}
