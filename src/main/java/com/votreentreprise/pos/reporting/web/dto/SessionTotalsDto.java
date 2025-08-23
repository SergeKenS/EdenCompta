package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.util.UUID;

public class SessionTotalsDto {
    private UUID sessionId;
    private String sessionType;
    private BigDecimal initialAmount;
    private BigDecimal totalIn;
    private BigDecimal totalOut;
    private BigDecimal expectedAmount;
    private BigDecimal realClosingAmount;
    private BigDecimal discrepancy;
    private String status;

    public SessionTotalsDto() {}

    public SessionTotalsDto(UUID sessionId, String sessionType, BigDecimal initialAmount, BigDecimal totalIn,
                           BigDecimal totalOut, BigDecimal expectedAmount, BigDecimal realClosingAmount,
                           BigDecimal discrepancy, String status) {
        this.sessionId = sessionId;
        this.sessionType = sessionType;
        this.initialAmount = initialAmount;
        this.totalIn = totalIn;
        this.totalOut = totalOut;
        this.expectedAmount = expectedAmount;
        this.realClosingAmount = realClosingAmount;
        this.discrepancy = discrepancy;
        this.status = status;
    }

    // Getters and Setters
    public UUID getSessionId() { return sessionId; }
    public void setSessionId(UUID sessionId) { this.sessionId = sessionId; }

    public String getSessionType() { return sessionType; }
    public void setSessionType(String sessionType) { this.sessionType = sessionType; }

    public BigDecimal getInitialAmount() { return initialAmount; }
    public void setInitialAmount(BigDecimal initialAmount) { this.initialAmount = initialAmount; }

    public BigDecimal getTotalIn() { return totalIn; }
    public void setTotalIn(BigDecimal totalIn) { this.totalIn = totalIn; }

    public BigDecimal getTotalOut() { return totalOut; }
    public void setTotalOut(BigDecimal totalOut) { this.totalOut = totalOut; }

    public BigDecimal getExpectedAmount() { return expectedAmount; }
    public void setExpectedAmount(BigDecimal expectedAmount) { this.expectedAmount = expectedAmount; }

    public BigDecimal getRealClosingAmount() { return realClosingAmount; }
    public void setRealClosingAmount(BigDecimal realClosingAmount) { this.realClosingAmount = realClosingAmount; }

    public BigDecimal getDiscrepancy() { return discrepancy; }
    public void setDiscrepancy(BigDecimal discrepancy) { this.discrepancy = discrepancy; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

