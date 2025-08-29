package com.votreentreprise.pos.sales.repository;

import com.votreentreprise.pos.sales.domain.ReceiptLine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Repository
public interface ReceiptLineRepository extends JpaRepository<ReceiptLine, UUID> {
    
    /**
     * Trouve les produits les plus vendus par quantité pour un magasin dans une période donnée
     */
    @Query("SELECT rl.variant.id, rl.variant.name, p.name as productName, p.category, SUM(rl.quantity.value) as totalQuantity " +
           "FROM ReceiptLine rl " +
           "JOIN rl.receipt r " +
           "JOIN rl.variant v " +
           "JOIN v.product p " +
           "WHERE r.store.id = :storeId " +
           "AND r.status = 'FINALIZED' " +
           "AND (:categoryId IS NULL OR p.category = :categoryId) " +
           "AND (:fromDate IS NULL OR r.finalizedAt >= :fromDate) " +
           "AND (:toDate IS NULL OR r.finalizedAt <= :toDate) " +
           "GROUP BY rl.variant.id, rl.variant.name, p.name, p.category " +
           "ORDER BY totalQuantity DESC")
    List<Object[]> findTopSellersByQuantity(@Param("storeId") UUID storeId,
                                           @Param("categoryId") String categoryId,
                                           @Param("fromDate") LocalDateTime fromDate,
                                           @Param("toDate") LocalDateTime toDate);
}


