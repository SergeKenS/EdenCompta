package com.votreentreprise.pos.cashflow.web.dto;

import com.votreentreprise.pos.common.types.CashMovementType;
import com.votreentreprise.pos.common.types.CashMovementReason;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

public record CashflowSummaryDto(
        UUID storeId,
        String storeName,
        LocalDateTime startDate,
        LocalDateTime endDate,
        BigDecimal totalIn,
        BigDecimal totalOut,
        BigDecimal netCashflow,
        long movementCount,
        Map<CashMovementType, BigDecimal> totalsByType,
        Map<CashMovementReason, BigDecimal> totalsByReason
) {
    
    public static CashflowSummaryDto create(UUID storeId, String storeName, LocalDateTime startDate, LocalDateTime endDate,
                                           BigDecimal totalIn, BigDecimal totalOut, BigDecimal netCashflow, long movementCount,
                                           Map<CashMovementType, BigDecimal> totalsByType,
                                           Map<CashMovementReason, BigDecimal> totalsByReason) {
        return new CashflowSummaryDto(
                storeId,
                storeName,
                startDate,
                endDate,
                totalIn,
                totalOut,
                netCashflow,
                movementCount,
                totalsByType,
                totalsByReason
        );
    }
}


