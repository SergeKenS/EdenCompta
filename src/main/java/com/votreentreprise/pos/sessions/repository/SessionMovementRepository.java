package com.votreentreprise.pos.sessions.repository;

import com.votreentreprise.pos.sessions.domain.SessionMovement;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface SessionMovementRepository extends JpaRepository<SessionMovement, UUID> {
}
