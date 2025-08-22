package com.votreentreprise.pos.sessions.repository;

import com.votreentreprise.pos.common.types.SessionStatus;
import com.votreentreprise.pos.sessions.domain.OtherSession;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface OtherSessionRepository extends JpaRepository<OtherSession, UUID> {
    Optional<OtherSession> findByStore_IdAndStatus(UUID storeId, SessionStatus status);
}
