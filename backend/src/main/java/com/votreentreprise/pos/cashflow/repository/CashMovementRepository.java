package com.votreentreprise.pos.cashflow.repository;

import com.votreentreprise.pos.cashflow.domain.CashMovement;
import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CashMovementRepository extends JpaRepository<CashMovement, UUID> {

    // Find by store
    List<CashMovement> findByStoreIdOrderByMovementDateDesc(UUID storeId);
    
    Page<CashMovement> findByStoreIdOrderByMovementDateDesc(UUID storeId, Pageable pageable);

    // Find by store and date range
    List<CashMovement> findByStoreIdAndMovementDateBetweenOrderByMovementDateDesc(
            UUID storeId, LocalDateTime startDate, LocalDateTime endDate);

    // Find by store and movement type
    List<CashMovement> findByStoreIdAndMovementTypeOrderByMovementDateDesc(UUID storeId, CashMovementType movementType);

    // Find by store and reason
    List<CashMovement> findByStoreIdAndReasonOrderByMovementDateDesc(UUID storeId, CashMovementReason reason);

    // Find by store, type and date range
    List<CashMovement> findByStoreIdAndMovementTypeAndMovementDateBetweenOrderByMovementDateDesc(
            UUID storeId, CashMovementType movementType, LocalDateTime startDate, LocalDateTime endDate);

    // Find by reference (for idempotency)
    Optional<CashMovement> findByStoreIdAndSourceOfflineId(UUID storeId, String sourceOfflineId);

    // Find by reference type and reference
    List<CashMovement> findByStoreIdAndReferenceTypeAndReferenceOrderByMovementDateDesc(
            UUID storeId, String referenceType, String reference);

    // Get total amounts by type for a store and date range
    @Query("SELECT cm.movementType, SUM(cm.amount.amount) FROM CashMovement cm " +
           "WHERE cm.store.id = :storeId AND cm.movementDate BETWEEN :startDate AND :endDate " +
           "GROUP BY cm.movementType")
    List<Object[]> getTotalAmountsByType(@Param("storeId") UUID storeId, 
                                        @Param("startDate") LocalDateTime startDate, 
                                        @Param("endDate") LocalDateTime endDate);

    // Get total amounts by reason for a store and date range
    @Query("SELECT cm.reason, SUM(cm.amount.amount) FROM CashMovement cm " +
           "WHERE cm.store.id = :storeId AND cm.movementDate BETWEEN :startDate AND :endDate " +
           "GROUP BY cm.reason")
    List<Object[]> getTotalAmountsByReason(@Param("storeId") UUID storeId, 
                                          @Param("startDate") LocalDateTime startDate, 
                                          @Param("endDate") LocalDateTime endDate);

    // Count movements by store and date range
    long countByStoreIdAndMovementDateBetween(UUID storeId, LocalDateTime startDate, LocalDateTime endDate);
}


