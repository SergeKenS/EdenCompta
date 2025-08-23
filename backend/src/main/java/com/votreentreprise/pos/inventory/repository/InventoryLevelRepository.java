package com.votreentreprise.pos.inventory.repository;

import com.votreentreprise.pos.inventory.domain.InventoryLevel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface InventoryLevelRepository extends JpaRepository<InventoryLevel, UUID> {

    Optional<InventoryLevel> findByStoreIdAndVariantId(UUID storeId, UUID variantId);

    List<InventoryLevel> findByStoreId(UUID storeId);

    List<InventoryLevel> findByVariantId(UUID variantId);

    @Query("SELECT il FROM InventoryLevel il WHERE il.store.id = :storeId " +
            "AND il.quantityOnHand.value > 0")
    List<InventoryLevel> findInStockByStore(@Param("storeId") UUID storeId);

    @Query("SELECT il FROM InventoryLevel il WHERE il.store.id = :storeId " +
            "AND il.quantityOnHand.value <= 0")
    List<InventoryLevel> findOutOfStockByStore(@Param("storeId") UUID storeId);
}