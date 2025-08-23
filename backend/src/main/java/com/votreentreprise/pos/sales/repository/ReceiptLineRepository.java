package com.votreentreprise.pos.sales.repository;

import com.votreentreprise.pos.sales.domain.ReceiptLine;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ReceiptLineRepository extends JpaRepository<ReceiptLine, UUID> {}


