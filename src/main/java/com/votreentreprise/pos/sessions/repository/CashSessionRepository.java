package com.votreentreprise.pos.sessions.repository;

import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.CashSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface CashSessionRepository extends JpaRepository<CashSession, UUID> {
    Optional<CashSession> findByStore_IdAndStatus(UUID storeId, SessionStatus status);
}
