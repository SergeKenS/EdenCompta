package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

public record DashboardSummaryDto(
        BigDecimal totalSales,
        BigDecimal totalExpenses,
        BigDecimal totalNetCashflow,
        BigDecimal totalCash,
        BigDecimal totalMobile,
        List<TopProductDto> topProducts,
        List<LowStockItem> lowStockProducts,
        List<OutOfStockItem> outOfStockProducts
) {
    public record LowStockItem(UUID productId, String name, BigDecimal stock) {}
    public record OutOfStockItem(UUID productId, String name) {}
}


