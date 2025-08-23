package com.votreentreprise.pos.expenses.service;

import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import com.votreentreprise.pos.expenses.domain.Expense;
import com.votreentreprise.pos.expenses.domain.ExpenseStatus;
import com.votreentreprise.pos.expenses.domain.ExpenseCategory;

import com.votreentreprise.pos.expenses.repository.ExpenseRepository;
import com.votreentreprise.pos.sessions.service.SessionService;
import com.votreentreprise.pos.sessions.domain.CashSession;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class ExpenseServiceImpl implements ExpenseService {

    private final ExpenseRepository expenseRepository;
    private final StoreRepository storeRepository;
    private final SessionService sessionService;

    public ExpenseServiceImpl(ExpenseRepository expenseRepository, 
                            StoreRepository storeRepository,
                            SessionService sessionService) {
        this.expenseRepository = expenseRepository;
        this.storeRepository = storeRepository;
        this.sessionService = sessionService;
    }

    @Override
    @Transactional
    public Expense createExpense(UUID storeId, String category, String description, Money amount, 
                                String paymentMethod, String reference, String notes, String createdBy) {
        
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Magasin non trouvé: " + storeId));

        // Validate amount
        if (amount.getAmount().compareTo(java.math.BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Le montant de la dépense doit être supérieur à 0");
        }

        // Validate category
        try {
            ExpenseCategory.valueOf(category.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new BusinessException("Catégorie de dépense invalide: " + category);
        }

        Expense expense = new Expense(store, ExpenseCategory.valueOf(category.toUpperCase()), 
                                    description, amount, paymentMethod, reference, notes, createdBy);
        
        Expense savedExpense = expenseRepository.save(expense);

        // If payment method is CASH, record movement in cash session
        if ("CASH".equalsIgnoreCase(paymentMethod)) {
            try {
                recordExpenseInSession(savedExpense.getId(), "CASH");
            } catch (Exception e) {
                // Log error but don't fail expense creation
                System.err.println("Erreur lors de l'enregistrement du mouvement de session: " + e.getMessage());
            }
        }

        return savedExpense;
    }

    @Override
    @Transactional(readOnly = true)
    public Expense getExpenseById(UUID expenseId) {
        return expenseRepository.findById(expenseId)
                .orElseThrow(() -> new ResourceNotFoundException("Dépense non trouvée: " + expenseId));
    }

    @Override
    @Transactional
    public Expense updateExpense(UUID expenseId, String category, String description, Money amount, 
                                String paymentMethod, String reference, String notes) {
        
        Expense expense = getExpenseById(expenseId);

        // Check if expense can be modified
        if (expense.isApproved()) {
            throw new BusinessException("Impossible de modifier une dépense approuvée");
        }

        // Validate amount
        if (amount.getAmount().compareTo(java.math.BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Le montant de la dépense doit être supérieur à 0");
        }

        // Validate category
        try {
            ExpenseCategory.valueOf(category.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new BusinessException("Catégorie de dépense invalide: " + category);
        }

        expense.setCategory(ExpenseCategory.valueOf(category.toUpperCase()));
        expense.setDescription(description);
        expense.setAmount(amount);
        expense.setPaymentMethod(paymentMethod);
        expense.setReference(reference);
        expense.setNotes(notes);

        return expenseRepository.save(expense);
    }

    @Override
    @Transactional
    public void deleteExpense(UUID expenseId) {
        Expense expense = getExpenseById(expenseId);

        if (expense.isApproved()) {
            throw new BusinessException("Impossible de supprimer une dépense approuvée");
        }

        expenseRepository.delete(expense);
    }

    @Override
    @Transactional
    public Expense approveExpense(UUID expenseId, String approvedBy) {
        Expense expense = getExpenseById(expenseId);
        expense.approve(approvedBy);
        return expenseRepository.save(expense);
    }

    @Override
    @Transactional
    public Expense rejectExpense(UUID expenseId, String reason) {
        Expense expense = getExpenseById(expenseId);
        expense.reject(reason);
        return expenseRepository.save(expense);
    }

    @Override
    @Transactional
    public Expense cancelExpense(UUID expenseId) {
        Expense expense = getExpenseById(expenseId);
        expense.cancel();
        return expenseRepository.save(expense);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByStore(UUID storeId) {
        return expenseRepository.findByStore_IdOrderByExpenseDateDesc(storeId);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Expense> getExpensesByStore(UUID storeId, Pageable pageable) {
        return expenseRepository.findByStore_IdOrderByExpenseDateDesc(storeId, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByStoreAndStatus(UUID storeId, ExpenseStatus status) {
        return expenseRepository.findByStore_IdAndStatusOrderByExpenseDateDesc(storeId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Expense> getExpensesByStoreAndStatus(UUID storeId, ExpenseStatus status, Pageable pageable) {
        return expenseRepository.findByStore_IdAndStatusOrderByExpenseDateDesc(storeId, status, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByStoreAndCategory(UUID storeId, String category) {
        return expenseRepository.findByStore_IdAndCategoryOrderByExpenseDateDesc(storeId, ExpenseCategory.valueOf(category.toUpperCase()));
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByStoreAndDateRange(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        return expenseRepository.findByStoreAndDateRange(storeId, startDate, endDate);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByStoreAndStatusAndDateRange(UUID storeId, ExpenseStatus status, 
                                                                LocalDateTime startDate, LocalDateTime endDate) {
        return expenseRepository.findByStoreAndStatusAndDateRange(storeId, status, startDate, endDate);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getPendingExpensesByStore(UUID storeId) {
        return expenseRepository.findByStore_IdAndStatusOrderByCreatedAtAsc(storeId, ExpenseStatus.PENDING);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Expense> getExpensesByPaymentMethod(UUID storeId, String paymentMethod) {
        return expenseRepository.findByStore_IdAndPaymentMethodOrderByExpenseDateDesc(storeId, paymentMethod);
    }

    @Override
    @Transactional(readOnly = true)
    public long countExpensesByStatus(UUID storeId, ExpenseStatus status) {
        return expenseRepository.countByStoreAndStatus(storeId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public Money getTotalAmountByStatus(UUID storeId, ExpenseStatus status) {
        Double total = expenseRepository.sumAmountByStoreAndStatus(storeId, status);
        return Money.of(total != null ? total : 0.0);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getTotalAmountByCategory(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        return expenseRepository.sumAmountByCategoryForStoreAndDateRange(storeId, startDate, endDate);
    }

    @Override
    @Transactional
    public void recordExpenseInSession(UUID expenseId, String sessionType) {
        Expense expense = getExpenseById(expenseId);
        
        // Get open session of the specified type
        UUID sessionId = switch (sessionType.toUpperCase()) {
            case "CASH" -> {
                CashSession session = sessionService.getOpenCashSession(expense.getStore().getId());
                if (session == null) {
                    throw new BusinessException("Aucune session cash ouverte pour ce magasin");
                }
                yield session.getId();
            }
            case "MOBILE" -> {
                MobileSession session = sessionService.getOpenMobileSession(expense.getStore().getId());
                if (session == null) {
                    throw new BusinessException("Aucune session mobile ouverte pour ce magasin");
                }
                yield session.getId();
            }
            case "OTHER" -> {
                OtherSession session = sessionService.getOpenOtherSession(expense.getStore().getId());
                if (session == null) {
                    throw new BusinessException("Aucune session other ouverte pour ce magasin");
                }
                yield session.getId();
            }
            default -> throw new BusinessException("Type de session invalide: " + sessionType);
        };

        // Record movement in session
        sessionService.recordMovement(
                sessionId.toString(),
                sessionType.toUpperCase(),
                MovementType.OUT,
                MovementReason.EXPENSE,
                expense.getAmount(),
                expense.getReference() != null ? expense.getReference() : "EXPENSE-" + expense.getId(),
                "EXPENSE",
                expense.getCreatedBy(),
                "expense-" + expense.getId()
        );
    }
}
