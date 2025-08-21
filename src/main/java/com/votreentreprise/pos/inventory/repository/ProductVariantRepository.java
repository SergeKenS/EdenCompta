package com.votreentreprise.pos.inventory.repository;

import com.votreentreprise.pos.inventory.domain.ProductVariant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProductVariantRepository extends JpaRepository<ProductVariant, UUID> {

    List<ProductVariant> findByProductIdAndIsActiveTrue(UUID productId);

    Optional<ProductVariant> findBySku(String sku);

    Optional<ProductVariant> findByBarcode(String barcode);

    @Query("SELECT pv FROM ProductVariant pv JOIN pv.product p " +
            "WHERE p.store.id = :storeId AND pv.isActive = true")
    List<ProductVariant> findActiveByStore(@Param("storeId") UUID storeId);

    boolean existsBySku(String sku);

    boolean existsByBarcode(String barcode);
}