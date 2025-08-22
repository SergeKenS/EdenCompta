package com.votreentreprise.pos.sessions.domain;

import com.votreentreprise.pos.common.audit.AuditableEntity;
import com.votreentreprise.pos.common.types.Money;
import com.votreentreprise.pos.common.types.MovementReason;
import com.votreentreprise.pos.common.types.MovementType;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "session_movements")
public class SessionMovement extends AuditableEntity {

    @Column(name = "session_id", nullable = false)
    private String sessionId; // UUID as string for flexibility

    @Column(name = "session_type", nullable = false)
    private String sessionType; // CASH, MOBILE, OTHER

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private MovementType type;

    @Enumerated(EnumType.STRING)
    @Column(name = "reason", nullable = false)
    private MovementReason reason;

    @Embedded
    @AttributeOverride(name = "amount", column = @Column(name = "amount"))
    private Money amount;

    @Column(name = "reference")
    private String reference; // ID du reçu, de la dépense, etc.

    @Column(name = "reference_type")
    private String referenceType; // Type de référence

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "occurred_at", nullable = false)
    private LocalDateTime occurredAt;

    @Column(name = "source_offline_id")
    private String sourceOfflineId; // Pour l'idempotence

    // Relationships to specific session types (only one will be set)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cash_session_id")
    private CashSession cashSession;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mobile_session_id")
    private MobileSession mobileSession;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "other_session_id")
    private OtherSession otherSession;

    public SessionMovement() {}

    public SessionMovement(String sessionId, String sessionType, MovementType type, 
                          MovementReason reason, Money amount, String reference, 
                          String referenceType, String createdBy) {
        this.sessionId = sessionId;
        this.sessionType = sessionType;
        this.type = type;
        this.reason = reason;
        this.amount = amount;
        this.reference = reference;
        this.referenceType = referenceType;
        this.createdBy = createdBy;
        this.occurredAt = LocalDateTime.now();
    }

    // Getters and Setters
    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public MovementType getType() { return type; }
    public void setType(MovementType type) { this.type = type; }

    public MovementReason getReason() { return reason; }
    public void setReason(MovementReason reason) { this.reason = reason; }

    public Money getAmount() { return amount; }
    public void setAmount(Money amount) { this.amount = amount; }

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

    // Session relationships
    public CashSession getCashSession() { return cashSession; }
    public void setCashSession(CashSession cashSession) { this.cashSession = cashSession; }

    public MobileSession getMobileSession() { return mobileSession; }
    public void setMobileSession(MobileSession mobileSession) { this.mobileSession = mobileSession; }

    public OtherSession getOtherSession() { return otherSession; }
    public void setOtherSession(OtherSession otherSession) { this.otherSession = otherSession; }
}
