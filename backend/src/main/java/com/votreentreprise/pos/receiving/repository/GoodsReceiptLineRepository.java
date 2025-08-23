package com.votreentreprise.pos.receiving.repository;

import com.votreentreprise.pos.receiving.domain.GoodsReceiptLine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface GoodsReceiptLineRepository extends JpaRepository<GoodsReceiptLine, UUID> {

    List<GoodsReceiptLine> findByReceiptIdOrderByLineNumber(UUID receiptId);

    List<GoodsReceiptLine> findByVariantId(UUID variantId);

    @Query("SELECT grl FROM GoodsReceiptLine grl " +
            "JOIN grl.receipt gr " +
            "WHERE grl.variant.id = :variantId " +
            "AND gr.receivedAt >= :from AND gr.receivedAt <= :to " +
            "ORDER BY gr.receivedAt DESC")
    List<GoodsReceiptLine> findByVariantAndDateRange(
            @Param("variantId") UUID variantId,
            @Param("from") LocalDateTime from,
            @Param("to") LocalDateTime to);

    @Query("SELECT SUM(grl.quantityReceived.value) FROM GoodsReceiptLine grl " +
            "JOIN grl.receipt gr " +
            "WHERE grl.variant.id = :variantId " +
            "AND gr.status = 'RECEIVED'")
    Double getTotalReceivedQuantityByVariant(@Param("variantId") UUID variantId);
}