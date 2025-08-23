package com.votreentreprise.pos.sales.repository;

import com.votreentreprise.pos.sales.domain.Receipt;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ReceiptRepository extends JpaRepository<Receipt, UUID> {
    Optional<Receipt> findByStore_IdAndReceiptNumber(UUID storeId, String receiptNumber);
}


