package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

public class ZReportDto {
    private UUID id;
    private UUID storeId;
    private LocalDate reportDate;
    private LocalDateTime generatedAt;
    private String generatedBy;
    
    // Totaux par type de session
    private SessionTotalsDto cashSession;
    private SessionTotalsDto mobileSession;
    private SessionTotalsDto otherSession;
    
    // Totaux globaux
    private BigDecimal totalInitialAmount;
    private BigDecimal totalIn;
    private BigDecimal totalOut;
    private BigDecimal totalExpectedAmount;
    private BigDecimal totalRealClosingAmount;
    private BigDecimal totalDiscrepancy;
    
    // Résumé des mouvements
    private MovementSummaryDto movementSummary;

    public ZReportDto() {}

    public ZReportDto(UUID id, UUID storeId, LocalDate reportDate, LocalDateTime generatedAt, String generatedBy,
                      SessionTotalsDto cashSession, SessionTotalsDto mobileSession, SessionTotalsDto otherSession,
                      BigDecimal totalInitialAmount, BigDecimal totalIn, BigDecimal totalOut, BigDecimal totalExpectedAmount,
                      BigDecimal totalRealClosingAmount, BigDecimal totalDiscrepancy, MovementSummaryDto movementSummary) {
        this.id = id;
        this.storeId = storeId;
        this.reportDate = reportDate;
        this.generatedAt = generatedAt;
        this.generatedBy = generatedBy;
        this.cashSession = cashSession;
        this.mobileSession = mobileSession;
        this.otherSession = otherSession;
        this.totalInitialAmount = totalInitialAmount;
        this.totalIn = totalIn;
        this.totalOut = totalOut;
        this.totalExpectedAmount = totalExpectedAmount;
        this.totalRealClosingAmount = totalRealClosingAmount;
        this.totalDiscrepancy = totalDiscrepancy;
        this.movementSummary = movementSummary;
    }

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getStoreId() { return storeId; }
    public void setStoreId(UUID storeId) { this.storeId = storeId; }

    public LocalDate getReportDate() { return reportDate; }
    public void setReportDate(LocalDate reportDate) { this.reportDate = reportDate; }

    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }

    public String getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(String generatedBy) { this.generatedBy = generatedBy; }

    public SessionTotalsDto getCashSession() { return cashSession; }
    public void setCashSession(SessionTotalsDto cashSession) { this.cashSession = cashSession; }

    public SessionTotalsDto getMobileSession() { return mobileSession; }
    public void setMobileSession(SessionTotalsDto mobileSession) { this.mobileSession = mobileSession; }

    public SessionTotalsDto getOtherSession() { return otherSession; }
    public void setOtherSession(SessionTotalsDto otherSession) { this.otherSession = otherSession; }

    public BigDecimal getTotalInitialAmount() { return totalInitialAmount; }
    public void setTotalInitialAmount(BigDecimal totalInitialAmount) { this.totalInitialAmount = totalInitialAmount; }

    public BigDecimal getTotalIn() { return totalIn; }
    public void setTotalIn(BigDecimal totalIn) { this.totalIn = totalIn; }

    public BigDecimal getTotalOut() { return totalOut; }
    public void setTotalOut(BigDecimal totalOut) { this.totalOut = totalOut; }

    public BigDecimal getTotalExpectedAmount() { return totalExpectedAmount; }
    public void setTotalExpectedAmount(BigDecimal totalExpectedAmount) { this.totalExpectedAmount = totalExpectedAmount; }

    public BigDecimal getTotalRealClosingAmount() { return totalRealClosingAmount; }
    public void setTotalRealClosingAmount(BigDecimal totalRealClosingAmount) { this.totalRealClosingAmount = totalRealClosingAmount; }

    public BigDecimal getTotalDiscrepancy() { return totalDiscrepancy; }
    public void setTotalDiscrepancy(BigDecimal totalDiscrepancy) { this.totalDiscrepancy = totalDiscrepancy; }

    public MovementSummaryDto getMovementSummary() { return movementSummary; }
    public void setMovementSummary(MovementSummaryDto movementSummary) { this.movementSummary = movementSummary; }
}

