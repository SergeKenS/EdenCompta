package com.votreentreprise.pos.sales.repository;

import com.votreentreprise.pos.sales.domain.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PaymentRepository extends JpaRepository<Payment, UUID> {}


