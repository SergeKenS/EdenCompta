package com.votreentreprise.pos.sessions.web.dto;

import com.votreentreprise.pos.sessions.domain.SessionMovement;

import java.time.LocalDateTime;
import java.util.UUID;

public class SessionMovementDto {
    private UUID id;
    private String sessionId;
    private String sessionType;
    private String type;
    private String reason;
    private String amount;
    private String reference;
    private String referenceType;
    private String description;
    private String createdBy;
    private LocalDateTime occurredAt;
    private String sourceOfflineId;

    public SessionMovementDto() {}

    public SessionMovementDto(UUID id, String sessionId, String sessionType, String type, String reason,
                             String amount, String reference, String referenceType, String description,
                             String createdBy, LocalDateTime occurredAt, String sourceOfflineId) {
        this.id = id;
        this.sessionId = sessionId;
        this.sessionType = sessionType;
        this.type = type;
        this.reason = reason;
        this.amount = amount;
        this.reference = reference;
        this.referenceType = referenceType;
        this.description = description;
        this.createdBy = createdBy;
        this.occurredAt = occurredAt;
        this.sourceOfflineId = sourceOfflineId;
    }

    public static SessionMovementDto fromEntity(SessionMovement movement) {
        return new SessionMovementDto(
                movement.getId(),
                movement.getSessionId(),
                movement.getSessionType(),
                movement.getType() != null ? movement.getType().name() : null,
                movement.getReason() != null ? movement.getReason().name() : null,
                movement.getAmount() != null ? movement.getAmount().getAmount().toString() : null,
                movement.getReference(),
                movement.getReferenceType(),
                movement.getDescription(),
                movement.getCreatedBy(),
                movement.getOccurredAt(),
                movement.getSourceOfflineId()
        );
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getAmount() { return amount; }
    public void setAmount(String amount) { this.amount = amount; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public String getReferenceType() { return referenceType; }
    public void setReferenceType(String referenceType) { this.referenceType = referenceType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getOccurredAt() { return occurredAt; }
    public void setOccurredAt(LocalDateTime occurredAt) { this.occurredAt = occurredAt; }

    public String getSourceOfflineId() { return sourceOfflineId; }
    public void setSourceOfflineId(String sourceOfflineId) { this.sourceOfflineId = sourceOfflineId; }
}
