package com.votreentreprise.pos.sessions.web.dto;

import com.votreentreprise.pos.sessions.domain.MobileSession;

import java.time.LocalDateTime;
import java.util.UUID;

public class MobileSessionDto {
    private UUID id;
    private UUID storeId;
    private String userId;
    private LocalDateTime openedAt;
    private LocalDateTime closedAt;
    private String initialAmount;
    private String totalIn;
    private String totalOut;
    private String realClosingAmount;
    private String discrepancy;
    private String note;
    private String status;

    public MobileSessionDto() {}

    public MobileSessionDto(UUID id, UUID storeId, String userId, LocalDateTime openedAt, LocalDateTime closedAt,
                           String initialAmount, String totalIn, String totalOut, String realClosingAmount,
                           String discrepancy, String note, String status) {
        this.id = id;
        this.storeId = storeId;
        this.userId = userId;
        this.openedAt = openedAt;
        this.closedAt = closedAt;
        this.initialAmount = initialAmount;
        this.totalIn = totalIn;
        this.totalOut = totalOut;
        this.realClosingAmount = realClosingAmount;
        this.discrepancy = discrepancy;
        this.note = note;
        this.status = status;
    }

    public static MobileSessionDto fromEntity(MobileSession session) {
        return new MobileSessionDto(
                session.getId(),
                session.getStore() != null ? session.getStore().getId() : null,
                session.getUserId(),
                session.getOpenedAt(),
                session.getClosedAt(),
                session.getInitialAmount() != null ? session.getInitialAmount().getAmount().toString() : null,
                session.getTotalIn() != null ? session.getTotalIn().getAmount().toString() : null,
                session.getTotalOut() != null ? session.getTotalOut().getAmount().toString() : null,
                session.getRealClosingAmount() != null ? session.getRealClosingAmount().getAmount().toString() : null,
                session.getDiscrepancy() != null ? session.getDiscrepancy().getAmount().toString() : null,
                session.getNote(),
                session.getStatus() != null ? session.getStatus().name() : null
        );
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getStoreId() { return storeId; }
    public void setStoreId(UUID storeId) { this.storeId = storeId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public LocalDateTime getOpenedAt() { return openedAt; }
    public void setOpenedAt(LocalDateTime openedAt) { this.openedAt = openedAt; }

    public LocalDateTime getClosedAt() { return closedAt; }
    public void setClosedAt(LocalDateTime closedAt) { this.closedAt = closedAt; }

    public String getInitialAmount() { return initialAmount; }
    public void setInitialAmount(String initialAmount) { this.initialAmount = initialAmount; }

    public String getTotalIn() { return totalIn; }
    public void setTotalIn(String totalIn) { this.totalIn = totalIn; }

    public String getTotalOut() { return totalOut; }
    public void setTotalOut(String totalOut) { this.totalOut = totalOut; }

    public String getRealClosingAmount() { return realClosingAmount; }
    public void setRealClosingAmount(String realClosingAmount) { this.realClosingAmount = realClosingAmount; }

    public String getDiscrepancy() { return discrepancy; }
    public void setDiscrepancy(String discrepancy) { this.discrepancy = discrepancy; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

