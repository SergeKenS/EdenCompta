package com.votreentreprise.pos.inventory.repository;

import com.votreentreprise.pos.inventory.domain.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {

    List<Product> findByStoreIdAndIsActiveTrue(UUID storeId);

    List<Product> findByStoreIdAndNameContainingIgnoreCase(UUID storeId, String name);

    List<Product> findByStoreIdAndCategory(UUID storeId, String category);
}