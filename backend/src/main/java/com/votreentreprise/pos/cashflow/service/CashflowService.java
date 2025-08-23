package com.votreentreprise.pos.cashflow.service;

import com.votreentreprise.pos.cashflow.domain.CashMovement;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;
import com.votreentreprise.pos.common.types.Money;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface CashflowService {

    // CRUD operations
    CashMovement createMovement(UUID storeId, CashMovementType movementType, CashMovementReason reason,
                               Money amount, String reference, String referenceType, String description,
                               String createdBy, String sourceOfflineId);

    CashMovement getMovementById(UUID movementId);

    CashMovement updateMovement(UUID movementId, CashMovementType movementType, CashMovementReason reason,
                               Money amount, String reference, String referenceType, String description);

    void deleteMovement(UUID movementId);

    // Query operations
    List<CashMovement> getMovementsByStore(UUID storeId);

    Page<CashMovement> getMovementsByStore(UUID storeId, Pageable pageable);

    List<CashMovement> getMovementsByStoreAndDateRange(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    List<CashMovement> getMovementsByStoreAndType(UUID storeId, CashMovementType movementType);

    List<CashMovement> getMovementsByStoreAndReason(UUID storeId, CashMovementReason reason);

    List<CashMovement> getMovementsByStoreAndTypeAndDateRange(UUID storeId, CashMovementType movementType,
                                                             LocalDateTime startDate, LocalDateTime endDate);

    // Reporting operations
    Map<CashMovementType, Money> getTotalAmountsByType(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    Map<CashMovementReason, Money> getTotalAmountsByReason(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    Money getNetCashflow(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    long getMovementCount(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    // Business operations
    CashMovement recordCashIn(UUID storeId, CashMovementReason reason, Money amount, String reference,
                             String referenceType, String description, String createdBy, String sourceOfflineId);

    CashMovement recordCashOut(UUID storeId, CashMovementReason reason, Money amount, String reference,
                              String referenceType, String description, String createdBy, String sourceOfflineId);

    // Idempotency check
    CashMovement getMovementBySourceOfflineId(UUID storeId, String sourceOfflineId);
}


