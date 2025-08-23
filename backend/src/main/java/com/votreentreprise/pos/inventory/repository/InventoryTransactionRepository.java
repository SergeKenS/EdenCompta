package com.votreentreprise.pos.inventory.repository;

import com.votreentreprise.pos.inventory.domain.InventoryTransaction;
import com.votreentreprise.pos.common.types.TransactionType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface InventoryTransactionRepository extends JpaRepository<InventoryTransaction, UUID> {

    List<InventoryTransaction> findByStoreIdAndOccurredAtBetweenOrderByOccurredAtDesc(
            UUID storeId, LocalDateTime from, LocalDateTime to);

    List<InventoryTransaction> findByVariantIdOrderByOccurredAtDesc(UUID variantId);

    List<InventoryTransaction> findByStoreIdAndTransactionType(UUID storeId, TransactionType type);

    Optional<InventoryTransaction> findBySourceOfflineId(String sourceOfflineId);

    @Query("SELECT it FROM InventoryTransaction it " +
            "WHERE it.referenceId = :referenceId AND it.referenceType = :referenceType")
    List<InventoryTransaction> findByReference(@Param("referenceId") String referenceId,
                                               @Param("referenceType") String referenceType);
}