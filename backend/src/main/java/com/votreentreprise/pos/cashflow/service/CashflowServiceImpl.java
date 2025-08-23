package com.votreentreprise.pos.cashflow.service;

import com.votreentreprise.pos.cashflow.domain.CashMovement;
import com.votreentreprise.pos.cashflow.repository.CashMovementRepository;
import com.votreentreprise.pos.common.exceptions.BusinessException;
import com.votreentreprise.pos.common.exceptions.ResourceNotFoundException;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.store.domain.Store;
import com.votreentreprise.pos.store.repository.StoreRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
public class CashflowServiceImpl implements CashflowService {

    private final CashMovementRepository cashMovementRepository;
    private final StoreRepository storeRepository;

    public CashflowServiceImpl(CashMovementRepository cashMovementRepository, StoreRepository storeRepository) {
        this.cashMovementRepository = cashMovementRepository;
        this.storeRepository = storeRepository;
    }

    @Override
    public CashMovement createMovement(UUID storeId, CashMovementType movementType, CashMovementReason reason,
                                      Money amount, String reference, String referenceType, String description,
                                      String createdBy, String sourceOfflineId) {
        
        // Check idempotency
        if (sourceOfflineId != null) {
            CashMovement existing = getMovementBySourceOfflineId(storeId, sourceOfflineId);
            if (existing != null) {
                return existing;
            }
        }

        // Validate store exists
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new ResourceNotFoundException("Store not found with id: " + storeId));

        // Validate amount
        if (amount == null || amount.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Amount must be greater than zero");
        }

        // Create movement
        CashMovement movement = new CashMovement(store, movementType, reason, amount, reference, 
                                                referenceType, description, createdBy);
        movement.setSourceOfflineId(sourceOfflineId);

        return cashMovementRepository.save(movement);
    }

    @Override
    public CashMovement getMovementById(UUID movementId) {
        return cashMovementRepository.findById(movementId)
                .orElseThrow(() -> new ResourceNotFoundException("Cash movement not found with id: " + movementId));
    }

    @Override
    public CashMovement updateMovement(UUID movementId, CashMovementType movementType, CashMovementReason reason,
                                      Money amount, String reference, String referenceType, String description) {
        
        CashMovement movement = getMovementById(movementId);
        
        // Validate amount
        if (amount != null && amount.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Amount must be greater than zero");
        }

        // Update fields
        if (movementType != null) movement.setMovementType(movementType);
        if (reason != null) movement.setReason(reason);
        if (amount != null) movement.setAmount(amount);
        if (reference != null) movement.setReference(reference);
        if (referenceType != null) movement.setReferenceType(referenceType);
        if (description != null) movement.setDescription(description);

        return cashMovementRepository.save(movement);
    }

    @Override
    public void deleteMovement(UUID movementId) {
        CashMovement movement = getMovementById(movementId);
        cashMovementRepository.delete(movement);
    }

    @Override
    public List<CashMovement> getMovementsByStore(UUID storeId) {
        return cashMovementRepository.findByStoreIdOrderByMovementDateDesc(storeId);
    }

    @Override
    public Page<CashMovement> getMovementsByStore(UUID storeId, Pageable pageable) {
        return cashMovementRepository.findByStoreIdOrderByMovementDateDesc(storeId, pageable);
    }

    @Override
    public List<CashMovement> getMovementsByStoreAndDateRange(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        return cashMovementRepository.findByStoreIdAndMovementDateBetweenOrderByMovementDateDesc(storeId, startDate, endDate);
    }

    @Override
    public List<CashMovement> getMovementsByStoreAndType(UUID storeId, CashMovementType movementType) {
        return cashMovementRepository.findByStoreIdAndMovementTypeOrderByMovementDateDesc(storeId, movementType);
    }

    @Override
    public List<CashMovement> getMovementsByStoreAndReason(UUID storeId, CashMovementReason reason) {
        return cashMovementRepository.findByStoreIdAndReasonOrderByMovementDateDesc(storeId, reason);
    }

    @Override
    public List<CashMovement> getMovementsByStoreAndTypeAndDateRange(UUID storeId, CashMovementType movementType,
                                                                   LocalDateTime startDate, LocalDateTime endDate) {
        return cashMovementRepository.findByStoreIdAndMovementTypeAndMovementDateBetweenOrderByMovementDateDesc(
                storeId, movementType, startDate, endDate);
    }

    @Override
    public Map<CashMovementType, Money> getTotalAmountsByType(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        List<Object[]> results = cashMovementRepository.getTotalAmountsByType(storeId, startDate, endDate);
        Map<CashMovementType, Money> totals = new HashMap<>();
        
        for (Object[] result : results) {
            CashMovementType type = (CashMovementType) result[0];
            BigDecimal amount = (BigDecimal) result[1];
            totals.put(type, Money.of(amount));
        }
        
        return totals;
    }

    @Override
    public Map<CashMovementReason, Money> getTotalAmountsByReason(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        List<Object[]> results = cashMovementRepository.getTotalAmountsByReason(storeId, startDate, endDate);
        Map<CashMovementReason, Money> totals = new HashMap<>();
        
        for (Object[] result : results) {
            CashMovementReason reason = (CashMovementReason) result[0];
            BigDecimal amount = (BigDecimal) result[1];
            totals.put(reason, Money.of(amount));
        }
        
        return totals;
    }

    @Override
    public Money getNetCashflow(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        Map<CashMovementType, Money> totalsByType = getTotalAmountsByType(storeId, startDate, endDate);
        
        Money totalIn = totalsByType.getOrDefault(CashMovementType.IN, Money.zero());
        Money totalOut = totalsByType.getOrDefault(CashMovementType.OUT, Money.zero());
        
        return Money.of(totalIn.getAmount().subtract(totalOut.getAmount()));
    }

    @Override
    public long getMovementCount(UUID storeId, LocalDateTime startDate, LocalDateTime endDate) {
        return cashMovementRepository.countByStoreIdAndMovementDateBetween(storeId, startDate, endDate);
    }

    @Override
    public CashMovement recordCashIn(UUID storeId, CashMovementReason reason, Money amount, String reference,
                                    String referenceType, String description, String createdBy, String sourceOfflineId) {
        return createMovement(storeId, CashMovementType.IN, reason, amount, reference, referenceType, 
                            description, createdBy, sourceOfflineId);
    }

    @Override
    public CashMovement recordCashOut(UUID storeId, CashMovementReason reason, Money amount, String reference,
                                     String referenceType, String description, String createdBy, String sourceOfflineId) {
        return createMovement(storeId, CashMovementType.OUT, reason, amount, reference, referenceType, 
                            description, createdBy, sourceOfflineId);
    }

    @Override
    public CashMovement getMovementBySourceOfflineId(UUID storeId, String sourceOfflineId) {
        return cashMovementRepository.findByStoreIdAndSourceOfflineId(storeId, sourceOfflineId).orElse(null);
    }
}


