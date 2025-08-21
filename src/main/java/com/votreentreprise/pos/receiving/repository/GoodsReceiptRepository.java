package com.votreentreprise.pos.receiving.repository;

import com.votreentreprise.pos.receiving.domain.GoodsReceipt;
import com.votreentreprise.pos.common.types.ReceiptStatusType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface GoodsReceiptRepository extends JpaRepository<GoodsReceipt, UUID> {

    List<GoodsReceipt> findByStoreIdAndReceivedAtBetweenOrderByReceivedAtDesc(
            UUID storeId, LocalDateTime from, LocalDateTime to);

    List<GoodsReceipt> findByStoreIdOrderByReceivedAtDesc(UUID storeId);

    List<GoodsReceipt> findByStatus(ReceiptStatusType status);

    Optional<GoodsReceipt> findBySourceOfflineId(String sourceOfflineId);

    @Query("SELECT gr FROM GoodsReceipt gr WHERE gr.store.id = :storeId " +
            "AND gr.receivedAt >= :from AND gr.receivedAt <= :to " +
            "AND (:status IS NULL OR gr.status = :status)")
    List<GoodsReceipt> findByStoreAndDateRangeAndStatus(
            @Param("storeId") UUID storeId,
            @Param("from") LocalDateTime from,
            @Param("to") LocalDateTime to,
            @Param("status") ReceiptStatusType status);

    @Query("SELECT COUNT(gr) FROM GoodsReceipt gr WHERE gr.store.id = :storeId " +
            "AND gr.status = :status")
    long countByStoreAndStatus(@Param("storeId") UUID storeId,
                               @Param("status") ReceiptStatusType status);
}