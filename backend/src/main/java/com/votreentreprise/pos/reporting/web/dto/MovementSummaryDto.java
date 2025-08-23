package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.util.Map;

public class MovementSummaryDto {
    private Map<String, BigDecimal> movementsByReason;
    private Map<String, BigDecimal> movementsByType;
    private int totalMovements;
    private BigDecimal totalAmount;

    public MovementSummaryDto() {}

    public MovementSummaryDto(Map<String, BigDecimal> movementsByReason, Map<String, BigDecimal> movementsByType,
                             int totalMovements, BigDecimal totalAmount) {
        this.movementsByReason = movementsByReason;
        this.movementsByType = movementsByType;
        this.totalMovements = totalMovements;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public Map<String, BigDecimal> getMovementsByReason() { return movementsByReason; }
    public void setMovementsByReason(Map<String, BigDecimal> movementsByReason) { this.movementsByReason = movementsByReason; }

    public Map<String, BigDecimal> getMovementsByType() { return movementsByType; }
    public void setMovementsByType(Map<String, BigDecimal> movementsByType) { this.movementsByType = movementsByType; }

    public int getTotalMovements() { return totalMovements; }
    public void setTotalMovements(int totalMovements) { this.totalMovements = totalMovements; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}

