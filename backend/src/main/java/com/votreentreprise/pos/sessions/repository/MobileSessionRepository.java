package com.votreentreprise.pos.sessions.repository;

import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.MobileSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface MobileSessionRepository extends JpaRepository<MobileSession, UUID> {
    Optional<MobileSession> findByStore_IdAndStatus(UUID storeId, SessionStatus status);
}
